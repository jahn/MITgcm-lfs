function grph_CS(var,xcs,ycs,xcg,ycg,c1,c2,shift)
% grph_CS(var,xcs,ycs,xcg,ycg,c1,c2,shift) : produce a flat plot of the
%  cube_sphere "var" keeping the initial grid (no interpolation, use "surf")
% xcs,ycs,xcg,ycg = center + corner grid point coordinates
% c1 < c2 = min & max for the color graph
% c1 > c2 = scale with min,max of the field, + c1/100 and + c2/100
% shift=-1 : No coast-line
%     else : draw coast-line shifted by "shift" degree.
%-----------------------

%------------------------------
nc=size(var,2) ; ncp=nc+1 ;
  mx=min(min(var));
  mn=max(max(var));
  for j=1:nc, for i=1:6*nc,
   if var(i,j) ~= NaN ; mn=min(var(i,j),mn); mx=max(var(i,j),mx) ; end
  end ; end ;
%------------
if c1 >= c2
  mb=(mx-mn)*0.01;
  c1=mn+mb*c1;
  c2=mx+mb*c2;
  if c1*c2 < 0 
   c2=max(abs([c1 c2]));
   c1=-c2;
  end
  fprintf('min,max %8.3e %8.3e Cmin,max %8.3e %8.3e \n',mn,mx,c1,c2)
end
%------------------------------
%figure(1);
if shift ~= -1 
  path('/u/u0/jmc/MATLAB',path);
  set_axis
  fac=rad ;
else
  fac=1. ;
end
%---
nbsf = 0 ; ic = 0 ; jc = 0 ;
[xx2]=split_Z_cub(xcg);
[yy2]=split_Z_cub(ycg);
%---
for n=1:6,
 %if n < 5 & n > 2,
 if n < 7,
%--------------------------------------------------------
 i0=nc*(n-1);
 vv1=zeros(ncp,ncp) ; xx1=vv1 ; yy1=vv1 ;
 for j=1:nc, for i=1:nc,
  vv1(i,j)=var(i0+i,j) ;
 end ; end ;
 for j=1:nc,
  vv1(ncp,j)=vv1(nc,j) ;
 end
 for i=1:nc,
  vv1(i,ncp)=vv1(i,nc) ;
 end
  vv1(ncp,ncp)=vv1(nc,nc) ;
%-----
  xx1=xx2(:,:,n);
  yy1=yy2(:,:,n);
  if xx1(ncp,1) < -300. ; xx1(ncp,1)=xx1(ncp,1)+360. ; end
  if xx1(1,ncp) < -300. ; xx1(1,ncp)=xx1(1,ncp)+360. ; end
%------------
if shift <= -360
%--- Jump ? (only for debug diagnostic) :
 for i=1:nc, for j=1:nc,
   if abs(xx1(i,j)-xx1(i,j+1)) > 120
     fprintf('N: i,J,xx_j,j+1,+C %3i %3i %3i %8.3e %8.3e %8.3e \n', ...
             n, i,j,xx1(i,j), xx1(i,j+1), xcs(i0+i,j) ) ; end 
   if abs(xx1(i,j)-xx1(i+1,j)) > 120
     fprintf('N: I,j,xx_i,i+1,+C %3i %3i %3i %8.3e %8.3e %8.3e \n', ...
             n, i,j,xx1(i,j), xx1(i+1,j), xcs(i0+i,j) ) ; end
 end ; end   
%---
end
%--------------------------------------
% case where Xc jump from < 180 to > -180 when j goes from jc to jc+1
 
 if n == 4 | n == 3
  jc=17 ;
  nbsf=part_surf(nbsf,fac,xx1,yy1,vv1,1,ncp,1,jc,c1,c2) ;
  for i=1:ncp,
    if xx1(i,jc) > 120 ; xx1(i,jc)= xx1(i,jc)-360. ; end
    if yy1(i,jc) == 90 & xx1(i,jc) == 90, xx1(i,jc)=-90; end
  end
  nbsf=part_surf(nbsf,fac,xx1,yy1,vv1,1,ncp,jc,ncp,c1,c2) ;
%---
% case where Xc jump from < -180 to > 180 when i goes from ic to ic+1
 elseif n == 6
  ic=17 ;
  nbsf=part_surf(nbsf,fac,xx1,yy1,vv1,ic,ncp,1,ncp,c1,c2) ;
  for j=1:ncp,
    if xx1(ic,j) > 120 ; xx1(ic,j)= xx1(ic,j)-360. ; end
    if yy1(ic,j) == -90 & xx1(ic,j) == 90, xx1(ic,j)=-90; end
  end
  nbsf=part_surf(nbsf,fac,xx1,yy1,vv1,1,ic,1,ncp,c1,c2) ;
 else
  nbsf=part_surf(nbsf,fac,xx1,yy1,vv1,1,ncp,1,ncp,c1,c2) ;
 end
%--------------------------------------
end ; end ; 
hold off
if shift ~= -1 
  m_proj('Equidistant Cylindrical','lat',90,'lon',[-180+shift 180+shift]) 
  %m_proj('Equidistant Cylindrical','lat',[-0 60],'lon',[-180+shift 180+shift]) 
  m_coast('color',[0 0 0]);
  m_grid('box','on')
end

%--
  scalHV_colbar([1.0 1.0 0.7 0.7],0);
if shift == -1,
 text(-150*fac,-150*fac,sprintf('min,Max= %9.5g  , %9.5g', mn, mx))     
 %set(gca,'position',[-.1 0.2 0.8 0.75]); % xmin,ymin,xmax,ymax in [0,1]
else text(0.,-150.*fac,sprintf('min,Max= %9.5g  , %9.5g', mn, mx))     
end
return
%----------------------------------------------------------------------
function nbsf=part_surf(nbsf,fac,xx,yy,vv,i1,i2,j1,j2,c1,c2)
  S=surf(fac*xx(i1:i2,j1:j2),fac*yy(i1:i2,j1:j2), ...
         zeros(i2+1-i1,j2+1-j1),vv(i1:i2,j1:j2)) ;
  if c1 < c2, caxis([c1 c2]) ; end
  set(S,'LineStyle','-','LineWidth',0.01); %set(S,'EdgeColor','none');
  %set(S,'Clipping','off');
  %get(S) ;
  %nbsf = nbsf+1 ; if nbsf == 1 ; hold on ; view(0,90) ; end
  nbsf = nbsf+1 ; if nbsf == 1 ; hold on ; view(0,90) ; end
   %axis([-180 0 -90 30]) ; % work only without coast-line
   %axis([90 180 -60 0]) ; % work only without coast-line
   axis([-180 180 -90 90]) ; % work only without coast-line
   %axis([30 60 -45 -25]) ; % work only without coast-line
return
%----------------------------------------------------------------------

