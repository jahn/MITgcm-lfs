
close all
itr=6400;
rac='./';

xcs=rdmds([rac,'XC']);
ycs=rdmds([rac,'YC']); 
xcg=rdmds([rac,'XG']);
ycg=rdmds([rac,'YG']);

delete plot_exf_diag.ps

dirname=pwd;
delim=findstr(dirname,'/');
runid=dirname(delim(end)+1:end);


flist={'T','S','Ttave','Stave',...
       'EXF_EmPmRTave',  'EXF_precip',    'EXF_swflux',...
       'EXF_hflux',      'EXF_QnetTave',...
       'EXF_lwflux',    'EXF_sflux', 'EXF_evap', 'EXF_hl', 'EXF_hs'};


for ipick=1:length(flist)
  fname=flist{ipick};
  fstring=strrep(fname,'_','\_');

t=rdmds(fname,itr);
tstring=[fstring,', iteration = ',num2str(itr),', ', runid];
slice = t(:,:,1);
idx = slice ~=0;
mx=max(max(slice(idx)));
mn=min(min(slice(idx)));



figure
shift=-1;
c1=35;
c2=40;
c1=-2;
c2=33;
c1=-2;
c2=140;
c1=mn;
c2=mx;

grph_CS(sq(t(:,:,1)),xcs,ycs,xcg,ycg,c1,c2,shift);
title(tstring);
print -dpsc2 -append plot_exf_diag.ps

end


return

