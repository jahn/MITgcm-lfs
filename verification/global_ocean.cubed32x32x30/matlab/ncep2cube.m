function ncep2cube
% Interpolates NCEP data onto cubed sphere
% Edit this script with path of NCEP data

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

% file list - ncep data
flist={'ncep_downsolar_monthly.cdf',...
       'ncep_precip_monthly.cdf',...
       'ncep_tair_monthly.cdf',...     
       'ncep_downlw_monthly.cdf',...
       'ncep_qair_monthly.cdf',...
       'ncep_runoff_monthly.cdf'};

% Label for plots
lbl={'solar - incoming solar radiation',...
     'rain - precipitation',...
     'tair - air temperature',  ...     
     'flw - downward longwave flux',...
     'qair - specific humidity',...
     'runoff'};

% Name of corresponding variable in pkg/therm_seaice
nm={'solr', 'prate', 'temp',  'lwflx', 'qa','runoff'};

% Scale Factors
% Note reverse sign convention for some fields, see pkg/bulk_forcing/BULKF.h
scaleFac=[-1, -1.0E-3, 1., -1.,  1.0, 1.0];


% delete file for plots
delete ncep2cube.ps

for ifile=1:length(flist)
  if ifile > 1
    clear Qshift;
    clear xs;
  end
  filename=flist{ifile};
  disp(filename);
  ncepFile=fullfile(archivedir,filename);
  ncload(ncepFile );

  % Rotate data in x so that it goes from -180 to 180
  % instead of 0 to 360
  xs=X-X(97);
  xs(end+1)=(xs(end)-xs(end-1))+xs(end);

  ys=Y;
  Qshi = permute(sq(eval(nm{ifile})),[3 2 1]);
  Qshift(97:192,:,:)=Qshi(1:96,   :,:);
  Qshift(1:96,  :,:)=Qshi(97:192, :,:);


  %Wrap one bin around 
  Qshift(end+1,  :,:) = Qshift(1,:,:);


  % Interpolate data
  Q=redo(Qshift, xs,ys,yc,xc,msk);
  Q=Q*scaleFac(ifile);

% Permute indcies for cubed sphere 32x32x6 becomes 32x6x32
  Qpermute=permute(Q,[1 3 2 4 5]);

  % write output file
  fout=[filename(1:end-12),'_cubed.bin'];
  wrda(fout,Qpermute,1,fmt,Ieee);

  % display min and max
  mx=max(max(max(max(Qpermute))));
  mn=min(min(min(min(Qpermute))));
  disp(['   min = ',num2str(mn),' max = ',num2str(mx)])

  % plot data
  if 1==1

    figure(ifile)
    imonth = 3;
    subplot(2,1,1)
    
    imagesc(xs,ys,sq(Qshift(:,:,imonth))');
    set(gca,'yDir','normal');
    title([strrep(filename,'_','\_'),' month=',num2str(imonth)]);
    colorbar('horiz')

    xcs=rdmds(fullfile(path,'XC'));
    ycs=rdmds(fullfile(path,'YC')); 
    xcg=rdmds(fullfile(path,'XG'));
    ycg=rdmds(fullfile(path,'YG'));
    ny=32;
    for n=1:6,
      v2d([(n-1)*ny+1:n*ny],[1:ny])=Q([1:ny],[1:ny],n, imonth);
    end

    subplot(2,1,2)
    shift=-1;
    c1=0;
    c2=0;
    grph_CS(sq(v2d),xcs,ycs,xcg,ycg,c1,c2,shift)
    h=title([strrep(fout,'_','\_'),'  ',lbl{ifile}]);
    print -dpsc2 -append ncep2cube.ps
  end


end
return

function Q=redo(Qshi, xs,ys,yc,xc,msk)


for jj=1:12,
  for t=1:size(xc,3);
    Q(:,:,t,jj)=interp2(ys,xs,sq(Qshi(:,:,jj)),yc(:,:,t),xc(:,:,t)) .*msk(:,:,t);
  end
end
Q( isnan(Q) )=0;

return



