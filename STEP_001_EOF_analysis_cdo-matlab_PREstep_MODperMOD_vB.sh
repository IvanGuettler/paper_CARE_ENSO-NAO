for SEAS in AMJ ASO DJF FMA JAS JFM JJA MAM MJJ NDJ OND SON ; do
for SOUR in {1..15}                                             ; do

echo "                                      "
echo "                                      "
echo "                                      "

#--Priprema
#--CHECK
cdo detrend -seldate,1961-03-01,2000-12-31 ../pr_MOD_${SOUR}_SM_${SEAS}_SMS_2014_interp.nc    detrend.nc
cdo mul                                                                                   detrend.nc maska_03.nc  detrend_maskiran.nc
cdo -r settaxis,1962-01-01,00:00:00,1years -selindexbox,1,160,8,98 detrend_maskiran.nc    detrend_maskiran_subregion_${SEAS}_${SOUR}.nc
rm -vf detrend.nc detrend_maskiran.nc

done #SEAS

cdo cat detrend_maskiran_subregion_${SEAS}_?.nc detrend_maskiran_subregion_${SEAS}_??.nc detrend_maskiran_subregion_${SEAS}_MOD_1_15.nc

done #SOUR
