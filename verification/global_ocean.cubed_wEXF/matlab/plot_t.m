
close all
itr=6393;
itr=6410;
rac='./';

xcs=rdmds([rac,'XC']);
ycs=rdmds([rac,'YC']); 
xcg=rdmds([rac,'XG']);
ycg=rdmds([rac,'YG']);


t=rdmds('T',itr);
tstring=['T, level 1, iteration = ',num2str(itr)];
min(min(min(t)))
max(max(max(t)))



figure
shift=-1;
c1=35;
c2=40;
c1=-2;
c2=33;

c1=-2;
c2=40;
c1=-2;
c2=40;


grph_CS(sq(t(:,:,1)),xcs,ycs,xcg,ycg,c1,c2,shift)
title(tstring);

return



xi=-179:2:180;yi=-89:2:90;
ti=cube2latlon(x,y,t,xi,yi);

figure
imagesc(ti(:,:,2)')
set(gca,'yDir','normal')
title(tstring)
colorbar


j=75;
figure
imagesc(squeeze(ti(j,:,:))')
colorbar
title([tstring,' i= ',num2str(j)]);

