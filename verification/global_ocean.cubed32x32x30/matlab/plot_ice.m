
close all
itr=230400;

delete plot_ice.ps

rac='./';

xcs=rdmds([rac,'XC']);
ycs=rdmds([rac,'YC']); 
xcg=rdmds([rac,'XG']);
ycg=rdmds([rac,'YG']);
x=rdmds('XC');
y=rdmds('YC');

flist ={'ICE_fresh-T',      'ICE_Qleft-T',       'ICE_Tice1-T',...
	'ICE_iceheight-T',  'ICE_snowheight-T',  'ICE_Tice2-T',...
	'ICE_icemask-T',    'ICE_snow-T',        'ICE_Tsrf-T'};


for i=1:length(flist)
  filname=flist{i};


  t=rdmds(filname,itr);
  t=sq(t);
  tstring=filname;
  %min(min(min(t)))
  %max(max(max(t)))


  if 1==1
    figure(i)
    shift=-1;
    c1=0;
    c2=0;
    grph_CS(t(:,:,1),xcs,ycs,xcg,ycg,c1,c2,shift)
    title([strrep(tstring,'_',' '),' itr =',num2str(itr)]);
    print -dpsc2 -append plot_ice.ps
  end

  if 1==0
  figure(i+20)
  %displaytiles(t)
  displaytiles( tiles(sq(t),1:6))
  title(strrep(tstring,'_','-'));
  end


end
