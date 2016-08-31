close all; clear all; clc

SEAS{ 1}=['DJF']; SEAS{ 2}=['JFM']; SEAS{ 3}=['FMA']; SEAS{ 4}=['MAM'];
SEAS{ 5}=['AMJ']; SEAS{ 6}=['MJJ']; SEAS{ 7}=['JJA']; SEAS{ 8}=['JAS'];
SEAS{ 9}=['ASO']; SEAS{10}=['SON']; SEAS{11}=['OND']; SEAS{12}=['NDJ'];

%%
for SEASx=[1:12];
    
    disp(['------------------>',SEAS{SEASx}])

DIR_ERA40='/home/ivan/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/';
FILE_ERA40=[DIR_ERA40,'pr_ERA40_SM_',SEAS{SEASx},'_SMS_2014_interp.nc'];

             temp=ncread(FILE_ERA40,'pr');
    pr_ERA40(:,:,:)=double(temp*86400); % LON x LAT x YEARS
       clear temp

lonERA40=ncread(FILE_ERA40,'lon'); latERA40=ncread(FILE_ERA40,'lat');
[LONERA40,LATERA40]=meshgrid(lonERA40,latERA40);

%%

DIR_RCM='/home/ivan/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/';

for MOD=[1:15];
    FILE_RCM=[DIR_RCM,'pr_MOD_',num2str(MOD),'_SM_',SEAS{SEASx},'_SMS_2014_interp.nc'];
    temp=ncread(FILE_RCM,'pr');
    pr_RCM(:,:,:,MOD)=double(temp); % LON x LAT x YEARS x MOD
    clear temp
end

%%

    T=size(pr_RCM,3);
    M=size(pr_RCM,4);
    
    ErrorSpread(160,110,1)=0;
            if (SEASx~=2);
                ERA40_TM=mean(pr_ERA40,3);
                RCM_EM_TM=mean(mean(pr_RCM,4),3);
            elseif (SEASx==2);
                ERA40_TM=mean(pr_ERA40(:,:,2:end),3);
                RCM_EM_TM=mean(mean(pr_RCM,4),3);
            end    
                                       
    for t=1:T;
        for m=1:M;
            if (SEASx~=2);
                    ErrorSpread(:,:,1)=ErrorSpread(:,:,1)+( ( pr_RCM(:,:,t,m)-pr_ERA40(:,:,t) )-(RCM_EM_TM-ERA40_TM) ).^2;
            elseif (SEASx==2);
                    ErrorSpread(:,:,1)=ErrorSpread(:,:,1)+( ( pr_RCM(:,:,t,m)-pr_ERA40(:,:,t+1) )-(RCM_EM_TM-ERA40_TM) ).^2;
            end
        end
    end
    
            ErrorSpread=sqrt(ErrorSpread'/T/M);
            figure(1); pcolorjw(LONERA40,LATERA40,ErrorSpread); colorbar
            
%%            
filename=['ErrorSpread_',SEAS{SEASx},'_vsERA40.nc'];

nccreate(filename,'lon', 'Format','classic','Dimensions',  {'lon', 160});
nccreate(filename,'lat', 'Format','classic','Dimensions',  {'lat', 110});
nccreate(filename,'time', 'Format','classic','Dimensions', {'time', 1});
nccreate(filename,'ErrorSpread', 'Format','classic','Dimensions', {'lon', 160, 'lat', 110 , 'time', 1});

 ncwrite(filename,'lon', lonERA40', [1]);
 ncwrite(filename,'lat', latERA40', [1]);
 ncwrite(filename,'time', 1 , [1]);
 ncwrite(filename,'ErrorSpread', ErrorSpread', [1 1 1]);

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
 ncwriteatt(filename,'ErrorSpread','standard_name','error spread');
 ncwriteatt(filename,'ErrorSpread','long_name','error spread');
 ncwriteatt(filename,'ErrorSpread','coordinates','lon lat');
		
 
    clear pr_ERA40 pr_RCM lon* LON* lat* LAT* ERA40_TM  RCM_EM_TM ErrorSpread
end %od SEASx




 