close all; clear all; clc

pkg load netcdf
pkg load io
pkg load statistics

SEAS{ 1}=['DJF']; SEAS{ 2}=['JFM']; SEAS{ 3}=['FMA']; SEAS{ 4}=['MAM'];
SEAS{ 5}=['AMJ']; SEAS{ 6}=['MJJ']; SEAS{ 7}=['JJA']; SEAS{ 8}=['JAS'];
SEAS{ 9}=['ASO']; SEAS{10}=['SON']; SEAS{11}=['OND']; SEAS{12}=['NDJ'];


%--verzija do 2016-03-16
%RANGE_AREA1_lat=[10 49]; %Check e.g. pcolorjw(pr_RCM(:,RANGE_AREA1_lat(1):RANGE_AREA1_lat(2),1,1)')
%RANGE_AREA2_lat=[50 89]; 
%--verzija do 2016-03-16
RANGE_AREA1_lat=[20 49];  % 35.25  49.75
RANGE_AREA2_lat=[50 93];  % 50.25  71.75
      RANGE_lon=[13 132]; %-24.75  34.75


%for SEASx=[1 :   12];
for SEASx=[1 4 7 10];
% for SEASx=2;
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

DIR_ERA40='/home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_ERA/';
FILE_ERA40=[DIR_ERA40,'pr_ERA40_SM_',SEAS{SEASx},'_SMS_2014_interp.nc'];

    temp=ncread(FILE_ERA40,'pr');
    if (SEASx==2)
    pr_ERA(:,:,:)=double(temp(:,:,2:end)*86400);
    else
    pr_ERA(:,:,:)=double(temp*86400); % LON x LAT x YEARS
    end
    clear temp

%%

DIR_RCM='/home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_RCM/';

for MOD=[1:15];
    FILE_RCM=[DIR_RCM,'pr_MOD_',num2str(MOD),'_SM_',SEAS{SEASx},'_SMS_2014_interp.nc'];
    temp=ncread(FILE_RCM,'pr');
    pr_RCM(:,:,:,MOD)=double(temp); % LON x LAT x YEARS x MOD
    clear temp
end
    pr_RCM_ENS(:,:,:)=nanmean(pr_RCM(:,:,:,:),4);
%%

T=size(pr_CRU,3);

mask_A1=isfinite(pr_CRU(RANGE_lon(1):RANGE_lon(2),RANGE_AREA1_lat(1):RANGE_AREA1_lat(2),1)).*isfinite(nanmean(pr_RCM(RANGE_lon(1):RANGE_lon(2),RANGE_AREA1_lat(1):RANGE_AREA1_lat(2),1,:),4));
mask_A2=isfinite(pr_CRU(RANGE_lon(1):RANGE_lon(2),RANGE_AREA2_lat(1):RANGE_AREA2_lat(2),1)).*isfinite(nanmean(pr_RCM(RANGE_lon(1):RANGE_lon(2),RANGE_AREA2_lat(1):RANGE_AREA2_lat(2),1,:),4));

for t=1:T
   CRU_A1_mean(t)=squeeze(nanmean(nanmean(pr_CRU(RANGE_lon(1):RANGE_lon(2),RANGE_AREA1_lat(1):RANGE_AREA1_lat(2),t).*mask_A1,1),2));
   CRU_A2_mean(t)=squeeze(nanmean(nanmean(pr_CRU(RANGE_lon(1):RANGE_lon(2),RANGE_AREA2_lat(1):RANGE_AREA2_lat(2),t).*mask_A2,1),2));
   ERA_A1_mean(t)=squeeze(nanmean(nanmean(pr_ERA(RANGE_lon(1):RANGE_lon(2),RANGE_AREA1_lat(1):RANGE_AREA1_lat(2),t).*mask_A1,1),2));
   ERA_A2_mean(t)=squeeze(nanmean(nanmean(pr_ERA(RANGE_lon(1):RANGE_lon(2),RANGE_AREA2_lat(1):RANGE_AREA2_lat(2),t).*mask_A2,1),2));
   RCM_ENS_A1_mean(t)=squeeze(nanmean(nanmean(pr_RCM_ENS(RANGE_lon(1):RANGE_lon(2),RANGE_AREA1_lat(1):RANGE_AREA1_lat(2),t).*mask_A1,1),2));
   RCM_ENS_A2_mean(t)=squeeze(nanmean(nanmean(pr_RCM_ENS(RANGE_lon(1):RANGE_lon(2),RANGE_AREA2_lat(1):RANGE_AREA2_lat(2),t).*mask_A2,1),2));
   for m=1:15
          RCM_A1_mean(t,m)=squeeze(nanmean(nanmean(pr_RCM(RANGE_lon(1):RANGE_lon(2),RANGE_AREA1_lat(1):RANGE_AREA1_lat(2),t,m).*mask_A1,1),2));
          RCM_A2_mean(t,m)=squeeze(nanmean(nanmean(pr_RCM(RANGE_lon(1):RANGE_lon(2),RANGE_AREA2_lat(1):RANGE_AREA2_lat(2),t,m).*mask_A2,1),2));
   end
end
   mean_CRU_A1_mean=mean(CRU_A1_mean);
   mean_CRU_A2_mean=mean(CRU_A2_mean);
   std_CRU_A1_mean=std(CRU_A1_mean);
   std_CRU_A2_mean=std(CRU_A2_mean);
        mean_ERA_A1_mean=mean(ERA_A1_mean);
        mean_ERA_A2_mean=mean(ERA_A2_mean);
        std_ERA_A1_mean=std(ERA_A1_mean);
        std_ERA_A2_mean=std(ERA_A2_mean);
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

   stand_CRU_A1=(CRU_A1_mean-mean_CRU_A1_mean)/std_CRU_A1_mean;
   stand_CRU_A2=(CRU_A2_mean-mean_CRU_A2_mean)/std_CRU_A2_mean;
        stand_ERA_A1=(ERA_A1_mean-mean_ERA_A1_mean)/std_ERA_A1_mean;
        stand_ERA_A2=(ERA_A2_mean-mean_ERA_A2_mean)/std_ERA_A2_mean;
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
%--Racunam rasap iz posebnih godina (samo za JFM)
if (SEASx==2);
%           1962 ( 1) 1963 ( 2) 1964 ( 3) 1965 ( 4) 1966 ( 5) 1967 ( 6) 1968 ( 7) 1969 ( 8) 1970 ( 9)
% 1971 (10) 1972 (11) 1973 (12) 1974 (13) 1975 (14) 1976 (15) 1977 (16) 1978 (17) 1979 (18) 1980 (19)
% 1981 (20) 1982 (21) 1983 (22) 1984 (23) 1985 (24) 1986 (25) 1987 (26) 1988 (27) 1989 (28) 1990 (29)
% 1991 (30) 1992 (31) 1993 (32) 1994 (33) 1995 (34) 1996 (35) 1997 (36) 1998 (37) 1999 (38) 2000 (39)
strong_p_NAO=[28 29 32 34];
strong_n_NAO=[ 2  5  8   ];
strong_p_ENS=[ 5 12 22 26 31 37];
strong_n_ENS=[10 13 15 28 38 39];
       mean_rasap_stand_RCM_A1_strong_p_NAO=mean(sqrt(mean((       stand_RCM_A1(strong_p_NAO,:)-stand_RCM_ENS_A1(strong_p_NAO)'       ).^2,2)./15));
       mean_rasap_stand_RCM_A2_strong_p_NAO=mean(sqrt(mean((       stand_RCM_A2(strong_p_NAO,:)-stand_RCM_ENS_A2(strong_p_NAO)'       ).^2,2)./15));
       mean_rasap_stand_RCM_A1_strong_n_NAO=mean(sqrt(mean((       stand_RCM_A1(strong_n_NAO,:)-stand_RCM_ENS_A1(strong_n_NAO)'       ).^2,2)./15));
       mean_rasap_stand_RCM_A2_strong_n_NAO=mean(sqrt(mean((       stand_RCM_A2(strong_n_NAO,:)-stand_RCM_ENS_A2(strong_n_NAO)'       ).^2,2)./15));
           mean_rasap_stand_RCM_A1_strong_p_ENS=mean(sqrt(mean((       stand_RCM_A1(strong_p_ENS,:)-stand_RCM_ENS_A1(strong_p_ENS)'       ).^2,2)./15));
           mean_rasap_stand_RCM_A2_strong_p_ENS=mean(sqrt(mean((       stand_RCM_A2(strong_p_ENS,:)-stand_RCM_ENS_A2(strong_p_ENS)'       ).^2,2)./15));
           mean_rasap_stand_RCM_A1_strong_n_ENS=mean(sqrt(mean((       stand_RCM_A1(strong_n_ENS,:)-stand_RCM_ENS_A1(strong_n_ENS)'       ).^2,2)./15));
           mean_rasap_stand_RCM_A2_strong_n_ENS=mean(sqrt(mean((       stand_RCM_A2(strong_n_ENS,:)-stand_RCM_ENS_A2(strong_n_ENS)'       ).^2,2)./15));
end
%%

futa=14;
%------------------------------------------------------------------------------------Crtanje standardizirane oborine
   fig1=figure(1); set(gcf,'Position',[56 0 1395 869]);
%2016-04-26 plot(years,zeros(1,T),  'Linewidth',2,'Color',[189,189,189]./255); hold on
%           for m=1:15
%2016-04-26 h1=plot(years,stand_RCM_A1(:,m),'Linewidth',1,'Color',[251,106,74]./255);  hold on
%           end
%2016-04-26        h4=plot(years,stand_RCM_ENS_A1,'Linewidth',3,'Color',[0,0,0]./255);  hold on
%2016-04-26        h2=plot(years,stand_CRU_A1,'Linewidth',3,'Color',[49,130,189]./255); hold on
%2016-04-26        h3=plot(years,stand_ERA_A1,'Linewidth',3,'Color',[65,171,93]./255);  hold on
        y1=min(stand_RCM_A1,[],2)'; 
        y2=max(stand_RCM_A1,[],2)'; 
        x1=years;
        x2=years;
	X = [x1 fliplr(x2) x1(1)];
	Y = [y1 fliplr(y2) y1(1)];
	a=fill(X,Y,"c"); set(a,'FaceColor',[250, 192, 144]./256,'EdgeColor',[250, 192, 144]./256); hold on

        h4=plot(years,stand_RCM_ENS_A1,'Linewidth',3,'b');  hold on
        h2=plot(years,stand_CRU_A1,    'Linewidth',3,'k');  hold on
        h3=plot(years,stand_ERA_A1,    'Linewidth',3,'r');  hold on

%v1     legend([h1 h4 h2 h3],{'RCM(i)','RCM ENS','CRU', 'ERA40'},'Fontsize',futa)
%v2     leg=legend('RCM min/max','RCM ENS','CRU', 'ERA40'); set(leg,'Fontsize',futa,'Location','southwest'); legend boxoff; set(leg,'Linewidth',3);
	%---> legenda
        	aaa=1962; bbb=1965;
	        plot([aaa bbb],[-3.5 -3.5],'Color',[250, 192, 144]./256,'linewidth',10); t=text(bbb+0.5,-3.5,'RCM min/max'); set(t,'Fontsize',futa);
	        plot([aaa bbb],[-3.0 -3.0],'b','linewidth', 3); t=text(bbb+0.5,-3.0,'RCM ENS')    ; set(t,'Fontsize',futa);
        	plot([aaa bbb],[-2.5 -2.5],'k','linewidth', 3); t=text(bbb+0.5,-2.5,'CRU')        ; set(t,'Fontsize',futa);
	        plot([aaa bbb],[-2.0 -2.0],'r','linewidth', 3); t=text(bbb+0.5,-2.0,'ERA40')      ; set(t,'Fontsize',futa);
        %<--- legenda

%       title(['standardized precipitation over AREA 1; ',SEAS{SEASx}],'Fontsize',futa)
        title(['standardized precipitation over S. Europe; ',SEAS{SEASx}],'Fontsize',futa)
            xlabel('time (years)','Fontsize',futa); ylabel('stand. precip. (-)','Fontsize',futa);
	    set(gca,'Xtick',[1960:5:2000],'YTick',[-4:1:4]);
            grid on

            xlim([1961 2000]); ylim([-4 4])
%           filename=['STAN_AREA1_',SEAS{SEASx},'.eps'];
%           print(fig1,filename,'-depsc2');
            filename=['STAN_AREA1_',SEAS{SEASx},'.jpg'];
            print(fig1,filename,'-djpg');          clf 
%        
   fig2=figure(2); set(gcf,'Position',[56 0 1395 869]);
%2016-04-26 plot(years,zeros(1,T),  'Linewidth',2,'Color',[189,189,189]./255); hold on
%                  for m=1:15 
%2016-04-26        h1=plot(years,stand_RCM_A2(:,m),'Linewidth',1,'Color',[251,106,74]./255);  hold on
%                  h1=plot(years,stand_RCM_A2(:,m),'Linewidth',1,'b');                        hold on
%                  end      
        y1=min(stand_RCM_A2,[],2)'; 
        y2=max(stand_RCM_A2,[],2)'; 
        x1=years;
        x2=years;
	X = [x1 fliplr(x2) x1(1)];
	Y = [y1 fliplr(y2) y1(1)];
	a=fill(X,Y,"c"); set(a,'FaceColor',[250, 192, 144]./256,'EdgeColor',[250, 192, 144]./256); hold on

%2016-04-26        h4=plot(years,stand_RCM_ENS_A2,'Linewidth',3,'Color',[0,0,0]./255);  hold on
%2016-04-26        h2=plot(years,stand_CRU_A2,'Linewidth',3,'Color',[49,130,189]./255); hold on  
%2016-04-26        h3=plot(years,stand_ERA_A2,'Linewidth',3,'Color',[65,171,93]./255);  hold on        
		   h4=plot(years,stand_RCM_ENS_A2,'Linewidth',3,'b');  hold on
		   h2=plot(years,stand_CRU_A2,    'Linewidth',3,'k');  hold on  
		   h3=plot(years,stand_ERA_A2,    'Linewidth',3,'r');  hold on        
%        title(['standardized precipitation over AREA 2; ',SEAS{SEASx}],'Fontsize',futa)
        title(['standardized precipitation over N. Europe; ',SEAS{SEASx}],'Fontsize',futa)
%v1     legend([h1 h4 h2 h3],{'RCM(i)','RCM ENS','CRU', 'ERA40'},'Fontsize',futa)
%v2     leg=legend('RCM min/max','RCM ENS','CRU', 'ERA40'); set(leg,'Fontsize',futa,'Location','southwest'); legend boxoff; set(leg,'Linewidth',3);
	%---> legenda
        	aaa=1962; bbb=1965;
	        plot([aaa bbb],[-3.5 -3.5],'Color',[250, 192, 144]./256,'linewidth',10); t=text(bbb+0.5,-3.5,'RCM min/max'); set(t,'Fontsize',futa);
	        plot([aaa bbb],[-3.0 -3.0],'b','linewidth', 3); t=text(bbb+0.5,-3.0,'RCM ENS')    ; set(t,'Fontsize',futa);
        	plot([aaa bbb],[-2.5 -2.5],'k','linewidth', 3); t=text(bbb+0.5,-2.5,'CRU')        ; set(t,'Fontsize',futa);
	        plot([aaa bbb],[-2.0 -2.0],'r','linewidth', 3); t=text(bbb+0.5,-2.0,'ERA40')      ; set(t,'Fontsize',futa);
        %<--- legenda

            xlabel('time (years)','Fontsize',futa); ylabel('stand. precip. (-)','Fontsize',futa)
	    set(gca,'Xtick',[1960:5:2000],'YTick',[-4:1:4]);
            grid on

            xlim([1961 2000]); ylim([-4 4])
%            filename=['STAN_AREA2_',SEAS{SEASx},'.eps'];
%            print(fig2,filename,'-depsc2');
            filename=['STAN_AREA2_',SEAS{SEASx},'.jpg'];
            print(fig2,filename,'-djpg');       clf
%------------------------------------------------------------------------------------Crtanje spreada
%   fig3=figure(3); set(fig3,'Position',[56 0 1395 869]);
%        plot(years,zeros(1,T),  'Linewidth',2,'Color',[189,189,189]./255); hold on
%        plot(years,rasap_stand_RCM_A1,'Linewidth',3,'Color',[0,0,0]./255);  hold on
%       title(['spread of the RCMs standardized precipitation over AREA 1; ',SEAS{SEASx}],'Fontsize',futa)
%            xlabel('time (years)','Fontsize',futa); ylabel('stand. precip. (-)','Fontsize',futa)
%            grid on
%
%            xlim([1961 2000]); ylim([0 0.3])
%            filename=['RASAP_STAN_AREA1_',SEAS{SEASx},'.jpg'];
%            print(fig3,filename,'-djpg');  clf
%%
%   fig3=figure(4); set(fig3,'Position',[56 0 1395 869]);
%        plot(years,zeros(1,T),  'Linewidth',2,'Color',[189,189,189]./255); hold on
%        plot(years,rasap_stand_RCM_A2,'Linewidth',3,'Color',[0,0,0]./255);  hold on
%       title(['spread of the RCMs standardized precipitation over AREA 2; ',SEAS{SEASx}],'Fontsize',futa)
%            xlabel('time (years)','Fontsize',futa); ylabel('stand. precip. (-)','Fontsize',futa)
%            grid on
%
%            xlim([1961 2000]); ylim([0 0.3])
%            filename=['RASAP_STAN_AREA2_',SEAS{SEASx},'.jpg'];
%            print(fig3,filename,'-djpg'); clf
%------------------------------------------------------------------------------------Koeficijent korelacije
%--2016-01-20
r=corr(stand_CRU_A1,stand_ERA_A1);     filenam=['timecorr_CRUvsERA_',SEAS{SEASx},'_A1.txt']; fileID = fopen(filenam,'w'); fprintf(fileID,'%6.4f',r); fclose(fileID);
r=corr(stand_CRU_A1,stand_RCM_ENS_A1); filenam=['timecorr_CRUvsRCM_',SEAS{SEASx},'_A1.txt']; fileID = fopen(filenam,'w'); fprintf(fileID,'%6.4f',r); fclose(fileID);
r=corr(stand_ERA_A1,stand_RCM_ENS_A1); filenam=['timecorr_RCMvsERA_',SEAS{SEASx},'_A1.txt']; fileID = fopen(filenam,'w'); fprintf(fileID,'%6.4f',r); fclose(fileID);
r=corr(stand_CRU_A2,stand_ERA_A2);     filenam=['timecorr_CRUvsERA_',SEAS{SEASx},'_A2.txt']; fileID = fopen(filenam,'w'); fprintf(fileID,'%6.4f',r); fclose(fileID);
r=corr(stand_CRU_A2,stand_RCM_ENS_A2); filenam=['timecorr_CRUvsRCM_',SEAS{SEASx},'_A2.txt']; fileID = fopen(filenam,'w'); fprintf(fileID,'%6.4f',r); fclose(fileID);
r=corr(stand_ERA_A2,stand_RCM_ENS_A2); filenam=['timecorr_RCMvsERA_',SEAS{SEASx},'_A2.txt']; fileID = fopen(filenam,'w'); fprintf(fileID,'%6.4f',r); fclose(fileID);
%--
%------------------------------------------------------------------------------------Srednjak rasapa
%--2016-01-21
sss=mean(rasap_stand_RCM_A1); filenam=['mean_rasap_',SEAS{SEASx},'_A1.txt']; fileID = fopen(filenam,'w'); fprintf(fileID,'%6.4f',sss); fclose(fileID);
sss=mean(rasap_stand_RCM_A2); filenam=['mean_rasap_',SEAS{SEASx},'_A2.txt']; fileID = fopen(filenam,'w'); fprintf(fileID,'%6.4f',sss); fclose(fileID);
%--

           clear pr_CRU pr_RCM pr_ERA std_* mean_* stand_* CRU_* ERA_* RCM_* pr_RCM_ENS rasap*
           close all

end %SEASx
