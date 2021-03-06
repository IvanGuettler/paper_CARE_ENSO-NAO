#!/bin/bash

#Zelim izracunati koeficijent korelacije izmedju anomalija

RESO=150

for  TIP in {1..36}   ; do
for SESI in {1..12}   ; do

#--------------------------------------------------------------------------------------------------------

cat > DO.gs << EOF

TIP=${TIP}
SESI=${SESI}

VARtxt.1='pr'

 SESItxt.1='DJF'
 SESItxt.2='JFM'
 SESItxt.3='FMA'
 SESItxt.4='MAM'
 SESItxt.5='AMJ'
 SESItxt.6='MJJ'
 SESItxt.7='JJA'
 SESItxt.8='JAS'
 SESItxt.9='ASO'
SESItxt.10='SON'
SESItxt.11='OND'
SESItxt.12='NDJ'

*---
*1/3 Open mask
*---
    'sdfopen   /home/ivan/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/DIR_maska/maska_FINAL.nc'
*---
*2/3 Open CRU&ERA40
*---
    'sdfopen  ./DIR_CRU/pr_CRU_SM_'SESItxt.SESI'_TIP'TIP'_anomaly_SMS_2014.nc '
    'sdfopen  ./DIR_CRU/pr_ERA40_SM_'SESItxt.SESI'_TIP'TIP'_anomaly_SMS_2014.nc '

*---
*3/3 Open files
*---
     MODEL=1
     while MODEL<=15
        'sdfopen  ./DIR_CRU/pr_MOD_'MODEL'_SM_'SESItxt.SESI'_TIP'TIP'_anomaly_SMS_2014.nc '
     MODEL=MODEL+1
     endwhile
        'sdfopen  ./DIR_CRU/pr_MOD_ENSAVG_SM_'SESItxt.SESI'_TIP'TIP'_anomaly_SMS_2014.nc '
            offset1=0
            factor1=86400
*---
* Racun
*---
LONstart=-32; LONend=62;
LATstart=29;  LATend=73;
'set lon 'LONstart' 'LONend
'set lat 'LATstart' 'LATend

       'define toSAVE=scorr(lterp(pr.3(t=1,z=1),maska.1)*'factor1'*maska.1,pre.2(t=1,z=1),lon='LONstart',lon='LONend',lat='LATstart',lat='LATend')'
       'fprintf.gs toSave output0.txt %g 1'

     MODEL=1
     while MODEL<=16
        RCM=MODEL+3
       'define toSave=scorr(lterp(pr.'RCM'(t=1,z=1),maska.1)*'factor1'*maska.1,pre.2(t=1,z=1),lon='LONstart',lon='LONend',lat='LATstart',lat='LATend')'
       'fprintf.gs toSave output'MODEL'.txt %g 1'
        MODEL=MODEL+1
     endwhile


'quit'
EOF


#------------------------------------------------------------
# Run opengrads 
#------------------------------------------------------------

grads -lbc "DO.gs"
#grads -lc "DO.gs"
cat output0.txt output1.txt output2.txt output3.txt output4.txt output5.txt output6.txt output7.txt output8.txt output9.txt output10.txt output11.txt output12.txt output13.txt output14.txt output15.txt output16.txt > podaci_TIP_${TIP}_SESI_${SESI}_SMS.txt
rm DO.gs output?.txt output??.txt

done #SESI
done #TIP
