clear all; close all; clc

%% Compute

pkg load netcdf
pkg load io
pkg load statistics

%for SEAS=[11:12];
for SEAS=[9];

    TNT=40;
    if (SEAS==1) ; TNT=39; end
    if (SEAS==11); TNT=39; end
    if (SEAS==12); TNT=39; end

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

CRU=ncread(['/home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_EOF/detrend_maskiran_subregion_',SEAStxt{SEAS},'_CRU.nc'],'pre');
ERA=ncread(['/home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_EOF/detrend_maskiran_subregion_',SEAStxt{SEAS},'_ERA40.nc'],'pr');
RCM=ncread(['/home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_EOF/detrend_maskiran_subregion_',SEAStxt{SEAS},'_MOD_ENSAVG.nc'],'pr');

lon=ncread(['/home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_EOF/detrend_maskiran_subregion_',SEAStxt{SEAS},'_CRU.nc'],'lon');
lat=ncread(['/home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_EOF/detrend_maskiran_subregion_',SEAStxt{SEAS},'_CRU.nc'],'lat');
[LON,LAT]=meshgrid(lon,lat);

for x=1:160
    for y=1:91
        CRU(x,y,:)=CRU(x,y,:)*sqrt(cosd(LAT(y,x)));
        ERA(x,y,:)=ERA(x,y,:)*sqrt(cosd(LAT(y,x)));
        RCM(x,y,:)=RCM(x,y,:)*sqrt(cosd(LAT(y,x)));
    end
end

%%
CRUr=reshape(CRU(:)*1.000,160*91,TNT); CRUr=CRUr';
ERAr=reshape(ERA(:)*86400,160*91,TNT); ERAr=ERAr';
RCMr=reshape(RCM(:)*86400,160*91,TNT); RCMr=RCMr';

P=160*91;
N=TNT;
%%
r=0;
for p=1:P;
    if (isfinite(RCMr(1,p)));
        r=r+1;
        CRUrr(1:TNT,r)=CRUr(1:TNT,p);
        ERArr(1:TNT,r)=ERAr(1:TNT,p);
        RCMrr(1:TNT,r)=RCMr(1:TNT,p);
    end
end
%%

[LCRU, EOFsCRU, PCCRU, error, norms] = EOF( CRUrr, TNT);
[LERA, EOFsERA, PCERA, error, norms] = EOF( ERArr, TNT);
[LRCM, EOFsRCM, PCRCM, error, norms] = EOF( RCMrr, TNT);

%%

% set sign
for k=1:5
    if (sign(PCCRU(1,k))*sign(PCERA(1,k))==1)
        signERA(k)=1;
    else
        signERA(k)=-1;
    end
    if (sign(PCCRU(1,k))*sign(PCRCM(1,k))==1)
        signRCM(k)=1;
    else
        signRCM(k)=-1;
    end
end

%%

CRU_EOFs_grid=nan(5,14560);
CRU_EOFs_finl=nan(5,160,91);

ERA_EOFs_grid=nan(5,14560);
ERA_EOFs_finl=nan(5,160,91);

RCM_EOFs_grid=nan(5,14560);
RCM_EOFs_finl=nan(5,160,91);

for k=1:5;
r=0;
for p=1:P;

    if (isfinite(RCMr(1,p)));
        r=r+1;
        CRU_EOFs_grid(k,p)=EOFsCRU(r,k);
        RCM_EOFs_grid(k,p)=EOFsRCM(r,k);
        ERA_EOFs_grid(k,p)=EOFsERA(r,k);
    end

end
    CRU_EOFs_final(:,:,k)=reshape(CRU_EOFs_grid(k,:),160,91)*sqrt(LCRU(k));   %VAR(PC)=1
    RCM_EOFs_final(:,:,k)=reshape(RCM_EOFs_grid(k,:),160,91)*sqrt(LRCM(k));
    ERA_EOFs_final(:,:,k)=reshape(ERA_EOFs_grid(k,:),160,91)*sqrt(LERA(k));
end

%% Save output

filename=['EOF_',SEAStxt{SEAS},'.nc'];

nccreate(filename,'time', 'Format','classic','Dimensions', {'time',  5}); %Ovo je zapravo EOF mod no za potrebe GrADS-a stavljam vrijeme
nccreate(filename,'lon', 'Format','classic','Dimensions',  {'lon', 160});
nccreate(filename,'lat', 'Format','classic','Dimensions',  {'lat',  91});

nccreate(filename,'CRU_EOF', 'Format','classic','Dimensions', {'lon', 160 , 'lat', 91,'time', 5});
nccreate(filename,'RCM_EOF', 'Format','classic','Dimensions', {'lon', 160 , 'lat', 91,'time', 5});
nccreate(filename,'ERA_EOF', 'Format','classic','Dimensions', {'lon', 160 , 'lat', 91,'time', 5});

tito=[1:1:5]';
 ncwrite(filename,'lon',  double(lon),      [1]);
 ncwrite(filename,'lat',  double(lat),      [1]);
 ncwrite(filename,'time', double(tito),     [1]);

 ncwrite(filename,'CRU_EOF', CRU_EOFs_final, [1 1 1]);
 ncwrite(filename,'RCM_EOF', RCM_EOFs_final, [1 1 1]);
 ncwrite(filename,'ERA_EOF', ERA_EOFs_final, [1 1 1]);

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
    
 ncwriteatt(filename,'CRU_EOF','standard_name','CRU EOFs');
 ncwriteatt(filename,'CRU_EOF','long_name',    'CRU EOFs');
 ncwriteatt(filename,'CRU_EOF','coordinates',  'lon lat');
    ncwriteatt(filename,'RCM_EOF','standard_name','RCM EOFs');
    ncwriteatt(filename,'RCM_EOF','long_name',    'RCM EOFs');
    ncwriteatt(filename,'RCM_EOF','coordinates',  'lon lat');
        ncwriteatt(filename,'ERA_EOF','standard_name','ERA EOFs');
        ncwriteatt(filename,'ERA_EOF','long_name',    'ERA EOFs');
        ncwriteatt(filename,'ERA_EOF','coordinates',  'lon lat');
 
%% Plot



%--- fig1=figure(1); set(gcf,'Position',[71 292 1361 264],'Visible','on')
%---    for k=1:5
%---        subplot(1,5,k)
%---            plot(           PCCRU(:,k)./sqrt(LCRU(k)),'b'); hold on
%---            plot(signERA(k)*PCERA(:,k)./sqrt(LERA(k)),'r'); hold on
%---            plot(signRCM(k)*PCRCM(:,k)./sqrt(LRCM(k)),'k'); hold on
%---
%---                %legend(['mean=',num2str(round(mean(PCCRU(:,k)./sqrt(LCRU(k)))*10)/10),' / var=',num2str(round(var(PCCRU(:,k)./sqrt(LCRU(k)))*100)/100)], ... 
%---                %       ['mean=',num2str(round(mean(PCERA(:,k)./sqrt(LERA(k)))*10)/10),' / var=',num2str(round(var(PCERA(:,k)./sqrt(LERA(k)))*100)/100)], ...
%---                %       ['mean=',num2str(round(mean(PCRCM(:,k)./sqrt(LRCM(k)))*10)/10),' / var=',num2str(round(var(PCRCM(:,k)./sqrt(LRCM(k)))*100)/100)]);
%---
%---    end
%---
%---    filename=['PC_',SEAStxt{SEAS},'.jpg'];
%---    print(fig1,filename,'-djpeg');

%--------------------------------------------------------------------------

% ---- load coast;
% ---- 
% ---- a=[ 103,0,31     ;
% ----    178,24,43     ;
% ----    214,96,77     ;
% ----    244,165,130   ;
% ----    253,219,199   ;
% ----    247,247,247   ;
% ----    209,229,240   ;
% ----    146,197,222   ;
% ----     67,147,195   ;
% ----     33,102,172   ;
% ----      5,48,97]/255;
% ---- a=flipud(a);
% ---- 
% ---- www=[-2.75 -2.25 -1.75 -1.25 -0.75 -0.25 0.25 0.75 1.25 1.75 2.25 2.75];
% ---- 
% ---- fig2=figure(2); set(gcf,'Position',[66 1 1375 821],'Visible','on')
% ---- colormap(a)
% ----     for k=1:5
% ----        subplot(3,5,k)
% ----             contourf(LON,LAT,squeeze(CRU_EOFs_final(:,:,k))',www); hold on;             plot(long,lat,'k')
% ----             caxis([-2.75 2.75]); grid on; xlabel('lon (°E)'); ylabel('lat (°N)') 
% ----                 title([SEAStxt{SEAS},' pr CRU EOF ',num2str(k), ' / expl:',num2str(round((LCRU(k)/sum(LCRU)*100)*100)/100),'%'])
% ----        subplot(3,5,k+5)
% ----             contourf(LON,LAT,signERA(k)*squeeze(ERA_EOFs_final(:,:,k))',www); hold on;  plot(long,lat,'k')
% ----             caxis([-2.75 2.75]); grid on; xlabel('lon (°E)'); ylabel('lat (°N)') 
% ----                 title([SEAStxt{SEAS},' pr ERA40 EOF ',num2str(k) ,' / expl:',num2str(round((LERA(k)/sum(LERA)*100)*100)/100),'%'])
% ----        subplot(3,5,k+10)
% ----             contourf(LON,LAT,signRCM(k)*squeeze(RCM_EOFs_final(:,:,k))',www); hold on;  plot(long,lat,'k')
% ----             caxis([-2.75 2.75]); grid on; xlabel('lon (°E)'); ylabel('lat (°N)') 
% ----                 title([SEAStxt{SEAS},' pr RCM EOF ',num2str(k) , ' / expl:',num2str(round((LRCM(k)/sum(LRCM)*100)*100)/100),'%'])
% ----             if (k==5); ccc=colorbar; set(ccc,'Position', [0.94 0.11 0.01 0.82]); end
% ----     end
% ---- 
% ----     filename=['EOF_',SEAStxt{SEAS},'.jpg'];
% ----     print(fig2,filename,'-djpeg');

close all
AAA=round((LCRU(1:5)/sum(LCRU)*100)*100)/100;
BBB=round((LERA(1:5)/sum(LERA)*100)*100)/100;
CCC=round((LRCM(1:5)/sum(LRCM)*100)*100)/100;
DDD=[AAA; BBB; CCC]

clear CRU* RCM* ERA* R* e* E* P* L* n*

end %SEAS
