#!/usr/bin/env python3
import sys
import os
from glob import glob
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import hilbert
import struct

def getParamsFromDist(dist):
	'''returns features from a distribution'''
	mean = np.mean(dist);
	std = np.std(dist);
	r = max(dist) - min(dist);
	return np.array([mean,std,r]);

class WifiProcessing():

	def __init__(self):
		self.dataSet = None; # will contain the dataSet of Sound

	def wifiReadAndConvert(self):
		# open(fname,mode) is the Python way of reading files
		data = np.array([]);
		with open(self.fileName,"r") as fin: # Read wav file, "r flag" - read, "b flag" - binary 
			for line in fin:
				data = [ float(_d) for _d in line.split(',') ];
				x = data[:-3]; # to leave last 3 columns as they are labels and NOT readings
				y = data[-3:]; # the data labels

				dataFeatures = getParamsFromDist(x);
				dataTuple = np.append(dataFeatures,y);
				if self.dataSet is None:
					self.dataSet = np.reshape(dataTuple,(-1,dataTuple.shape[0]));
				else:
					self.dataSet = np.concatenate(( self.dataSet, np.reshape(dataTuple,(-1,dataTuple.shape[0])) ));

		print(self.dataSet)

	def run(self,fileName):
		'''Call this function to initiate data generation'''
		self.fileName = fileName;
		self.wifiReadAndConvert();




def main():
	# try:
	obj = WifiProcessing();
	wifiFile = 'data/wifi_data/wifi_data.txt';
	obj.run(wifiFile)

	# save the data to a file
	np.savetxt('wifi_data.txt',obj.dataSet,fmt='%.3f',delimiter=",");

	# except Exception as e:
	# 	print("{'status':'false','error':'"+str(e).replace("'","\\'")+"'}");

if __name__ == '__main__':
	main()