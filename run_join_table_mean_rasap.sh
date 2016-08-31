#!/bin/bash

for SEAS  in DJF JFM FMA MAM AMJ MJJ JJA JAS ASO SON OND NDJ; do
    paste ./mean_rasap_${SEAS}_A1.txt    ./mean_rasap_${SEAS}_A2.txt> rasap_${SEAS}.txt
done

cat rasap_{DJF,JFM,FMA,MAM,AMJ,MJJ,JJA,JAS,ASO,SON,OND,NDJ}.txt > rasap_ALL_SEASONS.txt
cat rasap_{DJF,MAM,JJA,SON}.txt > rasap_MAIN_SEASONS.txt

rm -vf rasap_???.txt
