import cv2
import imutils
import numpy as np
import argparse
import os
from pythonosc import udp_client

from joblib import dump,load
from hand_detection_utils import *
from SVM import *

# Background subtraction and stuff
# https://gogul.dev/software/hand-gesture-recognition-p1
# https://gogul.dev/software/hand-gesture-recognition-p2

# global variables
#bg = None
dirname = os.path.dirname(__file__)

# Find running average over background

# -----------------
# MAIN FUNCTION
# -----------------


if __name__ == "__main__":

	# Usage info
	print('USAGE:')
	print('	-Before training generate the images for the the two classes press "a" for class 1 and "b" for class 2:')
	print('		-Press "a" to save class A images')
	print('		-Press "b" to save class B images')
	print('	-Press "t" to start SVM training (if a model has already been saved, it will be loaded)')
	print('	-Press "s" to start sound generation (must be pressed after training)')
	print('	-Press "q" to stop sound and "q" to stop image capture')

	# initialize weight for running average
	aWeight = 0.5

	num_frames_train = 0

	# get the reference to the webcam
	camera = cv2.VideoCapture(0)


	# Initialize variables
	TRAIN = False  # If True, images for the classes are generated
	SVM = False  # If True classification is performed
	START_SOUND = False  # If True OSC communication with SC is started
	hand = None

	# ROI (region of interest) coordinates
	top, right, bottom, left = 10, 350, 225, 590

	# Dimensions of the image considered for hand detection
	height_roi = bottom - top
	width_roi = left - right

	# initialize num of frames
	num_frames = 0

	# keep looping, until interrupted
	while True:
		# get the current frame
		(grabbed, frame) = camera.read()

		# resize the frame
		frame = imutils.resize(frame, width=700)

		# flip the frame so that it is not the mirror view
		frame = cv2.flip(frame, 1)

		# clone the frame
		clone = frame.copy()
	
		# get the height and width of the frame
		(height, width) = frame.shape[:2]
		
		# get the ROI
		roi = frame[top:bottom, right:left]

		# convert the roi to grayscale and blur it
		gray = cv2.cvtColor(roi, cv2.COLOR_BGR2GRAY)
		gray = cv2.GaussianBlur(gray, (7, 7), 0)
		
		
		# to get the background, keep looking till a threshold is reached
		# so that our running average model gets calibrated
		if num_frames < 30:
			run_avg(gray, aWeight)
		else:
			
			# segment the hand region
			hand = segment(gray)
			
			# check whether hand region is segmented
			if hand is not None:
				# if yes, unpack the thresholded image and
				# segmented region
				(thresholded, segmented) = hand

				# draw the segmented region and display the frame
				cv2.drawContours(clone, [segmented + (right, top)], -1, (0, 0, 255))	
				
				# Center of the hand
				c_x, c_y = detect_palm_center(segmented)
				# alternative method
				# c_x, c_y = detect_palm_center_centroid(thresholded)
				radius = 5
				cv2.circle(thresholded, (c_x, c_y), radius, 0, 1)
				cv2.imshow("Thesholded", thresholded)

				
		# draw the segmented hand
		cv2.rectangle(clone, (left, top), (right, bottom), (0, 255, 0), 2)

		# increment the number of frames
		num_frames += 1
		
		# We want to generate and save the images corresponding to the two classes, in order to then save the model
		if TRAIN:

			#Check if directory for current class exists
			if not os.path.isdir(dirname+'/images/class_'+class_name):
				os.makedirs(dirname+'/images/class_'+class_name)

			if num_frames_train < tot_frames:
				# Change rectangle color to show that we are saving training images
				cv2.rectangle(clone, (left, top), (right, bottom), (255, 0, 0), 2)
				text = 'Generating ' + str(class_name) + ' images'
				cv2.putText(clone, text, (60, 300), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 0), 2)

				# Save training images corresponding to the class
				cv2.imwrite(dirname+'/images/class_'+class_name+'/img_'+str(num_frames_train)+'.png', thresholded)

				# keep track of how many images we are saving
				num_frames_train += 1

			else:

				print('Class '+class_name+' images generated')
				TRAIN = False

		if SVM:
			# Convert image frame to numpy array
			image_vector = np.array(thresholded)

			# Use trained SVM to  predict image class
			class_test = model.predict(image_vector.reshape(1, -1))

			if class_test == 0:
				# print('Class:  A value: ('+str(c_x)+','+str(c_y)+')')
				text = 'Class: A'
			else:
				# print('Class: B value: ('+str(c_x)+','+str(c_y)+')')
				text = 'Class: B'

			cv2.putText(clone, text, (70, 45), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)

			# Here we send the OSC message corresponding
			if START_SOUND:
				if class_test == 0:

					freq = (c_x/width_roi)*100 
					amp = (c_y/height_roi)
					client.send_message("/synth_control",['a',freq,amp])
				else:
					detune = (c_x/width_roi)*0.1
					lfo = (c_y/height_roi)*10
					client.send_message("/synth_control",['b',detune,lfo])
		

		# display the frame with segmented hand
		cv2.imshow("Video Feed", clone)
		
		# observe the keypress by the user
		keypress = cv2.waitKey(1) & 0xFF

		
		# if the user pressed "q", then stop looping
		if keypress == ord("q"):
			break

		# Generate class A images
		if keypress == ord("a"):
			print('Generating the images for class A:')
			TRAIN = True
			num_frames_train = 0
			tot_frames = 250
			class_name = 'a'

		# Generate class B images
		if keypress == ord("b"):
			print('Generating the images for class B:')
			TRAIN = True
			num_frames_train = 0
			tot_frames = 250
			class_name = 'b'

		# Train and/or start SVM classification
		if keypress == ord('t'):
			SVM = True

			if not os.path.isfile('modelSVM.joblib'):
				model = train_svm()
			else:
				model = load('modelSVM.joblib')

		# Start OSC communication and sound
		if keypress == ord('s'):
			START_SOUND = True

			# argparse helps writing user-friendly commandline interfaces
			parser = argparse.ArgumentParser()
			# OSC server ip
			parser.add_argument("--ip", default='127.0.0.1', help="The ip of the OSC server")
			# OSC server port (check on SuperCollider)
			parser.add_argument("--port", type=int, default=57120, help="The port the OSC server is listening on")

			# Parse the arguments
			args = parser.parse_args()

			# Start the UDP Client
			client = udp_client.SimpleUDPClient(args.ip, args.port)

		# Stop OSC communication and sound
		if keypress == ord('q'):

			# Send OSC message to stop the synth
			client.send_message("/synth_control", ['stop'])

# free up memory
camera.release()
cv2.destroyAllWindows()