# WEST C4 Collector Probe Analysis - Simple plot of hPIC IEADs
import sys
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
font = { 'size' : 20 }
plt.rc('font', **font)
Te_eV_array = np.array([ 1.62167190e+01, 7.69748285e+00, \
              3.14783250e+00, 9.55495830e-01, 2.90032039e-01 ])
# Cycle over the two species ( sp0 = He++, sp1 = He+ )
for sp in range(2):
    for i in range(5):
        filename = 'cprobe_'+str(i+1)+'_IEAD_sp'+str(sp)+'.dat'
        Te_eV    = Te_eV_array[i]
        IEAD   = np.genfromtxt(filename,delimiter=' ',skip_footer=1)
        energy = np.linspace(0.0,48.0*Te_eV,480-1)
        angles = np.linspace(0,90,90)
        E,A = np.meshgrid(angles,energy)
        plt.figure(i+1)
        plt.contourf(E,A,IEAD)
        plt.xlabel('Angle [deg]')
        plt.ylabel('Energy [eV]')
        plt.title('hPIC - Ion Energy Angle Distribution')
        plt.savefig('iead_sp'+str(sp)+'_loc_'+str(i+1)+'.png',dpi=300)
