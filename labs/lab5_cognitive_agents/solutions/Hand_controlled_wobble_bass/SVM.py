
import cv2
import os
import numpy as np
import warnings
from sklearn.svm import SVC
from sklearn.decomposition import PCA
from sklearn.pipeline import make_pipeline
from sklearn.metrics import classification_report
from sklearn.model_selection import train_test_split
from joblib import dump
from sklearn.model_selection import GridSearchCV

dirname = os.path.dirname(__file__)

def load_data(class_a_path, class_b_path):

	labels = []
	generate_arrays = True  # Create arrays where we store the dataset
	for img_name in os.listdir(class_a_path):
		if not img_name.startswith('.'):
			# Read the image
			img = cv2.imread(class_a_path + img_name, 0)
			img = np.reshape(img, (1, img.shape[0], img.shape[1]))
			img_vector = np.reshape(img.ravel(), (1, -1))

			# Create arrays where we store the dataset executed only at beginning
			if generate_arrays:
				images = img
				images_vector = img_vector
				generate_arrays = False
			else:
				images = np.concatenate((images, img), axis=0)
				images_vector = np.concatenate((images_vector, img_vector), axis=0)

			labels.append(0)

	for img_name in os.listdir(class_b_path):
		if not img_name.startswith('.'):
			# Read the image
			img = cv2.imread(class_b_path + img_name, 0)
			img = np.reshape(img, (1, img.shape[0], img.shape[1]))
			img_vector = np.reshape(img.ravel(), (1, -1))
			images = np.concatenate((images, img), axis=0)
			images_vector = np.concatenate((images_vector, img_vector), axis=0)

			labels.append(1)

	return images, images_vector, labels


def train_svm():
	# Load data
	class_names = ['a', 'b']

	images, images_vector, labels = load_data(class_a_path=dirname+'/images/class_a/', class_b_path=dirname+'/images/class_b/')

	pca = PCA(n_components=150, svd_solver='randomized', whiten=True, random_state=42)
	svc = SVC(kernel='rbf', class_weight='balanced')
	model = make_pipeline(pca,svc)

	with warnings.catch_warnings():
		# ignore all caught warnings
		warnings.filterwarnings("ignore")
		# execute code that will generate warnings
		xtrain, xtest, ytrain, ytest = train_test_split(images_vector, labels, random_state=42)

	param_grid = {'svc__C': [1, 5, 10, 50], 'svc__gamma': [0.0001, 0.0005, 0.001, 0.005]}
	grid = GridSearchCV(model, param_grid)

	print('Fit the SVM model')
	grid.fit(xtrain, ytrain)

	print(grid.best_params_)

	model = grid.best_estimator_

	# Save the model
	dump(model, 'modelSVM.joblib')

	return model