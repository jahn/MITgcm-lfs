function plot_ts
%Plots annual averaged surface T and S
%from cubed-sphere ocean run.
%Need to edit this script to set input path.
%Takes last iteration found.
%Assumes that fields have been averaged
%on a yearly average basis.
%
% Calls:
%   sq - Puts NaN on data values of zero (for outlining continents)
%   rdmds - mitgcmuv data i/o


% The input path for Ttave, Stave and grid files
inputDirPath='../run/';
inputDirPath='../xx/';

% Load grids
xcs=rdmds(fullfile(inputDirPath,'XC'));
ycs=rdmds(fullfile(inputDirPath,'YC')); 
xcg=rdmds(fullfile(inputDirPath,'XG'));
ycg=rdmds(fullfile(inputDirPath,'YG'));
x=rdmds(fullfile(inputDirPath,'XC'));
y=rdmds(fullfile(inputDirPath,'YC'));

% Load data
t=rdmds(fullfile(inputDirPath,'Ttave'),NaN);
s=rdmds(fullfile(inputDirPath,'Stave'),NaN);

% Plot temperature
figure(1)
shift=-1;
c1=-2;
c2=30;

grph_CS(sq(t(:,:,1)),xcs,ycs,xcg,ycg,c1,c2,shift)
title('Annual average surface temperature (C)');

% Plot salinity
figure(2)
shift=-1;
c1=25;
c2=40;

grph_CS(sq(s(:,:,1)),xcs,ycs,xcg,ycg,c1,c2,shift)
title('Annual average surface salinity ');





