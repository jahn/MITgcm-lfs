function plot_psi
% Plots Barotropic stream function 
% for cubed sphere runs.
% Must edit this script with
%    1) Input path of data files
%    2) Model thicknesses
% File for cell edges must be co-located with 
% data isoLat_cube32_59.
% Takes last iteration of data.
%
% Calls:
%   rdmds - mitgcmuv data i/o
%   calc_PsiCube, set_axis

% Set path for input data
path='../run/';
path='../xx/';


% Model thicknesses
delR=[10.0, 10.0, 15.0, 21.0, 28.0, 36.0, 45.0, 55.0, 66.0, 78.0,...
       91.0,105.0,120.0,136.0,154.0,172.0,191.0,211.0,232.0,254.0,...
      278.0,302.0,327.0,353.0,380.0,408.0,437.0,466.0,497.0,529.0];




% load data
vv=rdmds(fullfile(path,'vVeltave'),NaN);
uu=rdmds(fullfile(path,'uVeltave'),NaN);
hFacS=rdmds(fullfile(path,'hFacS'));
hFacW=rdmds(fullfile(path,'hFacW'));


% Compute
[psi,mskZ,ylat]=calc_PsiCube(uu,vv,hFacW,hFacS, path, delR);



% Compute stuff for plot axes
ylatRng = [-90, ylat, 90]; 
zed=[0,delR]*-1;
zed=zed(end:-1:1);
zf=-cumsum([0,delR]);



% Plot
[cs,h]=contour(ylatRng, zf, psi',[-60:5:60] );
clabel(cs,h);
title('Barotropic stream function (SV)')
