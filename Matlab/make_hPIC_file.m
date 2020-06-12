clearvars;

%% Setup
run_path = 'C:\Users\jjl\Dropbox (ORNL)\PSIscidac\SOLPS\WEST\54034\grid_v1_SN_He_transfer\P2.65MW_art_rad_0_Helium_2019_n1.9e19_radscale2';
outFileName = fullfile(run_path,'solpsTarg_new.txt');

% Get SOLPS data
geo = read_b2fgmtry_simple(fullfile(run_path,'../baserun/b2fgmtry'));
state = read_b2fstate_simple(fullfile(run_path,'b2fstate'));

dsr = OutputDs(geo, geo.nx + 2,geo.jsep + 2,-1);

% Outer target index and dL
iX = geo.nx + 2; 
dXSep = dsr;

perp_to_prl = geo.gs(iX,:,1)./geo.pbs(iX,:,1);
alpha_deg_SOLPS = 1./perp_to_prl*180/pi;

%% Write file in hPIC format
num_ions = 2;  % This file assumes He-only runs, but should be easy to modify
ncol = 7 + num_ions*2;
data = nan(length(dXSep),ncol);

data(:,1) = dXSep;                             % L-Lsep (m)
data(:,2) = geo.crx(iX,:,1);                   % R (m)
data(:,3) = geo.cry(iX,:,1);                   % Z (m)
data(:,4) = state.te(iX,:)./1.602e-19;         % Te (eV)
data(:,5) = state.ti(iX,:)./1.602e-19;         % Ti (eV)
data(:,6) = state.fna(iX,:,1,3)./geo.sx(iX,:); % Deposited He++ ion flux (m^-2s^-1)
data(:,7) = state.fna(iX,:,1,2)./geo.sx(iX,:); % Deposited He+ ion flux (m^-2s^-1)
data(:,8) = state.na(iX,:,3);                  % H++ density (m^-3)
data(:,9) = state.na(iX,:,2);                  % H+ density (m^-3)
data(:,10) = geo.bb(end,:,4);                  % |B| (T)
data(:,11) = 90 -alpha_deg_SOLPS;              % angle from surface normal (deg)

fid = fopen(outFileName,'w');
legend = '    L-Lsep (m)          R (m)           Z (m)          Te (eV)           Ti (eV)          FluxHe2+         FluxHe1+           nHe2+          nHe1+            Btot             Bangle';
fprintf(fid,'%s\n',legend);
fclose(fid);
dlmwrite(outFileName,data,'delimiter',' ','precision','%16.8e','-append'); 


% % Test:: Calc Bangle from gfile
% g = readg_g3d(gfile_name);
% gfile_name = find_solps_file(run_path,'gfile');
% v2 = [0,0,1];
% for iY = 1:geo.ny + 2
%     v1 = [geo.crx(iX,iY,1)-geo.crx(iX,iY,3),geo.cry(iX,iY,1)-geo.cry(iX,iY,3),0];
%     vn = cross(v1,v2);
%     vn = vn./norm(vn);
%     b = bfield_geq_bicub(g,geo.r2d_cen(iX,iY),geo.z2d_cen(iX,iY),0);
%     b = [b.br,b.bz,b.bphi];
%     b = b./norm(b);
%     alpha_deg(iY) = 90 - acos(dot(vn,b))*180/pi;
% end
% figure; hold on; box on
% plot(dXSep,abs(alpha_deg),'x-','linew',2)
% plot(dXSep,abs(alpha_deg_SOLPS),'<')  % THIS ONE
% xlabel('L-L_{sep} (m)')


function [ds,iYStart,iYEnd] = OutputDs(geo,iXMatlab,jsepMatlab,offset)

iXCell = iXMatlab;
iYCell = geo.region(iXCell,:,1) ~= 0; 

% Distance from sep calculated using center of cell
iYStart = find(iYCell == 1,1,'first');
iYEnd   = find(iYCell == 1,1,'last');
X1 = geo.r2d_cen(iXCell+offset,iYStart);
X2 = mean(geo.crx(iXCell+offset,iYStart,1:2));
Y1 = geo.z2d_cen(iXCell+offset,iYStart);
Y2 = mean(geo.cry(iXCell+offset,iYStart,1:2));
ds(1) = sqrt((X2-X1).^2 + (Y2-Y1).^2);
XUse = geo.r2d_cen(iXCell+offset,iYStart:iYEnd);
YUse = geo.z2d_cen(iXCell+offset,iYStart:iYEnd);
ds(2:geo.ny+2) = ds(1) + cumsum(sqrt(diff(XUse).^2 + diff(YUse).^2));
if (iYStart <= jsepMatlab) && (iYEnd > jsepMatlab)
    sepOffset = mean(ds(jsepMatlab:jsepMatlab+1));
end
ds = ds - sepOffset;
end
