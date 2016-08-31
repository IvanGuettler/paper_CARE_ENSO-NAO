close all; clear all; clc

pkg load netcdf
pkg load io
pkg load statistics

SEAS{ 1}=['DJF']; SEAS{ 2}=['JFM']; SEAS{ 3}=['FMA']; SEAS{ 4}=['MAM'];
SEAS{ 5}=['AMJ']; SEAS{ 6}=['MJJ']; SEAS{ 7}=['JJA']; SEAS{ 8}=['JAS'];
SEAS{ 9}=['ASO']; SEAS{10}=['SON']; SEAS{11}=['OND']; SEAS{12}=['NDJ'];

for SEASx=[1 :   12];
%for SEASx=1;

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

DIR_RCM='/home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_RCM/';

    FILE_RCM=[DIR_RCM,'pr_MOD_ENSAVG_SM_',SEAS{SEASx},'_SMS_2014_interp.nc'];
    temp=ncread(FILE_RCM,'pr');
    pr_RCM_ENS(:,:,:)=double(temp); % LON x LAT x YEARS
    clear temp
 	
	NValidPoints=0;
        crit1(SEASx)=0;
        crit2(SEASx)=0;
        crit3(SEASx)=0;
        crit4(SEASx)=0;
        crit5(SEASx)=0;

	for I=1:160;
	for J=1:110;
	    if (isfinite(pr_CRU(I,J,1))&&isfinite(pr_RCM_ENS(I,J,1)));
		p_TEST(I,J)=u_test(squeeze(pr_CRU(I,J,:)),squeeze(pr_RCM_ENS(I,J,:)*24*60*60));
		if (p_TEST(I,J)<0.05);
                	H_TEST(I,J)=1;
		else
        	        H_TEST(I,J)=0;
		end
	   NValidPoints=NValidPoints+1;
           else
        	        H_TEST(I,J)=0;
      	   end

           diff=mean(squeeze(pr_RCM_ENS(I,J,:)*24*60*60))-mean(squeeze(pr_CRU(I,J,:)));
           if ((abs(diff)>=0.2)&&(H_TEST(I,J)==1));		crit1(SEASx)=crit1(SEASx)+1; end
           if ((abs(diff)>=0.5)&&(H_TEST(I,J)==1));		crit2(SEASx)=crit2(SEASx)+1; end
           if ((abs(diff)>=1.0)&&(H_TEST(I,J)==1));		crit3(SEASx)=crit3(SEASx)+1; end
           if ((abs(diff)>=2.0)&&(H_TEST(I,J)==1));		crit4(SEASx)=crit4(SEASx)+1; end
           if ((abs(diff)>=5.0)&&(H_TEST(I,J)==1));		crit5(SEASx)=crit5(SEASx)+1; end
    

	end
	end
	NValidPoints

	fileIG=["WMW_test_",SEAS{SEASx},".nc"];
	nccreate(fileIG,"WMW_test","Dimensions",{"lon",160,"lat",110},"Format","classic");
	nccreate(fileIG,"lon",     "Dimensions",{"lon",160},"Format","classic");
	nccreate(fileIG,"lat",     "Dimensions",{"lat",110},"Format","classic");
	 ncwrite(fileIG,"WMW_test",H_TEST);
	 ncwrite(fileIG,"lon",lonCRU);
	 ncwrite(fileIG,"lat",latCRU);
		 ncwriteatt( fileIG,"lon","standard_name","longitude");
		 ncwriteatt( fileIG,"lon","long_name",    "longitude");
		 ncwriteatt( fileIG,"lon","units",        "degrees_east");
		 ncwriteatt( fileIG,"lon","axis",         "X");
		 	 ncwriteatt( fileIG,"lat","standard_name","latitude");
			 ncwriteatt( fileIG,"lat","long_name",    "latitude");
			 ncwriteatt( fileIG,"lat","units",        "degrees_north");
			 ncwriteatt( fileIG,"lat","axis",         "Y");
	


	clear p_TEST pr_CRU pr_RCM_ENS H_TEST
end

	table=[round(crit1/NValidPoints*100*100)'/100 round(crit2/NValidPoints*100*100)'/100 round(crit3/NValidPoints*100*100)'/100 round(crit4/NValidPoints*100*100)'/100 round(crit5/NValidPoints*100*100)'/100]



%%	

