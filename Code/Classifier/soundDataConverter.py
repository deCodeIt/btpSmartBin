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

		# now dataTuple is the row
		dataTuple = np.append(dataTuple,self.getLabel()) # append the labels to data
		# append this dataTuple to existing dataSet

		if self.dataSet is None:
			self.dataSet = np.reshape(dataTuple,(-1,dataTuple.shape[0]));
		else:
			self.dataSet = np.concatenate((self.dataSet,np.reshape(dataTuple,(-1,dataTuple.shape[0]))));
		
		# print (self.dataSet)

	def getLabel(self):
		'''returns data label from sound filename'''
		s = os.path.basename(self.fileName).split('_');
		dataLabel = np.array([int(s[0].split('-')[1]), int(s[1].split('-')[1]), int(s[2].split('-')[1])], dtype='float64')
		return dataLabel;

	def run(self,fileName):
		'''Call this function to initiate data generation'''
		self.fileName = fileName;
		self.waveRead()
		self.smoothSignal();
		self.convertSignal();
		
		######################################################################
		######################################################################
		######################################################################
		#Code to plot figure

		# fig = plt.figure()
		# x = np.arange(len(self.data)); # x axis
		# # plt.plot(x,self.data,label='signal')
		# plt.plot(x,self.amplitudeEnvelope,label='envelope')
		# plt.plot(x,self.amplitudeEnvelopeSmooth,label='envelopeSmooth')
		# plt.legend()
		# plt.show()
		######################################################################
		######################################################################
		######################################################################






def main():
	# try:
	obj = SoundProcessing();
	soundFiles = glob('data/sound_data/*.wav');
	for file in soundFiles:
		print (file)
		obj.run(file);

	# save the data to a file
	np.savetxt('sound_data.txt',obj.dataSet,fmt='%.3f',delimiter=",");

	# except Exception as e:
	# 	print("{'status':'false','error':'"+str(e).replace("'","\\'")+"'}");

if __name__ == '__main__':
	main()