
close all
itr=230400;

delete plot_flux.ps

rac='./';

xcs=rdmds([rac,'XC']);
ycs=rdmds([rac,'YC']); 
xcg=rdmds([rac,'XG']);
ycg=rdmds([rac,'YG']);
x=rdmds('XC');
y=rdmds('YC');

flist ={'BULK_EmPmR',  'BULK_fv',        'BULK_solar',...
	'BULK_evap',   'BULK_latent',    'BULK_ssq'...
	'BULK_flwup',    'BULK_Qnet'...
	'BULK_fu',     'BULK_sensible', 'BULK_flwupnet'};

lbls  ={'empmr=-evap+rain-runoff',  ' ', 'fswnet=solar*(1-albedo), W/m^2',...
	'evap, evaporation rate',   'flh (-latent heat flux, W/m^2)',    'savssq:  Surface specific humidity, km/km'...
	'flwup (-upward greybody radiation, W/m^2)',    'qnet=-(fsh+flh+flwup-solar*(1-albedo) ), W/m^2'...
	' ',     'fsh (-sensible head flux, W/m^2)', ...
	'flwupnet = -(flwup - flw), W/m^2'};




%for i=1:length(flist)
for i=4:4
  filname=flist{i};


  t=rdmds(filname,itr);
  t=sq(t);
  tstring=[filname,' ',lbls{i}];
  %min(min(min(t)))
  %max(max(max(t)))


  if ~(i== 2 | i==9)
    figure(i)
    shift=-1;
    c1=0;
    c2=0;
    grph_CS(t(:,:,1),xcs,ycs,xcg,ycg,c1,c2,shift)
    title(strrep(tstring,'_','-'));
    print -dpsc2 -append plot_flux.ps
  end

   if 0==1
  figure(i+20)
  %displaytiles(t)
  displaytiles( tiles(sq(t),1:6))
  title(strrep(tstring,'_','-'));
end

  %print -Pcolor1519
  %pause(3)





end
