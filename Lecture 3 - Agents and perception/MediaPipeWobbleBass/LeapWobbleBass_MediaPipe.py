import cv2
import mediapipe as mp
from pythonosc import udp_client
import argparse

mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_hands = mp.solutions.hands



def compute_landmark_avg(Hand_landmarks_obj, Hand_landmarks_instance):

  x=0
  y=0
  z=0

  for l in range(len(Hand_landmarks_obj)):
    x = x+Hand_landmarks_instance[Hand_landmarks_obj(l).value].x
    y = y+Hand_landmarks_instance[Hand_landmarks_obj(l).value].y
    z = z+Hand_landmarks_instance[Hand_landmarks_obj(l).value].z

  x = x/len(Hand_landmarks_obj)
  y = y/len(Hand_landmarks_obj)
  z = z/len(Hand_landmarks_obj)

  print("Lendmark Average -> x: "+str(x)+"\ny: "+str(y)+"\nz: "+str(z))

  return [x,y,z]



if __name__ == "__main__":
  # For webcam input:
  cap = cv2.VideoCapture(0)
  with mp_hands.Hands(
      model_complexity=0,
      min_detection_confidence=0.5,
      min_tracking_confidence=0.5) as hands:
    while cap.isOpened():
      success, image = cap.read()
      if not success:
        print("Ignoring empty camera frame.")
        # If loading a video, use 'break' instead of 'continue'.
        continue

      # To improve performance, optionally mark the image as not writeable to
      # pass by reference.
      image.flags.writeable = False
      image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
      results = hands.process(image)

      # Draw the hand annotations on the image.
      image.flags.writeable = True
      image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

      if results.multi_hand_landmarks:
        #for hand_landmarks in results.multi_hand_landmarks:
        for hand_no, hand_landmarks in enumerate(results.multi_hand_landmarks):

          #hand_landmarks

          print(f'HAND NUMBER: {hand_no+1}')
          print('-----------------------')
          
          landmarks_avg = 0

          # mp_hands.HandLandmark(l).value is the index of the HandLandmark(l) within all HandLandmark
          # mp_hands.HandLandmark(l).name is the name of the HandLandmark(l)

          #print(mp_hands.HandLandmark(l).name+": "+str(hand_landmarks.landmark[mp_hands.HandLandmark(l).value]))

          lm_avg_x, lm_avg_y, lm_avg_z = compute_landmark_avg(mp_hands.HandLandmark, hand_landmarks.landmark)

          """lm_avg_x = 0
          lm_avg_y = 0
          lm_avg_z = 0

          for l in range(len(mp_hands.HandLandmark)):
            lm_avg_x = lm_avg_x+hand_landmarks.landmark[mp_hands.HandLandmark(l).value].x
            lm_avg_y = lm_avg_y+hand_landmarks.landmark[mp_hands.HandLandmark(l).value].y
            lm_avg_z = lm_avg_z+hand_landmarks.landmark[mp_hands.HandLandmark(l).value].z

            #print(mp_hands.HandLandmark(l).name+": "+str(hand_landmarks.landmark[mp_hands.HandLandmark(l).value]))

          lm_avg_y = lm_avg_y/len(mp_hands.HandLandmark)
          lm_avg_z = lm_avg_z/len(mp_hands.HandLandmark)"""

          #print("x: "+str(lm_avg_x)+"\ny: "+str(lm_avg_y)+"\nz: "+str(lm_avg_z))


          # send OSC message
          parser = argparse.ArgumentParser()
          parser.add_argument("--ip", default="127.0.0.1",
          help="The ip of the OSC server")
          parser.add_argument("--port", type=int, default=57120,
          help="The port the OSC server is listening on")
          args = parser.parse_args()

          client = udp_client.SimpleUDPClient(args.ip, args.port)
          client.send_message("/position", [float(lm_avg_x), float(lm_avg_y)])
  

          mp_drawing.draw_landmarks(
              image,
              hand_landmarks,
              mp_hands.HAND_CONNECTIONS,
              mp_drawing_styles.get_default_hand_landmarks_style(),
              mp_drawing_styles.get_default_hand_connections_style())
      # Flip the image horizontally for a selfie-view display.
      cv2.imshow('MediaPipe Hands', cv2.flip(image, 1))
      if cv2.waitKey(5) & 0xFF == 27:
        break
  cap.release()
