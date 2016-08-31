for SEAS in AMJ ASO DJF FMA JAS JFM JJA MAM MJJ NDJ OND SON     ; do
	for SOUR in {1..15}                                             ; do

	echo "                                      "
	echo "                                      "
	echo "                                      "

	#--Priprema
	#--CHECK
	cdo -seldate,1961-03-01,2000-12-31 ../pr_MOD_${SOUR}_SM_${SEAS}_SMS_2014_interp.nc    YYY.nc
	cdo mul                                                                               YYY.nc maska_03.nc  YYY_maskiran.nc
	cdo -r settaxis,1962-01-01,00:00:00,1years -selindexbox,1,160,8,98                    YYY_maskiran.nc     YYY_maskiran_subregion_${SEAS}_${SOUR}.nc
	rm -vf YYY.nc YYY_maskiran.nc

	done #SOUR

	cdo cat YYY_maskiran_subregion_${SEAS}_?.nc YYY_maskiran_subregion_${SEAS}_??.nc YYY_maskiran_subregion_${SEAS}_MOD_1_15.nc

	cdo detrend YYY_maskiran_subregion_${SEAS}_MOD_1_15.nc XXX_${SEAS}.nc

done #SEAS
