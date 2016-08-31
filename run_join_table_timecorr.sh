#!/bin/bash

DIR=.
echo ${DIR}

for SEAS  in DJF JFM FMA MAM AMJ MJJ JJA JAS ASO SON OND NDJ; do
for COMBI in CRUvsERA CRUvsRCM RCMvsERA                     ; do

    paste ${DIR}/timecorr_${COMBI}_${SEAS}_A1.txt ${DIR}/timecorr_${COMBI}_${SEAS}_A2.txt> temp_${COMBI}.txt

done

    cat    temp_*.txt    > tcorr_${SEAS}.txt
    rm -vf temp_*.txt

done

cat tcorr_{DJF,JFM,FMA,MAM,AMJ,MJJ,JJA,JAS,ASO,SON,OND,NDJ}.txt > tcorr_ALL_SEASONS.txt
cat tcorr_{DJF,MAM,JJA,SON}.txt > tcorr_MAIN_SEASONS.txt

rm -vf tcorr_???.txt
