import os
import sys
import numpy as np
import matplotlib
import matplotlib.pyplot as plt



# Get SOLPS input data 
solps = np.genfromtxt('solps_55rad/sim/solpsTarg_55.txt',delimiter='  ',skip_header=1)
LLsep   = solps[:,0]
R_m     = solps[:,1]
Z_m     = solps[:,2]
Te_eV   = solps[:,3]
Ti_eV   = solps[:,4]
FluxHe2 = solps[:,5]
FluxHe1 = solps[:,6]
nHe2    = solps[:,7]
nHe1    = solps[:,8]
Btot    = solps[:,9]
Bangle  = solps[:,10]

# Number of Points along the surface 
Npoints = np.size(LLsep,0)

# Plot Solps nHe1, nHe2 
SimID='west00'
plt.figure(1)
plt.plot(LLsep,nHe1,'bo-',label='n(He+)')
plt.plot(LLsep,nHe2,'ko-',label='n(He++)')
plt.xlabel('L-Lsep [m]')
plt.ylabel('density [m$^{-3}$]')
plt.legend()
#plt.ylim([0, 45])
plt.title('SOLPS - Ion Density of He+, He++ - WEST x5.5 rad')
plt.savefig('west_55rad_dens.png',dpi=300)
plt.close()

# Plot Solps Te, Ti 
SimID='west00'
plt.figure(1)
plt.plot(LLsep,Te_eV,'bo-',label='Te')
plt.plot(LLsep,Ti_eV,'ko-',label='Ti')
plt.xlabel('L-Lsep [m]')
plt.ylabel('Temperature [eV]')
plt.legend()
plt.ylim([0, 45])
plt.title('SOLPS - Electron and Ion Temperature - WEST x5.5 rad')
plt.savefig('west_55rad_temp.png',dpi=300)
plt.close()

# Plot Solps B-field magnitude
SimID='west00'
plt.figure(1)
plt.plot(LLsep,Btot,'ko-',label='$B(tot)$')
plt.xlabel('L-Lsep [m]')
plt.ylabel('Magnetic Field [T]')
plt.legend()
plt.title('SOLPS - Magnetic Field - WEST x5.5 rad')
plt.savefig('west_55rad_bfield.png',dpi=300)
plt.close()

# Plot Solps B-field angle
SimID='west00'
plt.figure(1)
plt.plot(LLsep,Bangle,'ko-',label='$\psi$')
plt.xlabel('L-Lsep [m]')
plt.ylabel('Magnetic angle [$\psi$]')
plt.legend()
plt.title('SOLPS - Magnetic Angle - WEST x5.5 rad')
plt.savefig('west_55rad_bangle.png',dpi=300)
plt.close()

# Plot hPiC plasma potential 
SimID='west00'
phi = np.zeros(Npoints)
for i in range(Npoints):
  folder = 'solps_55rad/sim/'+SimID+str(i)
  filename = SimID+str(i)+'_TIMESERIES.dat'
  path = folder+'/'+filename
  data = np.genfromtxt(path,delimiter=', ')
  phi[i] = np.mean(data[-100:-1,1])
print('phi = ')
print(phi)
plt.figure(1)
plt.plot([0, 0],[0, 60])
plt.plot(LLsep,phi,'ko-')
plt.xlabel('L-Lsep [m]')
plt.ylabel('Plasma potential [V]')
plt.ylim([0, 60])
plt.title('hPIC - Plasma Potential at 100LD from surface - WEST x5.5 rad')
plt.savefig('west_55rad_phi.png',dpi=300)
plt.close()

# Plot hPIC IEADs

# Species sp0 (He+)
for i in range(Npoints):
  folder = 'solps_55rad/sim/'+SimID+str(i)
  filename = SimID+str(i)+'_IEAD_sp0.dat'
  path = folder+'/'+filename
  IEAD = np.genfromtxt(path,delimiter=' ')
  energy = np.linspace(0.0,24.0*Te_eV[i],240)
  angles = np.linspace(0,90,90)
  E,A = np.meshgrid(angles,energy[0:-2])
  plt.figure(i)
  plt.contourf(E,A,IEAD[0:-2,:])
  plt.xlabel('Angle [deg]')
  plt.ylabel('Energy [eV]')
  plt.title('hPIC - Ion Energy Angle Distribution, He+')
  plt.savefig(SimID+str(i)+'_sp0_iead.png',dpi=300)
  plt.close(i)

# Species sp1 (He++) 
for i in range(Npoints):
  folder = 'solps_55rad/sim/'+SimID+str(i)
  filename = SimID+str(i)+'_IEAD_sp1.dat'
  path = folder+'/'+filename
  IEAD = np.genfromtxt(path,delimiter=' ')
  energy = np.linspace(0.0,24.0*Te_eV[i],240)
  angles = np.linspace(0,90,90)
  E,A = np.meshgrid(angles,energy[0:-2])
  plt.figure(i)
  plt.contourf(E,A,IEAD[0:-2,:])
  plt.xlabel('Angle [deg]')
  plt.ylabel('Energy [eV]')
  plt.title('hPIC - Ion Energy Angle Distribution, He++')
  plt.savefig(SimID+str(i)+'_sp1_iead.png',dpi=300)
  plt.close(i)

