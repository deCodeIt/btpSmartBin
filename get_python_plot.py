#!/bin/python
import subprocess,time,sys,argparse,os
# import matplotlib.pyplot as plt
rows, columns = os.popen('stty size', 'r').read().split()
parser = argparse.ArgumentParser()
parser.add_argument("-s","--sample",type=int,help="#instances to collect",default=100)
parser.add_argument("-f","--frequency", type=int,help="# of times to count in a second",default=10)
parser.add_argument("-ht","--height",type=str,help="Height of Smart Bin", default="instance")
parser.add_argument("-fn","--filename",type=str,help="File name to save as", default=None)
args = parser.parse_args()

signal_strength = 0;
dict = {}
instance = 0;
while True and instance < args.sample:
	iwconfig = subprocess.Popen("iwconfig wlan0 | grep -i signal | awk '{print $4}' | sed 's/level=//g' ",stdout=subprocess.PIPE,shell=True);
	current_signal_strength = iwconfig.communicate()[0].strip();
	instance+=1
	#increment the signal count
	if current_signal_strength in dict:
		dict[current_signal_strength] += 1;
	else:
		dict[current_signal_strength] = 1;

	if current_signal_strength != signal_strength:
		signal_strength = current_signal_strength;
	sys.stdout.write("\rInstance: "+str(instance)+"/"+str(args.sample)+", "+current_signal_strength + "dB")
	sys.stdout.flush()
	time.sleep(1.0/args.frequency);

#clear screen
sys.stdout.write("\r")
for i in range(int(columns)):
	sys.stdout.write(" ")
sys.stdout.flush();


# write to a file
sys.stdout.write("\rSignal\tFrequency\n")
if args.filename:
	out_file = open(args.filename,"w")
else:
	out_file = open(args.height+".txt","w")
for k, v in dict.items():
	out_file.write(str(-1*int(k)) + "\t" + str(v) + "\n");
	sys.stdout.write(k + "\t" + str(v) + "\n");
	sys.stdout.flush()
out_file.close()

# total = 0;
# for k, v in dict.items():
# 	total = total+v
# xval = [];
# yval = []
# for k,v in dict.items():
# 	xval.append(k);
# 	yval.append((v*1.0)/(total))

# plt.plot(x,y,'-o')
# plt.xlabel("Differnt values occured")
# plt.ylebel("probability");
# plt.title('Probability distribution')
# fig = plt.gcf();
# fig.savefig(args.height)
# #plt.yscale([])
# plt.show();
