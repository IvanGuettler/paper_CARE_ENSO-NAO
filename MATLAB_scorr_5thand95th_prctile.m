%% zapocinjem i cistim
close all; clear all; clc

pkg load netcdf
pkg load io
pkg load statistics

% GrADS http://radar.dhz.hr/~regcm/PLOTS_2014_11_SeasonalClimatology/Table_AreaCorrPrecip.txt
% Table 1. Spatial correlation coefficient. Whole domain: (-25°E,35°E), (35.5°N,72°N).
% Southern part: (-25°E,35°E), (35.5°N,50°N). Northern part: (-25°E,35°E), (50°N,72°N).
% All regions include land-only points on the CRU 0.5 x 0.5 grid.
%    CRUvsERA CRUvsRCM ERAvsRCM   |  CRUvsERA CRUvsRCM ERAvsRCM  |  CRUvsERA CRUvsRCM ERAvsRCM  
   0.76     0.83     0.83     |    0.72     0.75     0.70    |    0.80     0.88     0.92   
   0.75     0.83     0.84     |    0.70     0.76     0.70    |    0.79     0.87     0.92
   0.73     0.81     0.82     |    0.68     0.77     0.69    |    0.77     0.85     0.91
   0.73     0.81     0.80     |    0.75     0.84     0.73    |    0.72     0.80     0.89
   0.76     0.83     0.78     |    0.83     0.89     0.78    |    0.55     0.68     0.78 
   0.81     0.87     0.81     |    0.87     0.92     0.83    |    0.48     0.63     0.65
   0.84     0.90     0.84     |    0.88     0.93     0.85    |    0.43     0.69     0.59
   0.83     0.90     0.86     |    0.87     0.93     0.85    |    0.56     0.79     0.73 
   0.80     0.88     0.89     |    0.84     0.90     0.82    |    0.75     0.85     0.89
   0.79     0.85     0.88     |    0.83     0.85     0.79    |    0.79     0.87     0.91  
   0.77     0.83     0.84     |    0.77     0.77     0.74    |    0.80     0.88     0.91  
   0.76     0.82     0.83     |    0.73     0.75     0.71    |    0.80     0.88     0.92


SEAStxt={'DJF','JFM','FMA','MAM','AMJ','MJJ','JJA','JAS','ASO','SON','OND','NDJ'};

p05=nan(4,12,3);
p50=nan(4,12,3);
p95=nan(4,12,3);
pMM=nan(1,12);

 for REG=[1:3];
 for SEAS=[1:12];
%% Definiram tezine
%
% N2, lat  ^
%          |
%          |    
%          |
%        1 |_ _ _ _ _ _> N1, lon
%          1

%    N1=278; 
%    N2=170;
%    lon=[-23.875:0.25:(-23.875+(N1-1)*0.25) ];
%    lat=[ 29.125:0.25:( 29.125+(N2-1)*0.25) ];
%    N1=720;
%    N2=360;
%    lon=[-179.75:0.5:(-179.75+(N1-1)*0.5)];
%    lat=[ -89.75:0.5:( -89.75+(N2-1)*0.5)];
    N1=160;
    N2=110;
    lon=[-30.75:0.5:(-30.75+(N1-1)*0.5)];
    lat=[ 25.75:0.5:( 25.75+(N2-1)*0.5)];

     [LON,LAT]=meshgrid(lon,lat);
    
    for i=1:N2
         w1_a((i-1)*N1+1:i*N1)=lat(i);
    end
        w1_a=w1_a';
        %>>> w1=abs(sind(w1_a+0.125)-sind(w1_a-0.125));
        w1=abs(sind(w1_a+0.25)-sind(w1_a-0.25));
        w2=0.5;
        B=reshape(w1,N1,N2);


A1=ncread(['/home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_RCM/pr_MOD_ENSAVG_TIMAVG_SM_',SEAStxt{SEAS},'_SMS_2014_interp.nc'],'pr');
A2=ncread(['/home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_CRU/pr_CRU_TIMAVG_SM_',SEAStxt{SEAS},'_SMS_2014_interp.nc'],'pre');

%% Racunamo

%    x=squeeze(A1(:,:,1))';
%    y=squeeze(A2(:,:,1))';
x=A1';
y=A2';
    w1=B';
    x_vec =x(:); 
    y_vec =y(:);
    w1_vec=w1(:);
    temp=LON; lon_vec=temp(:);
    temp=LAT; lat_vec=temp(:); clear temp
    %clear x y
    t=[1:1:(N1*N2)]'; %broj tocaka: i sa podacima i bez podataka
    
    %Pronaci tocke domene u kojima nemamo vrijednosti i obrisati iz svih vektora
    remove=isnan(x_vec);
    x_vec(remove)=[];      y_vec(remove)=[];     w1_vec(remove)=[];    lon_vec(remove)=[];    lat_vec(remove)=[];
    remove=isnan(y_vec);
    x_vec(remove)=[];      y_vec(remove)=[];     w1_vec(remove)=[];    lon_vec(remove)=[];    lat_vec(remove)=[];
                               
    clear remove
    remove=find(lon_vec(:)<(-25.0));
      x_vec(remove)=[];      y_vec(remove)=[];     w1_vec(remove)=[];    lon_vec(remove)=[];    lat_vec(remove)=[];
    clear remove
    remove=find(lon_vec(:)> 35.0);
      x_vec(remove)=[];      y_vec(remove)=[];     w1_vec(remove)=[];    lon_vec(remove)=[];    lat_vec(remove)=[];

    if (REG==1); 
	    clear remove
	    remove=find(lat_vec(:)< 35.5);
	    x_vec(remove)=[];      y_vec(remove)=[];     w1_vec(remove)=[];    lon_vec(remove)=[];    lat_vec(remove)=[];
	    clear remove
	    remove=find(lat_vec(:)> 72.0);
	    x_vec(remove)=[];      y_vec(remove)=[];     w1_vec(remove)=[];    lon_vec(remove)=[];    lat_vec(remove)=[];
    	    t=[1:1:length(x_vec)]; %broj tocaka: samo sa podacima, bez NaN
	    r_cool=scorr(x_vec(:),y_vec(:),w1_vec(:),w2,t(:));
    end
    if (REG==2); 
	    clear remove
	    remove=find(lat_vec(:)< 35.5);
	    x_vec(remove)=[];      y_vec(remove)=[];     w1_vec(remove)=[];    lon_vec(remove)=[];    lat_vec(remove)=[];
	    clear remove
	    remove=find(lat_vec(:)> 50.0);
	    x_vec(remove)=[];      y_vec(remove)=[];     w1_vec(remove)=[];    lon_vec(remove)=[];    lat_vec(remove)=[];
    end
    if (REG==3); 
	    clear remove
	    remove=find(lat_vec(:)< 50.0);
	    x_vec(remove)=[];      y_vec(remove)=[];     w1_vec(remove)=[];    lon_vec(remove)=[];    lat_vec(remove)=[];
	    clear remove
	    remove=find(lat_vec(:)> 72.0);
	    x_vec(remove)=[];      y_vec(remove)=[];     w1_vec(remove)=[];    lon_vec(remove)=[];    lat_vec(remove)=[];
    end


%% Brojac
%Udio podataka sa kojima cu racunati. Ne zelim da permutira NaN-ove nego da
%ih samo ignorira. U radu za CR ovo nije sasvim bilo uvazeno.
udio=[0.10 0.25 0.75 0.90]; 
%Zelim da brojac iako random bude svaki put jedank
%load NEBRISI.mat; rand("seed",v); 
NSTEPS=1000; r=nan(NSTEPS,4);
%%    
%Udio po udio, ponovi NSTEPS puta
N3=length(x_vec);
for j=1:4

    part=udio(j)
	for i=1:NSTEPS;
         if (mod(i,100)==0); disp(i); end
	     %>>> aaa=ceil(rand(floor(part*N2*N1),1)*N1*N2); %plot(aaa). Fix s obzirom na prije!      
                  aaa=randperm(N3,ceil(part*N3));
              r(i,j)=scorr(x_vec(:),y_vec(:),w1_vec(:),w2,t(aaa'));
         end % koliko puta permutirati?

    p05(j,SEAS,REG)=prctile(r(:,j),5 );
    p50(j,SEAS,REG)=prctile(r(:,j),50);
    p95(j,SEAS,REG)=prctile(r(:,j),95);
    if (REG==1);    pMM(SEAS)=r_cool; end
end % udio po udio
end %REG
end %SEAS

savefile='scorr_interval_pouzdanosti.mat';
save(savefile,'p05','p50','p95','pMM');

