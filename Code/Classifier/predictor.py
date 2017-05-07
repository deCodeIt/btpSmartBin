#!/usr/bin/env python3
import sys
import os
from glob import glob
import struct
import time
try:
	from sklearn.model_selection import train_test_split
	from sklearn.model_selection import cross_val_predict
	from sklearn.model_selection import ShuffleSplit
	from sklearn.tree import DecisionTreeRegressor
	from sklearn.multiclass import OneVsRestClassifier
	from sklearn.svm import LinearSVC
	import numpy as np
	import matplotlib.pyplot as plt
	import pickle

except Exception as e:
	print(str(e));

def main():
	try:
		soundFile = 'sound_data.txt';
		wifiFile = 'wifi_data.txt';

		#loading data
		wifiData = np.loadtxt(wifiFile, delimiter=',');
		soundData = np.loadtxt(soundFile, delimiter=',');

		######################################################################
		regrSound = None;
		with open('soundRegressor.pkl','rb') as fid:
			regrSound = pickle.load(fid)
		predictedSound = regrSound.predict(np.reshape(soundData,(-1,soundData.shape[0])));
		
		###############################

		regrWifi = None
		with open('wifiRegressor.pkl','rb') as fid:
			regrWifi = pickle.load(fid)
		predictedWifi = regrWifi.predict(np.reshape(wifiData,(-1,wifiData.shape[0])));

		######################################################################

		# Ensemble Learning
		dataTuple = np.append(predictedSound[0],predictedWifi[0]);

		regrEnsemble = None;

		with open('ensembleRegressor.pkl','rb') as fid:
			regrEnsemble = pickle.load(fid);

		predictedEnsemble = regrEnsemble.predict(np.reshape(dataTuple,(-1,dataTuple.shape[0])));
		print("{'status':'true','prediction':["+str(predictedEnsemble[0][0])+","+str(predictedEnsemble[0][1])+","+str(predictedEnsemble[0][2])+"]}");

	except Exception as e:
		print("{'status':'false','error':'"+str(e).replace("'","\\'")+"'}");

if __name__ == '__main__':
	main()