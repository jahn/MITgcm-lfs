function [psi,mskZ,ylat]=calc_PsiCube(uu,vv,hFacW,hFacS, rac, delR);
% [psi,mskZ,ylat]=calc_PsiCube(uu,vv[,hFacW,hFacS, path, delR]);
% JMC

%- Units: dx,dy /1e6 ; delR /1e3 [hPa] ; psi in 10^9 kg/s
set_axis
krd=2; jprt=0;

if (nargin < 3), kfac=0;
else kfac=1; end;

if krd > 1,
 bk_lineF=fullfile(rac,'isoLat_cube32_59');

%- load broken lines :
% bkl_Ylat,bkl_Npts,bkl_Flg,bkl_Iuv,bkl_Juv,bkl_Xsg,bkl_Ysg
 load(bk_lineF);


%- load the grid dx,dy , convert to 10^6 m :
 dxg=rdmds(fullfile(rac,'DXG')); dxg=dxg*1.e-6;
 dyg=rdmds(fullfile(rac,'DYG')); dyg=dyg*1.e-6;

 fprintf([' load bk_line description from file=',bk_lineF, ...
          '  AND dxg,dyg files \n']);
end

%- compute the horizontal transport ut,vt :
nc=size(uu,2);
ut=zeros(6*nc,nc,nr); vt=zeros(6*nc,nc,nr);
for k=1:nr,
 ut(:,:,k)=dyg.*uu(:,:,k); 
 vt(:,:,k)=dxg.*vv(:,:,k);
end

ydim=length(bkl_Ylat); ylat=bkl_Ylat;
ufac=rem(bkl_Flg,2) ; vfac=fix(bkl_Flg/2) ;

vz=zeros(ydim,nr);
for jl=1:ydim,
 if jl == jprt, fprintf(' jl= %2i , lat= %8.3f , Npts= %3i :\n', ...
                        jl,ylat(jl),bkl_Npts(jl)); end
 for ii=1:bkl_Npts(jl),
  i=bkl_Iuv(ii,jl); j=bkl_Juv(ii,jl);
  if jl == jprt, 
   fprintf(' no= %3i : Flg,I,J= %2i (%2i,%2i) %3i %3i (nf=%i,il=%2i)\n', ...
   ii,bkl_Flg(ii,jl),ufac(ii,jl),vfac(ii,jl),i,j,1+fix((i-1)/nc),1+rem(i-1,nc));
  end
  for k=1:nr,
   vz(jl,k)=vz(jl,k)+ufac(ii,jl)*ut(i,j,k)+vfac(ii,jl)*vt(i,j,k);
  end
 end
end
  
psi=zeros(ydim+2,nr+1); mskZ=zeros(ydim+2,nr+1); 
for j=1:ydim, for k=nr:-1:1,
%   psi(j+1,k)=psi(j+1,k+1) + delR(k)*vz(j,k)/g ;
   psi(j+1,k)=psi(j+1,k+1) + delR(k)*vz(j,k) ;
end ; end

%- compute the mask :
if kfac == 1, 
 mskV=zeros(ydim+2,nr); 
 ufac=abs(ufac) ; vfac=abs(vfac) ;
 for jl=1:ydim,
  for ii=1:bkl_Npts(jl),
   i=bkl_Iuv(ii,jl); j=bkl_Juv(ii,jl);
   for k=1:nr,
    mskV(jl+1,k)=mskV(jl+1,k)+ufac(ii,jl)*hFacW(i,j,k)+vfac(ii,jl)*hFacS(i,j,k);
   end
  end
 end
%- to keep psi=0 on top & bottom
 mskZ(:,[2:nr+1])=mskV; 
 mskZ(:,[1:nr])=mskZ(:,[1:nr])+mskV;
%- to keep psi=0 on lateral boundaries :
 mskZ([1:ydim],:)=mskZ([1:ydim],:)+mskZ([2:ydim+1],:);
 mskZ([2:ydim+1],:)=mskZ([2:ydim+1],:)+mskZ([3:ydim+2],:);
 mskZ=ceil(mskZ); mskZ=min(1,mskZ);
 psi(find( mskZ == 0 ))=NaN ;
end;
%----------------- 

return
