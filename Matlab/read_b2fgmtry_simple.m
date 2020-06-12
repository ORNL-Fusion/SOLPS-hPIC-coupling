function geo = read_b2fgmtry_simple(file)

% Open file
[fid,msg] = fopen(file);
if (fid == -1)
   error(msg);
end

line    = fgetl(fid);
version = line(8:17);


%% Read dimensions nx, ny
dim = read_ifield(fid,'nx,ny',2);
nx  = dim(1);
ny  = dim(2);
geo.nx = nx;
geo.ny = ny;

%% * isymm - integer.
% * isymm specifies the type of symmetry of the geometry: isymm.eq.0
% * implies a slab geometry, isymm.eq.1.or.isymm.eq.2 imply rotational
% * symmetry about the crx=0 axis, and isymm.eq.3.or.isymm.eq.4
% * indicate rotational symmetry about the cry=0 axis.
geo.isymm = read_ifield(fid,'isymm',1);

%% CELL GEOMETRY
% crx, cry - (-1:nx,-1:ny,0:3) real*8 array.
% * For (ix,iy) in (-1:nx,-1:ny), crx(ix,iy,0:3) specify the
% * horizontal coordinates and cry(ix,iy,0:3) specify the vertical
% * coordinates (in the physical plane) of the four corners of the
% * (ix,iy) cell, mapped as follows:
% * (,,0): lower left corner, (,,1): lower right corner,
% * (,,2): upper left corner, (,,3): upper right corner.
geo.crx     = read_rfield(fid,'crx'    ,[nx+2,ny+2,4]);
geo.cry     = read_rfield(fid,'cry'    ,[nx+2,ny+2,4]);

%% POTENTIAL FOR B
% * fpsi - (-1:nx,-1:ny,0:3) real*8 array.
% * For (ix,iy,i) in (-1:nx,-1:ny,0:3), fpsi(ix,iy,i) specifies the
% * potential for the magnetic field components (bx,by) at the
% * (ix,iy,i) position.
% * In the case of toroidal or cylindrical symmetry,
% * bx=(dpsi/dy)/(2*pi*R) and by=-(dpsi/dx)/(2*pi*R),
% * where R is the distance to the axis of symmetry.)
geo.fpsi     = read_rfield(fid,'fpsi'    ,[nx+2,ny+2,4]);

%% * ffbz - (-1:nx,-1:ny,0:3) real*8 array.
% * For (ix,iy,i) in (-1:nx,-1:ny,0:3), ffbz(ix,iy,i) specifies the
% * field function for the magnetic field component bz at the
% * (ix,iy,i) position.
% * (In the case of straight symmetry, bz=ffbz. In the case of
% * toroidal or cylindrical symmetry, bz=ffbz/(2*pi*R), where R is
% * the distance to the axis of symmetry.)
geo.ffbz     = read_rfield(fid,'ffbz'    ,[nx+2,ny+2,4]);

%% * bb - (-1:nx,-1:ny,0:3) real*8 array.
% * For (ix,iy) in (-1:nx,-1:ny), bb(ix,iy,0:3) specifies the
% * magnetic field at the center of the (ix,iy) cell.
% * bb(ix,iy,0:2) are the (x,y,z)-components and bb(ix,iy,3) is
% * the absolute magnetic field strength.
% * (bb(,,3)=sqrt(bb(,,0)**2+bb(,,1)**2+bb(,,2)**2.)
% * It will hold that 0.lt.bb(,,3).
geo.bb     = read_rfield(fid,'bb'    ,[nx+2,ny+2,4]);

%% * vol - (-1:nx,-1:ny) real*8 array.
% * For (ix,iy) in (-1:nx,-1:ny), vol(ix,iy) specifies the volume of
% * the (ix,iy) cell. (In the case of toroidal symmetry this volume
% * includes a factor 2*pi*crx, while in the case of cylindrical
% * symmetry it includes a factor 2*pi*cry.)
% * It will hold that 0.lt.vol(,).
geo.vol     = read_rfield(fid,'vol'    ,[nx+2,ny+2]);

%% * hx, hy, hz - (-1:nx,-1:ny) real*8 array. !srv 09.06.08
% * For (ix,iy) in (-1:nx,-1:ny), hx(ix,iy) and hy(ix,iy) specify the
% * x-diameter, the y-diameter and z-diameter respectively, of the
% * (ix,iy) cell.
% * It will hold that 0.lt.hx(,) and 0.lt.hy(,) and 0.lt.hz(,).
geo.hx     = read_rfield(fid,'hx'    ,[nx+2,ny+2]);
geo.hy     = read_rfield(fid,'hy'    ,[nx+2,ny+2]);

%% * qz - (-1:nx,-1:ny,0:1) real*8 array.
% * For (ix,iy) in (-1:nx,-1:ny), qz(ix,iy,0) specifies sin(t) and
% * qz(ix,iy,1) specifies cos(t), where t is the complementary angle
% * between the x-direction and the y-direction on the (ix,iy) cell.
% * t is in the range (-pi/2 to pi/2) and vanishes for an orthogonal
% * geometry. (qz(ix,iy,0) is the inner product of the x and y unit
% * vectors.)
% * It will hold that -1.lt.qz(,,0).lt.1 and 0.lt.qz(,,1).le.1.
geo.qz     = read_rfield(fid,'qz'    ,[nx+2,ny+2,2]);

%% * qc - (-1:nx,-1:ny) real*8 array, output.
% * For (ix,iy) in (-1:nx,-1:ny), qc(ix,iy) specifies cos(t), where
% * t is the complementary angle between the x-direction of the
% * (ix,iy) cell and its left face.
% * t is in the range (-pi/2 to pi/2) and vanishes for an orthogonal
% * geometry.
% * It will hold that 0.lt.qc(,).le.1.
geo.qc     = read_rfield(fid,'qc'    ,[nx+2,ny+2]);

%% * gs - (-1:nx,-1:ny,0:2) real*8 array.
% * (Let gsx(,)=gs(,,0), gsy(,)=gs(,,1) and gsz(,)=gs(,,2).)
% * For (ix,iy) in (0:nx,-1:ny), gsx(ix,iy) specifies the area of the
% * face between the (ix,iy) cell and its left neighbor. For ix.eq.-1,
% * gsx(ix,-1:ny) will hold 0.
% * For (ix,iy) in (-1:nx,0:ny), gsy(ix,iy) specifies the area of the
% * face between the (ix,iy) cell and its bottom neighbor. For iy.eq.-1,
% * gsy(-1:nx,iy) will hold 0.
% * For (ix,iy) in (-1:nx,-1:ny), gsz(ix,iy) specifies the area of the
% * (ix,iy) cell normal to the third (ignorable) coordinate.
geo.gs     = read_rfield(fid,'gs'    ,[nx+2,ny+2,3]);


geo.nlreg = read_ifield(fid,'nlreg',1);
geo.nlxlo = read_ifield(fid,'nlxlo',geo.nlreg);
geo.nlxhi = read_ifield(fid,'nlxhi',geo.nlreg);
geo.nlylo = read_ifield(fid,'nlylo',geo.nlreg);
geo.nlyhi = read_ifield(fid,'nlyhi',geo.nlreg);
geo.nlloc = read_ifield(fid,'nlloc',geo.nlreg);
geo.nncut = read_ifield(fid,'nncut',1);

geo.leftcut = read_ifield(fid,'leftcut',geo.nncut);
geo.rightcut = read_ifield(fid,'rightcut',geo.nncut);
geo.topcut = read_ifield(fid,'topcut',geo.nncut);
geo.bottomcut = read_ifield(fid,'bottomcut',geo.nncut);

geo.leftix = read_ifield(fid,'leftix',[nx+2,ny+2]);
geo.rightix = read_ifield(fid,'rightix',[nx+2,ny+2]);
geo.topix = read_ifield(fid,'topix',[nx+2,ny+2]);
geo.bottomix = read_ifield(fid,'bottomix',[nx+2,ny+2]);

geo.leftiy = read_ifield(fid,'leftiy',[nx+2,ny+2]);
geo.rightiy = read_ifield(fid,'rightiy',[nx+2,ny+2]);
geo.topiy = read_ifield(fid,'topiy',[nx+2,ny+2]);
geo.bottomiy = read_ifield(fid,'bottomiy',[nx+2,ny+2]);

geo.region = read_ifield(fid,'region',[nx+2,ny+2,3]);
geo.nnreg = read_ifield(fid,'nnreg',[3]);  % nvreg (volume), nxreg (x-directed), nyreg (y-directed)
geo.resignore = read_ifield(fid,'resignore',[nx+2,ny+2,2]);

geo.periodic_bc = read_ifield(fid,'periodic_bc',1);

% * pbs - (-1:nx,-1:ny,0:1) real*8 array.
% * (Let pbsx(,)=pbs(,,0) and pbsy(,)=pbs(,,1).)
% * For (ix,iy) in (-1:nx,-1:ny), pbsx(ix,iy) specifies the product
% * (bx/bb)*sx and pbsy(ix,iy) specifies (by/bb)*sy, or (magnetic
% * field pitch)*(surface area), namely the parallel contact area,
% * on the (ix,iy) cell left and bottom faces respectively.
% * In the case where the grid covers the full vacuum vessel,
% * pbsy also contains a contribution from the narrowing of the
% * flux tube when impacting the wall structures.
% * See routine b2xgbs for the form of interpolation employed.
geo.pbs = read_rfield(fid,'pbs',[nx+2,ny+2,2]);

try
    geo.parg = read_rfield(fid,'parg',[100]);
catch
    disp('Did not find parg in geo file')
end

%% Close file

fclose(fid);

geo.pr = reshape(geo.crx(:,:,[1,2,4,3]),(geo.nx+2)*(geo.ny+2),4).';
geo.pz = reshape(geo.cry(:,:,[1,2,4,3]),(geo.nx+2)*(geo.ny+2),4).';
geo.r2d_cen = mean(geo.crx,3);
geo.z2d_cen = mean(geo.cry,3);
geo.jsep = min(geo.topcut) - 1; 
geo.sx     = geo.gs(:,:,1);
geo.sy     = geo.gs(:,:,2);
geo.sxperp = geo.qz(:,:,2).*geo.sx;
geo.pitch  = geo.pbs(:,:,1)./geo.sxperp;
geo.sxprl  = abs(geo.pbs(:,:,1));
