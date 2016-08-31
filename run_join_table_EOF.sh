#!/bin/bash


DIR=DIR_scorr_EOF_tables
echo ${DIR}

for SEAS  in DJF JFM FMA MAM AMJ MJJ JJA JAS ASO SON OND NDJ; do
for COMBI in ERA40vsMODENS CRUvsERA40 CRUvsMODENS           ; do

    paste ./${DIR}/EOFs_1_scorr_${COMBI}_domain_all_${SEAS}.txt ./${DIR}/EOFs_2_scorr_${COMBI}_domain_all_${SEAS}.txt > temp.txt
    paste temp.txt                                     ./${DIR}/EOFs_3_scorr_${COMBI}_domain_all_${SEAS}.txt > www_scorr_${COMBI}_domain_all_${SEAS}.txt
    rm    temp.txt

done

    cat www_scorr_*_domain_all_${SEAS}.txt > zzz_scorr_${SEAS}.txt

done

cat zzz_scorr_{DJF,JFM,FMA,MAM,AMJ,MJJ,JJA,JAS,ASO,SON,OND,NDJ}.txt > scorr_ALL_SEASONS.txt
cat zzz_scorr_{DJF,MAM,JJA,SON}.txt > scorr_MAIN_SEASONS.txt

rm www_scorr*txt
rm zzz_scorr*txt
