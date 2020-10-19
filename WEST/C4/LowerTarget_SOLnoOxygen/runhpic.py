import os
import sys
import subprocess
import numpy as np

# Load SOLPS output 
solps_output = 'solpsTarg_55.txt'
data = np.genfromtxt( solps_output, delimiter='  ', skip_header=1)

LLsep   = data[:,0]
R_m     = data[:,1]
Z_m     = data[:,2]
Te_eV   = data[:,3]
Ti_eV   = data[:,4]
FluxHe2 = data[:,5]
FluxHe1 = data[:,6]
nHe2    = data[:,7]
nHe1    = data[:,8]
Btot    = data[:,9]
Bangle  = data[:,10] 

# Setup hPIC runs 
hpic_executable = '~/hPIC/hpic_1d3v/hpic'
Npoints = np.size(LLsep,0)
SimID = 'west00'

# construct hPIC command line and run
first_point = int( sys.argv[1] )
last_point  = int( sys.argv[2] )
for i in range(first_point,last_point):
  cline = hpic_executable+' '
  cline += ' -command_line '
  cline += SimID+str(i)+' '
  cline += '100 1 20 2.0 4000 '
  cline += str(Btot[i])+' '
  cline += str(Bangle[i])+' ' 
  cline += str(Te_eV[i])+' ' 
  cline += str(Ti_eV[i])+' ' 
  cline += '0.0 0.0 '
  cline += '0.0 0.0 0.0 '
  cline += '20 20 2 0 '
  cline += '4 1 '+str(nHe1[i])+' '
  cline += '4 2 '+str(nHe2[i])+' '
  cline += '1 "uniform" "200" "200" "1.0"'
  cline += ' > '+SimID+str(i)+'.log'
  print(cline)
  folder = SimID+str(i)
  os.system('mkdir '+folder)
  subprocess.call(cline, cwd=folder, shell=True)
