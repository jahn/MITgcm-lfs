function ncep2cubeWind
% Interpolates NCEP data onto cubed sphere
% for wind speed on tracer points.
% Edit this script with path of NCEP data.

% Location of NCEP monthly climatology files
archivedir='/u/u2/cheisey/stephd/ncep';
disp(['Reading NCEP data from ',archivedir]);

% data path for grids
path='./';

% Load grids
load FMT.mat
load HGRID.mat nxc nyc lon_lo lon_hi lat_lo lat_hi xc yc zA GRID yg
load MASKS
if ndims(msk)==4
 msk=msk(:,:,:,1);
else
 msk=msk(:,:,1);
end

load TUV


flist={'ncep_uwind_monthly.cdf','ncep_vwind_monthly.cdf'};



% load data
ncepPath=fullfile(archivedir,flist{1});
ncload(ncepPath );
ncepPath=fullfile(archivedir,flist{2});
ncload(ncepPath );



% Rotate data in x so that it goes from -180 to 180
% instead of 0 to 360
xs=X-X(97);
ys=Y;
U = permute(sq(u),[3 2 1]);
V = permute(sq(v),[3 2 1]);
Ushift(97:192,:,:)=U(1:96,   :,:);
Ushift(1:96,  :,:)=U(97:192, :,:);
Vshift(97:192,:,:)=V(1:96,   :,:);
Vshift(1:96,  :,:)=V(97:192, :,:);


%Wrap one bin around 
Vshift(end+1,  :,:) = Vshift(1,:,:);
Ushift(end+1,  :,:) = Ushift(1,:,:);
xs(end+1)=(xs(end)-xs(end-1))+xs(end);


% month to plot for sanity check
imo=1;

figure(1)
imagesc(xs,ys,Ushift(:,:,imo)')
set(gca,'yDir','normal');
colorbar('horiz')
title(['X Wind speed (m/s) at trancer points for month ',num2str(imo)])
figure(2)
imagesc(xs,ys, Vshift(:,:,imo)')
set(gca,'yDir','normal');
title(['Y Wind speed (m/s) at trancer points for month ',num2str(imo)])
colorbar('horiz')



% interpolate winds on the tracer points
tx=redo(Ushift, xs,ys,yc,xc,msk);
ty=redo(Vshift, xs,ys,yc,xc,msk);

% Compute windspeed
for jj=1:12,
  windSpeed(:,:,:,jj) =   sqrt( tx(:,:,:,jj).^2 +   ty(:,:,:,jj).^2);
end



% Rotate coordinates as necessary for each cubed-sphere tile
for jj=1:12,

  Tx(:,:,:,jj)= TVv.*tx(:,:,:,jj)-TUv.*ty(:,:,:,jj);
  Ty(:,:,:,jj)=-TVu.*tx(:,:,:,jj)+TUu.*ty(:,:,:,jj);

end

% Permute indcies for cubed sphere 32x32x6x12 becomes 32x6x32x12
Ty=permute(Ty,[1 3 2 4 5]);
Tx=permute(Tx,[1 3 2 4 5]);
windSpeed=permute(windSpeed,[1 3 2 4 5]);


fout=['ncep_uwind_cubed.bin'];
wrda(fout,Ty,1,fmt,Ieee);
stats(Tx)

fout=['ncep_vwind_cubed.bin'];
wrda(fout,Ty,1,fmt,Ieee);
stats(Ty)

fout=['ncep_windspeed_cubed.bin'];
wrda(fout,windSpeed,1,fmt,Ieee);
stats(windSpeed)

figure(5)
displaytiles( tiles( sq( reshape( windSpeed(:,:,:,imo),[32*6 32])  ) ,1:6))
title(['Wind sp (m/s), month ',num2str(imo)])
title(['Wind speed (m/s) at trancer points for month ',num2str(imo)])



figure(3)
displaytiles( tiles( sq( reshape( Tx(:,:,:,imo),[32*6 32])  ) ,1:6))
title(['X Wind sp (m/s), month ',num2str(imo)])
figure(4)
displaytiles( tiles( sq( reshape( Ty(:,:,:,imo),[32*6 32])  ) ,1:6))
title(['Y Wind sp (m/s), month ',num2str(imo)])
return



function Q=redo(Qshi, xs,ys,yc,xc,msk)


for jj=1:12,
 for t=1:size(xc,3);
  Q(:,:,t,jj)=interp2(ys,xs,sq(Qshi(:,:,jj)),yc(:,:,t),xc(:,:,t)) .*msk(:,:,t);
 end
end
Q( isnan(Q) )=0;

return



