function plot_flux
% Plots diagnostic terms from bulk_forcing package
% Note that most sign conventions are reverse
% from model conventions.
% By default, takes last iteration of data files found.


close all

delete plot_flux.ps

filepath='./';

xcs=rdmds(fullfile(filepath,'XC'));
ycs=rdmds(fullfile(filepath,'YC')); 
xcg=rdmds(fullfile(filepath,'XG'));
ycg=rdmds(fullfile(filepath,'YG'));

flist ={'BULK_EmPmR',  'BULK_fv',        'BULK_solar',...
	'BULK_evap',   'BULK_latent',    'BULK_ssq'...
	'BULK_flwup',  'BULK_Qnet'...
	'BULK_fu',     'BULK_sensible', 'BULK_flwupnet'};

lbls  ={'empmr=-evap+rain-runoff',  ' ', 'fswnet=solar*(1-albedo), W/m^2',...
	'evap, evaporation rate',   'flh (-latent heat flux, W/m^2)',    'savssq:  Surface specific humidity, km/km'...
	'flwup (-upward greybody radiation, W/m^2)',    'qnet=-(fsh+flh+flwup-solar*(1-albedo) ), W/m^2'...
	' ',     'fsh (-sensible head flux, W/m^2)', ...
	'flwupnet = -(flwup - flw), W/m^2'};




for i=1:length(flist)
  filname=flist{i};


  t=rdmds(fullfile(filepath,filname),NaN);
  t=sq(t);
  tstring=[filname,' ',lbls{i}];

  figure(i)
  if ~(i== 2 | i==9)
    shift=-1;
    c1=0;
    c2=0;
    grph_CS(t(:,:,1),xcs,ycs,xcg,ycg,c1,c2,shift)
    title(strrep(tstring,'_','-'));
    print -dpsc2 -append plot_flux.ps
  else
    %       displaytiles( tiles(sq(t),1:6))
    %       title(strrep(tstring,'_','\_'));
  end

end
