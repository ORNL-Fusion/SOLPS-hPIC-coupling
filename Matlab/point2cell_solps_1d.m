function [I1,ierr] = point2cell_solps_1d(varargin)
% [I1,ierr] = point2cell_solps_1d(geo,R1,Z1)
% [I1,ierr] = point2cell_solps_1d(cellR,cellZ,R1,Z1)
%
% either give geo (and geo.pr(1:npts,1:npoly) and geo.pz(1:npts,1:npoly) will be used)
% or give these 2d cell arrays manually (nargin == 4). 
% R1, R2 must be 1d vectors!

if nargin == 3
    % geo,R1,Z1
    geo = varargin{1};
    cellR = geo.pr;
    cellZ = geo.pz;
    R1 = varargin{2};
    Z1 = varargin{3};
elseif nargin == 4
    cellR = varargin{1};
    cellZ = varargin{2};
    R1 = varargin{3};
    Z1 = varargin{4};    
end
    

% works in matlab indices
DEBUG = 0;

Npts = length(R1);
if Npts ~= length(Z1)
    error('bad inputs')
end

METHOD = 2; % 1 is check each cell, stop on find

I1 = NaN(1,Npts);
ierr(1:Npts) = 1;
switch METHOD
    case 1        
        if Npts ~= 1
            error('Only one point can be checked at a time')
        end

        for i = 1:size(cellR,2)
            Itest = inpolygon(R1,Z1,cellR(:,i),cellZ(:,i));
            if Itest ~= 0
                I1 = i;
                ierr = 0;
                break;
            end
        end
    case 2

        Itest = NaN(Npts,size(cellR,2));
        for i = 1:size(cellR,2)
            Itest(:,i) = inpolygon(R1,Z1,cellR(:,i),cellZ(:,i));
        end        
        for i = 1:Npts
            I1tmp = find(Itest(i,:) == 1);            
            if ~isempty(I1tmp)
                I1(i) = I1tmp;
                ierr(i) = 0;
            end
        end
        
    case 3
        % This checks all but doesn't tell you which one
        npoly = size(cellR,1);
        polyX = NaN(1,(npoly+1)*size(cellR,2));
        polyY = NaN(1,(npoly+1)*size(cellR,2));
        for i = 1:size(cellR,2)
            i1 = 1 + (i-1)*(npoly+1);
            i2 = i1 + npoly;
            polyX(i1:i2-1) = cellR(:,i);
            polyY(i1:i2-1) = cellZ(:,i);
        end
        Itest = inpolygon(R1,Z1,polyX,polyY);
        error('this isnt complete')
        
    otherwise
        error('bad METHOD')
end

if DEBUG && Npts == 1
    fprintf('Trying to find point [R,Z] = [%f,%f]\n',R1,Z1)
    if ierr == 1
        warning('Point not found in grid!!')
    else
        fprintf('Found point at I1 = %d\n',I1)
        for i = 1:size(cellR,1)
            fprintf('Cell point %d: R = %f, Z = %f\n',i,cellR(i,I1),cellZ(i,I1))
        end
    end
end