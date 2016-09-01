close all; clear all; clc

pkg load netcdf
pkg load io
pkg load statistics

SEAS{ 1}=['DJF']; SEAS{ 2}=['JFM']; SEAS{ 3}=['FMA']; SEAS{ 4}=['MAM'];
SEAS{ 5}=['AMJ']; SEAS{ 6}=['MJJ']; SEAS{ 7}=['JJA']; SEAS{ 8}=['JAS'];
SEAS{ 9}=['ASO']; SEAS{10}=['SON']; SEAS{11}=['OND']; SEAS{12}=['NDJ'];

%--verzija do 2016-03-16
RANGE_AREA1_lat=[20 49];  % 35.25  49.75
RANGE_AREA2_lat=[50 93];  % 50.25  71.75
      RANGE_lon=[13 132]; %-24.75  34.75


for SEASx=[1 4 7 10];
                    years=[1961:1:2000];
    if (SEASx==1);  years=[1962:1:2000]; end
    if (SEASx==2);  years=[1962:1:2000]; end
    if (SEASx==12); years=[1961:1:1999]; end


    disp(['------------------>',SEAS{SEASx}])
%%

DIR_CRU='/home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_CRU/';
FILE_CRU=[DIR_CRU,'pr_CRU_SM_',SEAS{SEASx},'_SMS_2014_interp.nc'];

    temp=ncread(FILE_CRU,'pre');
    if (SEASx==2)
    pr_CRU(:,:,:)=double(temp(:,:,2:end));
    else
    pr_CRU(:,:,:)=double(temp); % LON x LAT x YEARS
    end
    clear temp

    lonCRU=ncread(FILE_CRU,'lon'); latCRU=ncread(FILE_CRU,'lat');
    [LATCRU,LONCRU]=meshgrid(latCRU,lonCRU);

%%

DIR_RCM='/home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2016_prc/FILES_RCM/';

for MOD=[1:15];
    FILE_RCM=[DIR_RCM,'prc_MOD_',num2str(MOD),'_SM_',SEAS{SEASx},'_SMS_2016_interp.nc'];
    temp=ncread(FILE_RCM,'prc');
    pr_RCM(:,:,:,MOD)=double(temp); % LON x LAT x YEARS x MOD
    clear temp
end
    pr_RCM_ENS(:,:,:)=nanmean(pr_RCM(:,:,:,:),4);
%%

T=size(pr_CRU,3);

mask_A1=isfinite(pr_CRU(RANGE_lon(1):RANGE_lon(2),RANGE_AREA1_lat(1):RANGE_AREA1_lat(2),1)).*isfinite(nanmean(pr_RCM(RANGE_lon(1):RANGE_lon(2),RANGE_AREA1_lat(1):RANGE_AREA1_lat(2),1,:),4));
mask_A2=isfinite(pr_CRU(RANGE_lon(1):RANGE_lon(2),RANGE_AREA2_lat(1):RANGE_AREA2_lat(2),1)).*isfinite(nanmean(pr_RCM(RANGE_lon(1):RANGE_lon(2),RANGE_AREA2_lat(1):RANGE_AREA2_lat(2),1,:),4));

for t=1:T
   RCM_ENS_A1_mean(t)=squeeze(nanmean(nanmean(pr_RCM_ENS(RANGE_lon(1):RANGE_lon(2),RANGE_AREA1_lat(1):RANGE_AREA1_lat(2),t).*mask_A1,1),2));
   RCM_ENS_A2_mean(t)=squeeze(nanmean(nanmean(pr_RCM_ENS(RANGE_lon(1):RANGE_lon(2),RANGE_AREA2_lat(1):RANGE_AREA2_lat(2),t).*mask_A2,1),2));
   for m=1:15
          RCM_A1_mean(t,m)=squeeze(nanmean(nanmean(pr_RCM(RANGE_lon(1):RANGE_lon(2),RANGE_AREA1_lat(1):RANGE_AREA1_lat(2),t,m).*mask_A1,1),2));
          RCM_A2_mean(t,m)=squeeze(nanmean(nanmean(pr_RCM(RANGE_lon(1):RANGE_lon(2),RANGE_AREA2_lat(1):RANGE_AREA2_lat(2),t,m).*mask_A2,1),2));
   end
end
   mean_RCM_ENS_A1_mean=mean(RCM_ENS_A1_mean);
   mean_RCM_ENS_A2_mean=mean(RCM_ENS_A2_mean);
   std_RCM_ENS_A1_mean=std(RCM_ENS_A1_mean);
   std_RCM_ENS_A2_mean=std(RCM_ENS_A2_mean);   
   for m=1:15
       mean_RCM_A1_mean(m)=mean(RCM_A1_mean(:,m));
       mean_RCM_A2_mean(m)=mean(RCM_A2_mean(:,m));
       std_RCM_A1_mean(m)=std(RCM_A1_mean(:,m));
       std_RCM_A2_mean(m)=std(RCM_A2_mean(:,m));
   end

   stand_RCM_ENS_A1=(RCM_ENS_A1_mean-mean_RCM_ENS_A1_mean)/std_RCM_ENS_A1_mean;
   stand_RCM_ENS_A2=(RCM_ENS_A2_mean-mean_RCM_ENS_A2_mean)/std_RCM_ENS_A2_mean;
   for m=1:15
      stand_RCM_A1(:,m)=(RCM_A1_mean(:,m)-mean_RCM_A1_mean(m))/std_RCM_A1_mean(m);
      stand_RCM_A2(:,m)=(RCM_A2_mean(:,m)-mean_RCM_A2_mean(m))/std_RCM_A2_mean(m);
   end
%%
%--Racunam rasap iz svih godina
   for t=1:T
       rasap_stand_RCM_A1(t)=sqrt(mean((       stand_RCM_A1(t,:)-stand_RCM_ENS_A1(t)    ).^2,2)./15);
       rasap_stand_RCM_A2(t)=sqrt(mean((       stand_RCM_A2(t,:)-stand_RCM_ENS_A2(t)    ).^2,2)./15);
   end
%%

futa=14;
%------------------------------------------------------------------------------------Crtanje standardizirane oborine
   fig1=figure(1); set(gcf,'Position',[56 0 1395 869]);
        y1=min(stand_RCM_A1,[],2)'; 
        y2=max(stand_RCM_A1,[],2)'; 
        x1=years;
        x2=years;
	X = [x1 fliplr(x2) x1(1)];
	Y = [y1 fliplr(y2) y1(1)];
	a=fill(X,Y,"c"); set(a,'FaceColor',[250, 192, 144]./256,'EdgeColor',[250, 192, 144]./256); hold on

        h4=plot(years,stand_RCM_ENS_A1,'Linewidth',3,'b');  hold on

	%---> legenda
        	aaa=1962; bbb=1965;
	        plot([aaa bbb],[-3.5 -3.5],'Color',[250, 192, 144]./256,'linewidth',10); t=text(bbb+0.5,-3.5,'RCM min/max'); set(t,'Fontsize',futa);
	        plot([aaa bbb],[-3.0 -3.0],'b','linewidth', 3); t=text(bbb+0.5,-3.0,'RCM ENS')    ; set(t,'Fontsize',futa);
        %<--- legenda

        title(['standardized convective precipitation over S. Europe; ',SEAS{SEASx}],'Fontsize',futa)
            xlabel('time (years)','Fontsize',futa); ylabel('stand. precip. (-)','Fontsize',futa);
	    set(gca,'Xtick',[1960:5:2000],'YTick',[-4:1:4]);
            grid on

            xlim([1961 2000]); ylim([-4 4])
            filename=['STAN_AREA1_',SEAS{SEASx},'_prc.jpg'];
            print(fig1,filename,'-djpg');          clf 
%        
   fig2=figure(2); set(gcf,'Position',[56 0 1395 869]);
        y1=min(stand_RCM_A2,[],2)'; 
        y2=max(stand_RCM_A2,[],2)'; 
        x1=years;
        x2=years;
	X = [x1 fliplr(x2) x1(1)];
	Y = [y1 fliplr(y2) y1(1)];
	a=fill(X,Y,"c"); set(a,'FaceColor',[250, 192, 144]./256,'EdgeColor',[250, 192, 144]./256); hold on

        h4=plot(years,stand_RCM_ENS_A2,'Linewidth',3,'b');  hold on
        title(['standardized convective precipitation over N. Europe; ',SEAS{SEASx}],'Fontsize',futa)
	%---> legenda
        	aaa=1962; bbb=1965;
	        plot([aaa bbb],[-3.5 -3.5],'Color',[250, 192, 144]./256,'linewidth',10); t=text(bbb+0.5,-3.5,'RCM min/max'); set(t,'Fontsize',futa);
	        plot([aaa bbb],[-3.0 -3.0],'b','linewidth', 3); t=text(bbb+0.5,-3.0,'RCM ENS')    ; set(t,'Fontsize',futa);
        %<--- legenda

            xlabel('time (years)','Fontsize',futa); ylabel('stand. precip. (-)','Fontsize',futa)
	    set(gca,'Xtick',[1960:5:2000],'YTick',[-4:1:4]);
            grid on

            xlim([1961 2000]); ylim([-4 4])
            filename=['STAN_AREA2_',SEAS{SEASx},'_prc.jpg'];
            print(fig2,filename,'-djpg');       clf
%------------------------------------------------------------------------------------Srednjak rasapa
%--2016-01-21
sss=mean(rasap_stand_RCM_A1); filenam=['mean_rasap_',SEAS{SEASx},'_A1_prc.txt']; fileID = fopen(filenam,'w'); fprintf(fileID,'%6.4f',sss); fclose(fileID);
sss=mean(rasap_stand_RCM_A2); filenam=['mean_rasap_',SEAS{SEASx},'_A2_prc.txt']; fileID = fopen(filenam,'w'); fprintf(fileID,'%6.4f',sss); fclose(fileID);
%--

           clear pr_CRU pr_RCM std_* mean_* stand_* CRU_* RCM_* pr_RCM_ENS rasap*
           close all

end %SEASx
