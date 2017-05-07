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
	# try:
	soundFile = 'sound_data.txt';
	wifiFile = 'wifi_data.txt';

	#loading data
	wifiData = np.loadtxt(wifiFile, delimiter=',');
	soundData = np.loadtxt(soundFile, delimiter=',');

	#Train and test
	wifiLabel = wifiData[:, -3:];
	wifiData = wifiData[:, :-3];

	soundLabel = soundData[:, -3:];
	soundData = soundData[:, :-3];
	
	# SX_train, SX_test, Sy_train, Sy_test = train_test_split( soundData, soundLabel, test_size=0.3, random_state=0)
	# SX_train, SX_test, Sy_train, Sy_test = train_test_split( soundData, soundLabel, test_size=0.3, random_state=0)

	# sss = ShuffleSplit(n_splits=5, test_size=0.3, random_state=int(time.time()))
	# count = 0;

	# cross the data sets for sound and wifi
	crossedDataSet = None;
	for s_iter in range(soundLabel.shape[0]):
		for w_iter in range(wifiLabel.shape[0]):
			# cross them if label matches
			soundTuple = soundLabel[s_iter]
			wifiTuple = wifiLabel[w_iter]
			if np.array_equal(soundTuple,wifiTuple):
				dataTuple = np.append(soundData[s_iter],wifiData[w_iter]);
				dataTuple = np.append(dataTuple,wifiLabel[w_iter]);
				if crossedDataSet is None:
					crossedDataSet = np.reshape(dataTuple,(-1,dataTuple.shape[0]));
				else:
					crossedDataSet = np.concatenate(( crossedDataSet, np.reshape(dataTuple,(-1,dataTuple.shape[0])) ));
	
	# update the sound and wifi data

	soundData = crossedDataSet[:,:soundData.shape[1]];
	soundLabel = crossedDataSet[:, -3:]

	wifiData = crossedDataSet[:, soundData.shape[1]:-3];
	wifiLabel = crossedDataSet[:,-3:];

	######################################################################
	regrSound = DecisionTreeRegressor(max_depth=5)
	# predictedSound = cross_val_predict(regrSound,soundData,soundLabel,cv = 5);
	regrSound.fit(soundData,soundLabel);
	predictedSound = regrSound.predict(soundData);
	with open('soundRegressor.pkl','wb') as fid:
		pickle.dump(regrSound,fid)

	# print(predictedSound)

	# Strue = 0.0;
	# Stotal = len(predictedSound);
	## accuracy
	# for i in range (len(predictedSound)):
	# 	for j in range (len(predictedSound[i])):
	# 		if round(predictedSound[i][j]/10.0)*10.0 == soundLabel[i][j]:
	# 			Strue +=1.0;
	# print("%.2f%%"%(100.0*Strue/(3*Stotal)));

	###############################

	regrWifi = DecisionTreeRegressor(max_depth=5)
	# predictedWifi = cross_val_predict(regrWifi,wifiData,wifiLabel,cv = 5);
	regrWifi.fit(wifiData,wifiLabel);
	predictedWifi = regrWifi.predict(wifiData);
	with open('wifiRegressor.pkl','wb') as fid:
		pickle.dump(regrWifi,fid);
	# print(predictedWifi)

	# Wtrue = 0.0;
	# Wtotal = len(predictedWifi);
	## accuracy
	# for i in range (len(predictedWifi)):
	# 	for j in range (len(predictedWifi[i])):
	# 		if round(predictedWifi[i][j]/10.0)*10.0 == wifiLabel[i][j]:
	# 			Wtrue +=1.0;
	# print("%.2f%%"%(100.0*Wtrue/(3*Wtotal)));

	######################################################################

	# Ensemble Learning

	ensembleData = None
	for i in range(crossedDataSet.shape[0]):
		dataTuple = np.append(predictedSound[i],predictedWifi[i])
		dataTuple = np.append(dataTuple,wifiLabel[i]) # add labels
		if ensembleData is None:
			ensembleData = np.reshape(dataTuple,(-1,dataTuple.shape[0]));
		else:
			ensembleData = np.concatenate(( ensembleData, np.reshape(dataTuple,(-1,dataTuple.shape[0])) ));

	ensembleX = ensembleData[:, :-3]
	ensembleY = ensembleData[:, -3:]

	regrEnsemble = DecisionTreeRegressor(max_depth=5)
	# predictedEnsemble = cross_val_predict(regrEnsemble,ensembleX,ensembleY,cv = 5);
	regrEnsemble.fit(ensembleX,ensembleY);
	predictedEnsemble = regrEnsemble.predict(ensembleX);
	with open('ensembleRegressor.pkl','wb') as fid:
		pickle.dump(regrEnsemble,fid)

	Etrue = 0.0;
	Etotal = len(predictedEnsemble);
	#print(np.array([[(Sy_1[i][0]-Sy_test[i][0]) , (Sy_1[i][1]-Sy_test[i][1]), (Sy_1[i][2]-Sy_test[i][2])] for i in range(len(Sy_1))]));
	for i in range (len(predictedEnsemble)):
		for j in range (len(predictedEnsemble[i])):
			if round(predictedEnsemble[i][j]/10.0)*10.0 == ensembleY[i][j]:
				Etrue +=1.0;
	print("%.2f%%"%(100.0*Etrue/(3*Etotal)));

	## Now let's predict the bin configuration


	
	# for train_index, test_index in sss.split(soundData, soundLabel):
	# 	count += 1;
	# 	SX_train, SX_test = soundData[train_index], soundData[test_index]
	# 	Sy_train, Sy_test = soundLabel[train_index], soundLabel[test_index]
	# 	regrSound = DecisionTreeRegressor(max_depth=5)
	# 	regrSound.fit(SX_train, Sy_train)
	# 	Sy = regrSound.predict(SX_test)
		
	# 	Strue = 0.0;
	# 	Stotal = len(Sy);
	# 	print('Run #'+str(count));
	# 	#print(np.array([[(Sy_1[i][0]-Sy_test[i][0]) , (Sy_1[i][1]-Sy_test[i][1]), (Sy_1[i][2]-Sy_test[i][2])] for i in range(len(Sy_1))]));
	# 	for i in range (len(Sy)):
	# 		Label = 0;
	# 		for j in range (len(Sy[i])):

	# 			if (abs(Sy[i][j]-Sy_test[i][j])<10):
	# 				Strue +=1.0;
		
	# 	print("%.2f%%"%(100.0*Strue/(3*Stotal)));


	#training wifi
	# print('\n\n');
	# print('Accuracy Wifi:')
	# sss = ShuffleSplit(n_splits=5, test_size=0.3, random_state=int(time.time()))
	# count = 0;
	# for train_index, test_index in sss.split(wifiData, wifiLabel):
	# 	count += 1;
	# 	WX_train, WX_test = wifiData[train_index], wifiData[test_index]
	# 	Wy_train, Wy_test = wifiLabel[train_index], wifiLabel[test_index]
	# 	regrWifi = DecisionTreeRegressor(max_depth=5)
	# 	regrWifi.fit(WX_train, Wy_train)

	# 	Wy = regrWifi.predict(WX_test)
		
	# 	Wtrue = 0.0;
	# 	Wtotal = len(Wy);
	# 	print('Run #'+str(count));
	# 	#print(np.array([[(Sy_1[i][0]-Sy_test[i][0]) , (Sy_1[i][1]-Sy_test[i][1]), (Sy_1[i][2]-Sy_test[i][2])] for i in range(len(Sy_1))]));
	# 	for i in range (len(Wy)):
	# 		Label = 0;
	# 		for j in range (len(Wy[i])):

	# 			if (abs(Wy[i][j]-Wy_test[i][j])<10):
	# 				Wtrue +=1
		
	# 	print("%.2f%%"%(100.0*Wtrue/(3*Wtotal)));
	
	# except Exception as e:
	# 	print("{'status':'false','error':'"+str(e).replace("'","\\'")+"'}");

if __name__ == '__main__':
	main()