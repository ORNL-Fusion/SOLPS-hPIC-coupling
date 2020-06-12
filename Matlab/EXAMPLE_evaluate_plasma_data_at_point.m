clearvars;

run_path = 'C:\Users\jjl\Dropbox (ORNL)\PSIscidac\SOLPS\WEST\54034\grid_v1_SN_He_transfer\P2.65MW_art_rad_0_Helium_2019_n1.9e19_radscale2';

% Get SOLPS data
geo = read_b2fgmtry_simple(fullfile(run_path,'../baserun/b2fgmtry'));
state = read_b2fstate_simple(fullfile(run_path,'b2fstate'));

% These can also be 1D arrays
Rtest = 2.5;
Ztest = 0.5;

% Get 1D index for the point(s)
[I1,ierr] = point2cell_solps_1d(geo,Rtest,Ztest);

% Example for array that is size(nx,ny)
this = state.te./1.6e-19;
if length(Rtest) == 1
    fprintf('Te = %f eV at R = %f, Z = %f (m)\n',this(I1),Rtest,Ztest)
end

% Example for array that is size(nx,ny,ns)
this = state.na(:,:,3);
if length(Rtest) == 1
    fprintf('n_H++ = %e m^-3 at R = %f, Z = %f (m)\n',this(I1),Rtest,Ztest)
end
