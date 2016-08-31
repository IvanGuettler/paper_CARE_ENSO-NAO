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

%--
ENSOstrongPLUS=[1973,1983,1992,1998,1987,1966]; 
ENSOstrongNEGE=[1989,1976,2000,1971,1974,1999];
ENSOmodertPLUS=[1995,1988,1977,1969];
ENSOmodertNEGE=[1967,1968,1984,1986,1985,1996];
 NAOstrongPLUS=[1989,1990,1993,1995];
 NAOstrongNEGE=[1963,1969,1966];
 NAOmodertPLUS=[1976,2000,1994,1997,1973,1983,1992];
 NAOmodertNEGE=[1985,1996,1964,1965,1970,1979,1980,1977,1987];

ENSOstrongPLUS2=[1973,1973,NaN,1983,1983,NaN,1992,1992,NaN,1998,1998,NaN,1987,1987,NaN,1966,1966,NaN]; 
ENSOstrongNEGE2=[1989,1989,NaN,1976,1976,NaN,2000,2000,NaN,1971,1971,NaN,1974,1974,NaN,1999,1999,NaN];
ENSOmodertPLUS2=[1995,1995,NaN,1988,1988,NaN,1977,1977,NaN,1969,1969,NaN];
ENSOmodertNEGE2=[1967,1967,NaN,1968,1968,NaN,1984,1984,NaN,1986,1986,NaN,1985,1985,NaN,1996,1996,NaN];
 NAOstrongPLUS2=[1989,1989,NaN,1990,1990,NaN,1993,1993,NaN,1995,1995,NaN];
 NAOstrongNEGE2=[1963,1963,NaN,1969,1969,NaN,1966,1966,NaN];
 NAOmodertPLUS2=[1976,1976,NaN,2000,2000,NaN,1994,1994,NaN,1997,1997,NaN,1973,1973,NaN,1983,1983,NaN,1992,1992,NaN];
 NAOmodertNEGE2=[1985,1985,NaN,1996,1996,NaN,1964,1964,NaN,1965,1965,NaN,1970,1970,NaN,1979,1979,NaN,1980,1980,NaN,1977,1977,NaN,1987,1987,NaN];



 for SEASx=2;
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

futa=14;
%------------------------------------------------------------------------------------Crtanje standardizirane oborine
%ENSOstrongPLUS=[1973,1983,1992,1998,1987,1966];
%ENSOstrongNEGE=[1989,1976,2000,1971,1974,1999];
%ENSOmodertPLUS=[1995,1988,1977,1969];
%ENSOmodertNEGE=[1967,1968,1984,1986,1985,1996];
% NAOstrongPLUS=[1989,1990,1993,1995];
% NAOstrongNEGE=[1963,1969,1966];
% NAOmodertPLUS=[1976,2000,1994,1997,1973,1983,1992];
% NAOmodertNEGE=[1985,1996,1964,1965,1970,1979,1980,1977,1987];

   fig1=figure(1); set(gcf,'Position',[56 0 1395 869]);
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
       plot(ENSOstrongPLUS,stand_CRU_A1(ENSOstrongPLUS-1961),'o r','markerfacecolor','r','markersize',15,'markeredgecolor','k'); hold on
       plot(ENSOstrongNEGE,stand_CRU_A1(ENSOstrongNEGE-1961),'o b','markerfacecolor','b','markersize',15,'markeredgecolor','k'); hold on
       plot( NAOstrongPLUS,stand_CRU_A1( NAOstrongPLUS-1961),'d r','markerfacecolor','r','markersize',13,'markeredgecolor','k'); hold on
       plot( NAOstrongNEGE,stand_CRU_A1( NAOstrongNEGE-1961),'d b','markerfacecolor','b','markersize',13,'markeredgecolor','k'); hold on
			vvv=length(NAOstrongPLUS2); vvv2=repmat([-4,-3.0,0],1,vvv/3); plot(NAOstrongPLUS2,vvv2,'r','Linewidth',3); hold on
			vvv=length(NAOmodertPLUS2); vvv2=repmat([-4,-3.5,0],1,vvv/3); plot(NAOmodertPLUS2,vvv2,'r','Linewidth',3); hold on
			vvv=length(NAOstrongNEGE2); vvv2=repmat([-4,-3.0,0],1,vvv/3); plot(NAOstrongNEGE2,vvv2,'b','Linewidth',3); hold on
			vvv=length(NAOmodertNEGE2); vvv2=repmat([-4,-3.5,0],1,vvv/3); plot(NAOmodertNEGE2,vvv2,'b','Linewidth',3); hold on
       plot(NAOstrongPLUS,-3.0*ones(1,length(NAOstrongPLUS)),'^ r','markerfacecolor','r'); hold on
       plot(NAOmodertPLUS,-3.5*ones(1,length(NAOmodertPLUS)),'^ r','markerfacecolor','r'); hold on
       plot(NAOstrongNEGE,-3.0*ones(1,length(NAOstrongNEGE)),'^ b','markerfacecolor','b'); hold on
       plot(NAOmodertNEGE,-3.5*ones(1,length(NAOmodertNEGE)),'^ b','markerfacecolor','b'); hold on
			vvv=length(ENSOstrongPLUS2); vvv2=repmat([3.0,4.0,0],1,vvv/3); plot(ENSOstrongPLUS2,vvv2,'r','Linewidth',3); hold on
			vvv=length(ENSOmodertPLUS2); vvv2=repmat([3.5,4.0,0],1,vvv/3); plot(ENSOmodertPLUS2,vvv2,'r','Linewidth',3); hold on
			vvv=length(ENSOstrongNEGE2); vvv2=repmat([3.0,4.0,0],1,vvv/3); plot(ENSOstrongNEGE2,vvv2,'b','Linewidth',3); hold on
			vvv=length(ENSOmodertNEGE2); vvv2=repmat([3.5,4.0,0],1,vvv/3); plot(ENSOmodertNEGE2,vvv2,'b','Linewidth',3); hold on
       plot(ENSOstrongPLUS, 3.0*ones(1,length(ENSOstrongPLUS)),'v r','markerfacecolor','r'); hold on
       plot(ENSOmodertPLUS, 3.5*ones(1,length(ENSOmodertPLUS)),'v r','markerfacecolor','r'); hold on
       plot(ENSOstrongNEGE, 3.0*ones(1,length(ENSOstrongNEGE)),'v b','markerfacecolor','b'); hold on
       plot(ENSOmodertNEGE, 3.5*ones(1,length(ENSOmodertNEGE)),'v b','markerfacecolor','b'); hold on

%v1    leg=legend('RCM min/max','RCM ENS','CRU', 'ERA40'); set(leg,'Fontsize',futa,'Location','southwest'); legend boxoff
       %---> legenda
        	aaa=1962; bbb=1965;
	        plot([aaa bbb]+10,[-2.5 -2.5],'color',[250, 192, 144]./256,'linewidth',10); t=text(bbb+0.5+10,-2.5,'RCM min/max'); set(t,'Fontsize',futa);
	        plot([aaa bbb]+10,[-2.0 -2.0],'b','linewidth', 3); t=text(bbb+0.5+10,-2.0,'RCM ENS')    ; set(t,'Fontsize',futa);
        	plot([aaa bbb],[-2.5 -2.5],'k','linewidth', 3); t=text(bbb+0.5,-2.5,'CRU')        ; set(t,'Fontsize',futa);
	        plot([aaa bbb],[-2.0 -2.0],'r','linewidth', 3); t=text(bbb+0.5,-2.0,'ERA40')      ; set(t,'Fontsize',futa);
       %<--- legenda
%       title(['standardized precipitation over AREA 1; ',SEAS{SEASx}],'Fontsize',futa)
       title(['standardized precipitation over S. Europe; ',SEAS{SEASx}],'Fontsize',futa)
            xlabel('time (years)','Fontsize',futa); ylabel('stand. precip. (-)','Fontsize',futa)
            grid on

            xlim([1961 2000]); ylim([-4 4]); set(gca,'Xtick',[1960:5:2000],'YTick',[-4:1:4]);
            filename=['ENSO-NAO_STAN_AREA1_',SEAS{SEASx},'.jpg'];
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
		 h2=plot(years,stand_CRU_A2,    'Linewidth',3,'k');  hold on  
		 h3=plot(years,stand_ERA_A2,    'Linewidth',3,'r');  hold on        
        plot(ENSOstrongPLUS,stand_CRU_A2(ENSOstrongPLUS-1961),'o r','markerfacecolor','r','markersize',15,'markeredgecolor','k'); hold on
        plot(ENSOstrongNEGE,stand_CRU_A2(ENSOstrongNEGE-1961),'o b','markerfacecolor','b','markersize',15,'markeredgecolor','k'); hold on
        plot( NAOstrongPLUS,stand_CRU_A2( NAOstrongPLUS-1961),'d r','markerfacecolor','r','markersize',13,'markeredgecolor','k'); hold on
        plot( NAOstrongNEGE,stand_CRU_A2( NAOstrongNEGE-1961),'d b','markerfacecolor','b','markersize',13,'markeredgecolor','k'); hold on
			vvv=length(NAOstrongPLUS2); vvv2=repmat([-4,-3.0,0],1,vvv/3); plot(NAOstrongPLUS2,vvv2,'r','Linewidth',3); hold on
			vvv=length(NAOmodertPLUS2); vvv2=repmat([-4,-3.5,0],1,vvv/3); plot(NAOmodertPLUS2,vvv2,'r','Linewidth',3); hold on
			vvv=length(NAOstrongNEGE2); vvv2=repmat([-4,-3.0,0],1,vvv/3); plot(NAOstrongNEGE2,vvv2,'b','Linewidth',3); hold on
			vvv=length(NAOmodertNEGE2); vvv2=repmat([-4,-3.5,0],1,vvv/3); plot(NAOmodertNEGE2,vvv2,'b','Linewidth',3); hold on
	plot(NAOstrongPLUS,-3.0*ones(1,length(NAOstrongPLUS)),'^ r','markerfacecolor','r'); hold on
	plot(NAOmodertPLUS,-3.5*ones(1,length(NAOmodertPLUS)),'^ r','markerfacecolor','r'); hold on
	plot(NAOstrongNEGE,-3.0*ones(1,length(NAOstrongNEGE)),'^ b','markerfacecolor','b'); hold on
	plot(NAOmodertNEGE,-3.5*ones(1,length(NAOmodertNEGE)),'^ b','markerfacecolor','b'); hold on
			vvv=length(ENSOstrongPLUS2); vvv2=repmat([3.0,4.0,0],1,vvv/3); plot(ENSOstrongPLUS2,vvv2,'r','Linewidth',3); hold on
			vvv=length(ENSOmodertPLUS2); vvv2=repmat([3.5,4.0,0],1,vvv/3); plot(ENSOmodertPLUS2,vvv2,'r','Linewidth',3); hold on
			vvv=length(ENSOstrongNEGE2); vvv2=repmat([3.0,4.0,0],1,vvv/3); plot(ENSOstrongNEGE2,vvv2,'b','Linewidth',3); hold on
			vvv=length(ENSOmodertNEGE2); vvv2=repmat([3.5,4.0,0],1,vvv/3); plot(ENSOmodertNEGE2,vvv2,'b','Linewidth',3); hold on
	plot(ENSOstrongPLUS, 3.0*ones(1,length(ENSOstrongPLUS)),'v r','markerfacecolor','r'); hold on
	plot(ENSOmodertPLUS, 3.5*ones(1,length(ENSOmodertPLUS)),'v r','markerfacecolor','r'); hold on
	plot(ENSOstrongNEGE, 3.0*ones(1,length(ENSOstrongNEGE)),'v b','markerfacecolor','b'); hold on
	plot(ENSOmodertNEGE, 3.5*ones(1,length(ENSOmodertNEGE)),'v b','markerfacecolor','b'); hold on

        %leg=legend('RCM min/max','RCM ENS','CRU', 'ERA40'); set(leg,'Fontsize',futa,'Location','southwest'); legend boxoff
        %---> legenda
        	aaa=1962; bbb=1965;
	        plot([aaa bbb]+10,[-2.5 -2.5],'color',[250, 192, 144]./256,'linewidth',10); t=text(bbb+0.5+10,-2.5,'RCM min/max'); set(t,'Fontsize',futa);
	        plot([aaa bbb]+10,[-2.0 -2.0],'b','linewidth', 3); t=text(bbb+0.5+10,-2.0,'RCM ENS')    ; set(t,'Fontsize',futa);
        	plot([aaa bbb],[-2.5 -2.5],'k','linewidth', 3); t=text(bbb+0.5,-2.5,'CRU')        ; set(t,'Fontsize',futa);
	        plot([aaa bbb],[-2.0 -2.0],'r','linewidth', 3); t=text(bbb+0.5,-2.0,'ERA40')      ; set(t,'Fontsize',futa);
        %<--- legenda
%        title(['standardized precipitation over AREA 2; ',SEAS{SEASx}],'Fontsize',futa)
        title(['standardized precipitation over N. Europe; ',SEAS{SEASx}],'Fontsize',futa)
            xlabel('time (years)','Fontsize',futa); ylabel('stand. precip. (-)','Fontsize',futa)
            grid on

            xlim([1961 2000]); ylim([-4 4]); set(gca,'Xtick',[1960:5:2000],'YTick',[-4:1:4]);
            filename=['ENSO-NAO_STAN_AREA2_',SEAS{SEASx},'.jpg'];
            print(fig2,filename,'-djpg');       clf

%           clear pr_CRU pr_RCM pr_ERA std_* mean_* stand_* CRU_* ERA_* RCM_* pr_RCM_ENS rasap*
%           close all

end %SEASx
