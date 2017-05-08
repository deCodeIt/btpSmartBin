#!/usr/bin/python3

import sys
import os
from glob import glob
import struct
import time
import traceback
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
	from scipy.signal import hilbert
except Exception as e:
	print("{'status':false,'message':'"+str(e).replace("'","\\'")+"'}");
	sys.exit();

def getParamsFromDist(dist):
	'''returns features from a distribution'''
	mean = np.mean(dist);
	std = np.std(dist);
	r = max(dist) - min(dist);
	return np.array([mean,std,r]);

class SoundProcessing():

	def __init__(self):
		self.dataSet = None; # will contain the dataSet of Sound

	def waveRead(self):
		# open(fname,mode) is the Python way of reading files
		fin = open(self.fileName,"rb") # Read wav file, "r flag" - read, "b flag" - binary 
		ChunkID=fin.read(4) # First four bytes are ChunkID which must be "RIFF" in ASCII
		# print("ChunkID=",ChunkID)
		ChunkSizeString=fin.read(4) # Total Size of File in Bytes - 8 Bytes
		ChunkSize=struct.unpack('I',ChunkSizeString) # 'I' Format is to to treat the 4 bytes as unsigned 32-bit inter
		TotalSize=ChunkSize[0]+8 # The subscript is used because struct unpack returns everything as tuple
		# print("TotalSize=",TotalSize)
		DataSize=TotalSize-44 # This is the number of bytes of data
		# print("DataSize=",DataSize)
		Format=fin.read(4) # "WAVE" in ASCII
		# print("Format=",Format)
		SubChunk1ID=fin.read(4) # "fmt " in ASCII
		# print("SubChunk1ID=",SubChunk1ID)
		SubChunk1SizeString=fin.read(4) # Should be 16 (PCM, Pulse Code Modulation)
		SubChunk1Size=struct.unpack("I",SubChunk1SizeString) # 'I' format to treat as unsigned 32-bit integer
		# print("SubChunk1Size=",SubChunk1Size[0])
		AudioFormatString=fin.read(2) # Should be 1 (PCM)
		AudioFormat=struct.unpack("H",AudioFormatString) # 'H' format to treat as unsigned 16-bit integer
		# print("AudioFormat=",AudioFormat[0])
		NumChannelsString=fin.read(2) # Should be 1 for mono, 2 for stereo
		NumChannels=struct.unpack("H",NumChannelsString) # 'H' unsigned 16-bit integer
		# print("NumChannels=",NumChannels[0])
		SampleRateString=fin.read(4) # Should be 44100 (CD sampling rate)
		SampleRate=struct.unpack("I",SampleRateString)
		# print("SampleRate=",SampleRate[0])
		ByteRateString=fin.read(4) # 44100*NumChan*2 (88200 - Mono, 176400 - Stereo)
		ByteRate=struct.unpack("I",ByteRateString) # 'I' unsigned 32 bit integer
		# print("ByteRate=",ByteRate[0])
		BlockAlignString=fin.read(2) # NumChan*2 (2 - Mono, 4 - Stereo)
		BlockAlign=struct.unpack("H",BlockAlignString) # 'H' unsigned 16-bit integer
		# print("BlockAlign=",BlockAlign[0])
		BitsPerSampleString=fin.read(2) # 16 (CD has 16-bits per sample for each channel)
		BitsPerSample=struct.unpack("H",BitsPerSampleString) # 'H' unsigned 16-bit integer
		# print("BitsPerSample=",BitsPerSample[0])
		SubChunk2ID=fin.read(4) # "data" in ASCII
		# print("SubChunk2ID=",SubChunk2ID)
		SubChunk2SizeString=fin.read(4) # Number of Data Bytes, Same as DataSize
		SubChunk2Size=struct.unpack("I",SubChunk2SizeString)
		# print("SubChunk2Size=",SubChunk2Size[0])
		
		data = [];
		shortData = fin.read(2);
		while len(shortData):
			sData=struct.unpack("h",shortData)
			shortData=fin.read(2)
			data.append(int(sData[0]));

		fin.close()
		self.data = data;
		self.sampleRate = SampleRate[0];

	# iris = datasets.load_iris()
	# X, y = iris.data, iris.target
	# print(OneVsRestClassifier(LinearSVC(random_state=0)).fit(X, y).predict(X))

	def getSampleFromTo(self,sFrom, sTo):
		'''Returns sample of sound from sFrom secs to sTo secs'''
		# return self.data[ sFrom * self.sampleRate : sTo * self.sampleRate ];
		return self.envelope[ int(sFrom * self.sampleRate) : int(sTo * self.sampleRate) ];

	def smoothSignal(self):
		analyticSignal = hilbert(self.data);
		amplitudeEnvelope = np.abs(analyticSignal)
		rft = np.fft.rfft(amplitudeEnvelope)
		
		# removes higher frequencies, can be used to make signal even smoother
		rft[256:] = 0
		
		self.envelope = np.fft.irfft(rft)

	def convertSignal(self):
		'''Splits the different intervals from sound / frequency and converts them into the required data tuple'''
		# as every frequency lies for 2 secs, to be on a safer side, we will choose the interval od
		# (0.5,1.5) rather than (0,2)
		TIME_INTERVAL = 2;
		TOTAL_FREQUENCES = 20;
		dataTuple = np.array([])
		
		# fill up the tuple
		for i in range(TOTAL_FREQUENCES):
			startTime = (TIME_INTERVAL*i) + 0.5;
			stopTime = (TIME_INTERVAL*(i+1)) - 0.5;
			sample = self.getSampleFromTo(startTime,stopTime); # ectract this frequency sample
			dat = getParamsFromDist(sample);
			dataTuple = np.append(dataTuple,dat);

		# append this dataTuple to existing dataSet

		if self.dataSet is None:
			self.dataSet = np.reshape(dataTuple,(-1,dataTuple.shape[0]));
		else:
			self.dataSet = np.concatenate((self.dataSet,np.reshape(dataTuple,(-1,dataTuple.shape[0]))));
		
		# print (self.dataSet)

	def run(self,fileName):
		'''Call this function to initiate data generation'''
		self.fileName = fileName;
		self.waveRead()
		self.smoothSignal();
		self.convertSignal();

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

				# dataFeatures = getParamsFromDist(x);
				dataTuple = getParamsFromDist(x);
				# dataTuple = np.append(dataFeatures,y);
				if self.dataSet is None:
					self.dataSet = np.reshape(dataTuple,(-1,dataTuple.shape[0]));
				else:
					self.dataSet = np.concatenate(( self.dataSet, np.reshape(dataTuple,(-1,dataTuple.shape[0])) ));

		# print(self.dataSet)

	def run(self,fileName):
		'''Call this function to initiate data generation'''
		self.fileName = fileName;
		self.wifiReadAndConvert();

def main():
	try:
		if len(sys.argv) == 3:
			soundFile = sys.argv[1];
			wifiFile = sys.argv[2];

			obj = SoundProcessing();
			obj.run(soundFile);
			soundData = obj.dataSet;

			wifiObj = WifiProcessing();
			wifiObj.run(wifiFile);
			wifiData = wifiObj.dataSet;

			######################################################################
			regrSound = None;
			with open('soundRegressor.pkl','rb') as fid:
				regrSound = pickle.load(fid)
			predictedSound = regrSound.predict(soundData);
			
			###############################

			regrWifi = None
			with open('wifiRegressor.pkl','rb') as fid:
				regrWifi = pickle.load(fid)
			predictedWifi = regrWifi.predict(wifiData);

			######################################################################

			# Ensemble Learning
			dataTuple = np.append(predictedSound[0],predictedWifi[0]);

			regrEnsemble = None;

			with open('ensembleRegressor.pkl','rb') as fid:
				regrEnsemble = pickle.load(fid);

			predictedEnsemble = regrEnsemble.predict(np.reshape(dataTuple,(-1,dataTuple.shape[0])));
			print("{\"status\":true,\"message\":["+str(int(round(predictedEnsemble[0][0]/10.0)*10))+","+str(int(round(predictedEnsemble[0][1]/10.0)*10))+","+str(int(round(predictedEnsemble[0][2]/10.0)*10))+"]}");
		else:
			print("{\"status\":false,\"message\":\"Incorrect number of arguments\"}");
	except Exception as e:
		print("{\"status\":false,\"message\":\""+str(e).replace("'","\\'")+"\"}");
		# traceback.print_exc()

if __name__ == '__main__':
	main()