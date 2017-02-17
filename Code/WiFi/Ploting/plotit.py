#!/usr/bin/python
import matplotlib.pyplot as plt
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("filename",help="Data file name")
parser.add_argument("-o","--outfile",help="Image to be saved as ...")
args = parser.parse_args()

data_file = open(args.filename,'r')

x,y=[],[] #data points

while True:
	P = data_file.readline().strip().split()
	if not P:
		break;
	_x,_y = P;
	x.append(int(_x));
	y.append(int(_y));

#now plot the curve

plt.plot(x,y,'-o')
plt.xlim([min(x)-3,max(x)+3])
plt.xlabel("Signal(-dB)");
plt.ylabel("Probability");
plt.title('Probability distribution')
fig = plt.gcf();
if args.outfile:
	fig.savefig(args.outfile+".png")
else:
	fig.savefig(args.filename.split('.')[0]+".png")
#plt.yscale([])
plt.show();
