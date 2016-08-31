for VAR in pr ; do

#       FILE[1]="/home/ivan/OBS/CRU/cru_ts_3_10_01.1901.2009.pre.dat_nc3.nc"
        FILE[1]="/home/ivan/OBS/CRU/cru_ts_3_10_01.1901.2009.pre.dat_nc4.nc"

        SEAStxt[ 1]="FMA"
        SEAStxt[ 2]="MAM"
        SEAStxt[ 3]="AMJ"
        SEAStxt[ 4]="MJJ"
        SEAStxt[ 5]="JJA"
        SEAStxt[ 6]="JAS"
        SEAStxt[ 7]="ASO"
        SEAStxt[ 8]="SON"
        SEAStxt[ 9]="OND"
        SEAStxt[10]="NDJ"
        SEAStxt[11]="DJF"
        SEAStxt[12]="JFM"

        SETmontxt[ 1]=03
        SETmontxt[ 2]=04
        SETmontxt[ 3]=05
        SETmontxt[ 4]=06
        SETmontxt[ 5]=07
        SETmontxt[ 6]=08
        SETmontxt[ 7]=09
        SETmontxt[ 8]=10
        SETmontxt[ 9]=11
        SETmontxt[10]=12
        SETmontxt[11]=01
        SETmontxt[12]=02

#-----------------
#----------------- STEP 1: izracunati sezonski srednjak za svaku godinu i svaki model odvojeno
#-----------------
#STEP 1 OK (treba ponovo register u CEDA i povuci CRU 3.10.01
#echo '=================================================================================================='
#echo '                                      STEP 1'
#echo '=================================================================================================='
#    for MOD in 1           ; do
#
#        INPUT=${FILE[${MOD}]}
#        OUTPUT=running.nc
#        cdo -r -f nc -b 32 divdpm  -setday,15 -runmean,3 -seldate,1961-01-01,2000-12-31 ${INPUT} ${OUTPUT}
#
#        for SES in {1..12} ; do
#
#            INPUT=running.nc
#            OUTPUT=${VAR}_CRU_SM_${SEAStxt[${SES}]}_SMS_2014.nc   #Ovdje su sve mjesecne vrijednosti za pojedinu sezonu u periodu 1961-2000
#            cdo -r -selmon,${SETmontxt[${SES}]}  ${INPUT} ${OUTPUT}
#
#        done #SES
#
#        rm running.nc
#    done #MOD



#-----------------
#----------------- STEP 2: izracunati za svaku godinu odvojeno i sve modele skupa taj srednjak. Nakon toga, srednjak po svim godinama i svim modelima
#-----------------
echo '=================================================================================================='
echo '                                      STEP 2'
echo '=================================================================================================='

DIRWRK=/home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/
cd ${DIRWRK}
    for SES in 1 2 3 4 5 6 7 8 9 11 12 ; do

        INPUT=./2014_pr/FILES_CRU/${VAR}_CRU_SM_${SEAStxt[${SES}]}_SMS_2014.nc
     OUTPUT1=${VAR}_CRU_TIMAVG_SM_${SEAStxt[${SES}]}_SMS_2016.nc    #visegodisnji srednjak po SVIM     godinama
     OUTPUT2=${VAR}_CRU_TIMSTD_SM_${SEAStxt[${SES}]}_SMS_2016.nc    #visegodisnji stdev    po SVIM     godinama

        cdo timavg                               ${INPUT} ${OUTPUT1}
        cdo timstd                               ${INPUT} ${OUTPUT2}

    done #od SES

    for SES in 10 ; do

        INPUT=./2014_pr/FILES_CRU/${VAR}_CRU_SM_${SEAStxt[${SES}]}_SMS_2014.nc
     OUTPUT1=${VAR}_CRU_TIMAVG_SM_${SEAStxt[${SES}]}_SMS_2016.nc    #visegodisnji srednjak po SVIM     godinama
     OUTPUT2=${VAR}_CRU_TIMSTD_SM_${SEAStxt[${SES}]}_SMS_2016.nc    #visegodisnji stdev    po SVIM     godinama

        cdo timavg                               ${INPUT} ${OUTPUT1}
        cdo timstd                               ${INPUT} ${OUTPUT2}

    done #od SES


done #od VAR
