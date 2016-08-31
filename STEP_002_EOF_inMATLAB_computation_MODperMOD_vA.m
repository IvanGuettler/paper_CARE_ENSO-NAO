clear all; close all; clc

%% Compute

pkg load netcdf

for  SEAS=[1:12];

    TNT=40*15;
    if (SEAS==1) ; TNT=39*15; end
    if (SEAS==11); TNT=39*15; end
    if (SEAS==12); TNT=39*15; end

    SEAStxt{ 1}='JFM';
    SEAStxt{ 2}='FMA';
    SEAStxt{ 3}='MAM';
    SEAStxt{ 4}='AMJ';
    SEAStxt{ 5}='MJJ';
    SEAStxt{ 6}='JJA';
    SEAStxt{ 7}='JAS';
    SEAStxt{ 8}='ASO';
    SEAStxt{ 9}='SON';
    SEAStxt{10}='OND';
    SEAStxt{11}='NDJ';
    SEAStxt{12}='DJF';

RCM=ncread(['./XXX_',SEAStxt{SEAS},'.nc'],'pr');
lon=ncread('./XXX_DJF.nc','lon');
lat=ncread('./XXX_DJF.nc','lat');
[LON,LAT]=meshgrid(lon,lat);

for x=1:160
    for y=1:91
        RCM(x,y,:)=RCM(x,y,:)*sqrt(cosd(LAT(y,x)));
    end
end

%%
RCMr=reshape(RCM(:),160*91,TNT); RCMr=RCMr';

P=160*91;
N=TNT;
%%
r=0;
for p=1:P;
    if (isfinite(RCMr(1,p)));
        r=r+1;
        RCMrr(1:TNT,r)=RCMr(1:TNT,p);
    end
end
%%

[LRCM, EOFsRCM, PCRCM, error, norms] = EOF( RCMrr, TNT);

RCM_EOFs_grid=nan(5,14560);
RCM_EOFs_finl=nan(5,160,91);

for k=1:5;
r=0;
for p=1:P;

    if (isfinite(RCMr(1,p)));
        r=r+1;
        RCM_EOFs_grid(k,p)=EOFsRCM(r,k);
    end

end
    RCM_EOFs_final(:,:,k)=reshape(RCM_EOFs_grid(k,:),160,91)*sqrt(LRCM(k));
end

%% Save output

filename=['EOF_',SEAStxt{SEAS},'_MODperMOD_vA.nc'];

nccreate(filename,'time', 'Format','classic','Dimensions', {'time',  5}); %Ovo je zapravo EOF mod no za potrebe GrADS-a stavljam vrijeme
nccreate(filename,'lon', 'Format','classic','Dimensions',  {'lon', 160});
nccreate(filename,'lat', 'Format','classic','Dimensions',  {'lat',  91});

nccreate(filename,'RCM_EOF', 'Format','classic','Dimensions', {'lon', 160 , 'lat', 91,'time', 5});

tito=[1:1:5]';
 ncwrite(filename,'lon',  double(lon),      [1]);
 ncwrite(filename,'lat',  double(lat),      [1]);
 ncwrite(filename,'time', double(tito),     [1]);

 ncwrite(filename,'RCM_EOF', RCM_EOFs_final, [1 1 1]);

 ncwriteatt(filename,'lon','standard_name','longitude');
 ncwriteatt(filename,'lon','long_name','longitude');
 ncwriteatt(filename,'lon','axis','X');
 ncwriteatt(filename,'lon','units','degrees_east');

    ncwriteatt(filename,'lat','standard_name','latitude');
    ncwriteatt(filename,'lat','long_name','latitude');
    ncwriteatt(filename,'lat','axis','Y');
    ncwriteatt(filename,'lat','units','degrees_north');

    ncwriteatt(filename,'time','standard_name','time');
    ncwriteatt(filename,'time','long_name','time');
    ncwriteatt(filename,'time','calendar','standard');
    ncwriteatt(filename,'time','units','months since 1950-01-01 00:00:00');

    ncwriteatt(filename,'RCM_EOF','standard_name','RCM EOFs');
    ncwriteatt(filename,'RCM_EOF','long_name',    'RCM EOFs');
    ncwriteatt(filename,'RCM_EOF','coordinates',  'lon lat');

close all
clear RCM* R* e* E* P* L* n*

end %SEAS
