close all; clear all; clc

load coast
xxx=[-23.875:0.25:(-23.875+277*0.25)];
yyy=[ 29.125:0.25:( 29.125+169*0.25)];
[XXX,YYY]=meshgrid(xxx,yyy);

DIR=['/home/ivan/MODELS/ENSEMBLES/DATA/orog/'];
FILE{ 1}=[DIR,'C4IRCA3_CTL_ERA40_FIX_25km_orog.nc'];
FILE{ 2}=[DIR,'CHMIALADIN_CY28_ERA40_FIX_25km_orog.nc'];
FILE{ 3}=[DIR,'CNRM-RM4.5_CTL_ERA40_FIX_25km_orog.nc'];
FILE{ 4}=[DIR,'DMI-HIRHAM5_CTL_ERA40_FIX_25km_orog.nc'];
FILE{ 5}=[DIR,'ETHZ-CLM_CTL_ERA40_FIX_25km_orog.nc'];
FILE{ 6}=[DIR,'ICTP-REGCM3_CTL_ERA40_FIX_25km_orog.nc'];
FILE{ 7}=[DIR,'KNMI-RACMO2_CTL_ERA40_FIX_25km_orog.nc'];
FILE{ 8}=[DIR,'METNOHIRHAM_CTR_ERA40_FIX_25km_orog.nc'];
FILE{ 9}=[DIR,'METO-HC_HadRM3Q0_CTL_ERA40_FIX_25km_orog.nc'];
FILE{10}=[DIR,'METO-HC_HadRM3Q16_CTL_ERA40_FIX_25km_orog.nc'];
FILE{11}=[DIR,'METO-HC_HadRM3Q3_CTL_ERA40_FIX_25km_orog.nc'];
FILE{12}=[DIR,'MPI-M-REMO_CTL_ERA40_FIX_25km_orog.nc'];
FILE{13}=[DIR,'OURANOSMRCC4.2.1_CTL_ERA40_FIX_25km-CRU_orog.nc'];
FILE{14}=[DIR,'SMHIRCA_A1B_ERA40_FIX_25km_orog.nc'];
FILE{15}=[DIR,'UCLM-PROMES_CTL_ERA40_FIX_25km_orog.nc'];

DIR_CRU=['/home/ivan/MODELS/ENSEMBLES/DATA_CRU/orog_CRU/'];
FILE_CRU{ 1}=[DIR_CRU,'C4IRCA3_CTL_ERA40_FIX_25km_orog_CRU.nc'];
FILE_CRU{ 2}=[DIR_CRU,'CHMIALADIN_CY28_ERA40_FIX_25km_orog_CRU.nc'];
FILE_CRU{ 3}=[DIR_CRU,'CNRM-RM4.5_CTL_ERA40_FIX_25km_orog_CRU.nc'];
FILE_CRU{ 4}=[DIR_CRU,'DMI-HIRHAM5_CTL_ERA40_FIX_25km_orog_CRU.nc'];
FILE_CRU{ 5}=[DIR_CRU,'ETHZ-CLM_CTL_ERA40_FIX_25km_orog_CRU.nc'];
FILE_CRU{ 6}=[DIR_CRU,'ICTP-REGCM3_CTL_ERA40_FIX_25km_orog_CRU.nc'];
FILE_CRU{ 7}=[DIR_CRU,'KNMI-RACMO2_CTL_ERA40_FIX_25km_orog_CRU.nc'];
FILE_CRU{ 8}=[DIR_CRU,'METNOHIRHAM_CTR_ERA40_FIX_25km_orog_CRU.nc'];
FILE_CRU{ 9}=[DIR_CRU,'METO-HC_HadRM3Q0_CTL_ERA40_FIX_25km_orog_CRU.nc'];
FILE_CRU{10}=[DIR_CRU,'METO-HC_HadRM3Q16_CTL_ERA40_FIX_25km_orog_CRU.nc'];
FILE_CRU{11}=[DIR_CRU,'METO-HC_HadRM3Q3_CTL_ERA40_FIX_25km_orog_CRU.nc'];
FILE_CRU{12}=[DIR_CRU,'MPI-M-REMO_CTL_ERA40_FIX_25km_orog_CRU.nc'];
FILE_CRU{13}=[DIR_CRU,'OURANOSMRCC4.2.1_CTL_ERA40_FIX_25km-CRU_orog_CRU.nc'];
FILE_CRU{14}=[DIR_CRU,'SMHIRCA_A1B_ERA40_FIX_25km_orog_CRU.nc'];
FILE_CRU{15}=[DIR_CRU,'UCLM-PROMES_CTL_ERA40_FIX_25km_orog_CRU.nc'];

    MOD{ 1}=['C4I-RCA3'];
    MOD{ 2}=['CHMI-ALADIN CY28'];
    MOD{ 3}=['CNRM-RM4.5'];
    MOD{ 4}=['DMI-HIRHAM5'];
    MOD{ 5}=['ETHZ-CLM'];
    MOD{ 6}=['ICTP-REGCM3'];
    MOD{ 7}=['KNMI-RACMO2'];
    MOD{ 8}=['METNO-HIRHAM'];
    MOD{ 9}=['METO-HC HadRM3Q0'];
    MOD{10}=['METO-HC HadRM3Q16'];
    MOD{11}=['METO-HC HadRM3Q3'];
    MOD{12}=['MPI-M-REMO'];
    MOD{13}=['OURANOS-MRCC4.2.1'];
    MOD{14}=['SMHI-RCA'];
    MOD{15}=['UCLM-PROMES'];

    for i=1:15;
        paket=ncread(FILE{i}    ,'orog'); ind=find(paket>10^5); paket(ind)=NaN;
        if (i==2); paket=paket/10; end
        orog{:,:,i}=double(paket');     
   
        paket=ncread(FILE_CRU{i},'orog'); ind=find(paket>10^5); paket(ind)=NaN;
        if (i==2); paket=paket/10; end
        orog_CRU(:,:,i)=double(paket');
    end

%%

orog_CRU_mean(1:170,1:278,1)=mean(orog_CRU,3);
orog_CRU_spread(1:170,1:278,1)=0;
for i=1:15   
    orog_CRU_spread(:,:,1)=     orog_CRU_spread(:,:,1)+(orog_CRU(:,:,i)-orog_CRU_mean(:,:,1)).^2;
end
    orog_CRU_spread(:,:,1)=sqrt(orog_CRU_spread(:,:,1)/15);
%%

% % % figure(1); set(gcf,'Position',[255 56 1129 676]);
% % % for i=1:15
% % %    subplot(3,5,i)
% % %         pcolorjw(orog{:,:,i})
% % %             caxis([0 3000]); if (i==15); cb=colorbar; set(cb,'Position',[0.93 0.11 0.01 0.83]); end
% % %             title(MOD{i})
% % % end
% % % figure(2); set(gcf,'Position',[255 56 1129 676]);
% % % for i=1:15
% % %    subplot(3,5,i)
% % %         pcolorjw(XXX,YYY,orog_CRU(:,:,i))
% % %             caxis([0 3000]); if (i==15); cb=colorbar; set(cb,'Position',[0.93 0.11 0.01 0.83]); end
% % %             title(MOD{i})
% % % end
%%
fig3=figure(3);
    subplot(1,2,1); set(gcf,'Position',[150 331 1202 420])
        pcolorjw(XXX,YYY,orog_CRU_mean); 
            caxis([0 3000]); cb=colorbar; set(cb,'Position',[0.49 0.11 0.01 0.83]); hold on
            plot(long,lat,'w')
            title('ENSEMBLES mean orography (m)')
            xlabel('lon (deg)'); ylabel('lat (deg)')
    subplot(1,2,2)
        pcolorjw(XXX,YYY,orog_CRU_spread); 
            caxis([0 200]); cb=colorbar; set(cb,'Position', [0.93 0.11 0.01 0.83]); hold on
            plot(long,lat,'w')
            title('ENSEMBLES orography spread (m)')
            xlabel('lon (deg)'); ylabel('lat (deg)')
% %     print(fig3,'ENSEMBLES_orography.jpg','-djpeg')
% %     print(fig3,'ENSEMBLES_orography.eps','-depsc2')



filename=['ENSEMBLES_orography.nc'];

nccreate(filename,'lon', 'Format','classic','Dimensions',  {'lon', 278});
nccreate(filename,'lat', 'Format','classic','Dimensions',  {'lat', 170});
nccreate(filename,'time', 'Format','classic','Dimensions', {'time', 1});
nccreate(filename,'MeanOrography',   'Format','classic','Dimensions', {'lon', 278, 'lat', 170 , 'time', 1});
nccreate(filename,'SpreadOrography', 'Format','classic','Dimensions', {'lon', 278, 'lat', 170 , 'time', 1});

 ncwrite(filename,'lon', xxx', [1]);
 ncwrite(filename,'lat', yyy', [1]);
 ncwrite(filename,'time', 1 ,  [1]);
 ncwrite(filename,'MeanOrography',   orog_CRU_mean', [1 1 1]);
 ncwrite(filename,'SpreadOrography', orog_CRU_spread', [1 1 1]);

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
 ncwriteatt(filename,'MeanOrography','standard_name','mean orography');
 ncwriteatt(filename,'MeanOrography','long_name','mean orography');
 ncwriteatt(filename,'MeanOrography','coordinates','lon lat');
 ncwriteatt(filename,'SpreadOrography','standard_name','mean orography');
 ncwriteatt(filename,'SpreadOrography','long_name','mean orography');
 ncwriteatt(filename,'SpreadOrography','coordinates','lon lat');
