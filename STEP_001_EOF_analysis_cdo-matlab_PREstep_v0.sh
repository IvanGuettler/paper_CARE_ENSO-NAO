
for SEAS in AMJ ASO DJF FMA JAS JFM JJA MAM MJJ NDJ OND SON ; do

echo "                                      "
echo "                                      "
echo "                                      "

cd /home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_EOF

#------
#-- CRU
#------
SOUR=CRU
cdo detrend -seldate,1961-03-01,2000-12-31 ../FILES_CRU/pr_${SOUR}_SM_${SEAS}_SMS_2014_interp.nc detrend.nc
cdo mul      detrend.nc maska_03.nc detrend_maskiran.nc
cdo -r settaxis,1962-01-01,00:00:00,1years -selindexbox,1,160,8,98 detrend_maskiran.nc detrend_maskiran_subregion_${SEAS}_${SOUR}.nc
#------
#-- ERA40
#------
SOUR=ERA40
cdo detrend -seldate,1961-03-01,2000-12-31 ../FILES_ERA/pr_${SOUR}_SM_${SEAS}_SMS_2014_interp.nc detrend.nc
cdo mul      detrend.nc maska_03.nc detrend_maskiran.nc
cdo -r settaxis,1962-01-01,00:00:00,1years -selindexbox,1,160,8,98 detrend_maskiran.nc detrend_maskiran_subregion_${SEAS}_${SOUR}.nc
#------
#-- RCM
#------
SOUR=MOD_ENSAVG
cdo detrend -seldate,1961-03-01,2000-12-31 ../FILES_RCM/pr_${SOUR}_SM_${SEAS}_SMS_2014_interp.nc detrend.nc
cdo mul      detrend.nc maska_03.nc detrend_maskiran.nc
cdo -r settaxis,1962-01-01,00:00:00,1years -selindexbox,1,160,8,98 detrend_maskiran.nc detrend_maskiran_subregion_${SEAS}_${SOUR}.nc

done #SEAS
