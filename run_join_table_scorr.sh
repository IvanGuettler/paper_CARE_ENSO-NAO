#!/bin/bash

for DOMA  in all NNN SSS                                   ; do
    for SEAS  in DJF JFM FMA MAM AMJ MJJ JJA JAS ASO SON OND NDJ; do
        touch test.txt
        for MODI  in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15            ; do
            paste test.txt    ./MOD_${MODI}_scorr_CRUvsRCM_domain_${DOMA}_${SEAS}.txt   >    scorr_CRUvsRCM_domain_${DOMA}_${SEAS}.txt
            cp -v scorr_CRUvsRCM_domain_${DOMA}_${SEAS}.txt test.txt
        done #MODI
        mv test.txt scorr_CRUvsRCM_domain_${DOMA}_${SEAS}.txt
    done #SES
    cat scorr_CRUvsRCM_domain_${DOMA}_{DJF,JFM,FMA,MAM,AMJ,MJJ,JJA,JAS,ASO,SON,OND,NDJ}.txt > scorr_CRUvsRCM_domain_${DOMA}_ALL_SEASONS.txt
done #DOMA

#cat rasap_{DJF,MAM,JJA,SON}.txt > rasap_MAIN_SEASONS.txt
#rm -vf rasap_???.txt
