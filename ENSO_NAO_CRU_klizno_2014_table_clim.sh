#!/bin/bash

RESO=150
VAR=1

for SESI  in 1 2 3 4 5 6 7 8 9 10 11 12      ; do

#---------------------------------------------------------------------

cat > DO.gs << EOF

SESI=${SESI}

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

*--------------------------------------------------------------------------------------------------------
*DHMZ    'sdfopen ./2014_pr/pr_CRU_TIMAVG_SM_'SESItxt.SESI'_SMS_2014_interp.nc'
*DHMZ    'sdfopen /home/ivan/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/TEST_EOF/maska_03.nc'
         'sdfopen /home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_CRU/pr_CRU_TIMAVG_SM_'SESItxt.SESI'_SMS_2014_interp.nc'
         'sdfopen /home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_EOF/maska_03.nc'
    varic1='pre'
    offset1=0
    factor1=1


*------------------------------------------------------------
* Plot over Europe
*------------------------------------------------------------

say '------------------------------------------------------------------------->'FILE
      'set dfile 1'
      'define  totable1=aave((('varic1'.1(z=1,t=1))*'factor1'+'offset1')*pr.2(t=1,z=1),lon=-25,lon=35,lat=35.5,lat=72)'
      'define  totable2=aave((('varic1'.1(z=1,t=1))*'factor1'+'offset1')*pr.2(t=1,z=1),lon=-25,lon=35,lat=35.5,lat=50)'
      'define  totable3=aave((('varic1'.1(z=1,t=1))*'factor1'+'offset1')*pr.2(t=1,z=1),lon=-25,lon=35,lat=50,lat=72)'

      'set gxout grfill'
      'd (('varic1'.1(z=1,t=1))*'factor1'+'offset1')*pr.2(t=1,z=1)'

      'fprintf.gs totable1 CRU_domain_all_'SESItxt.SESI'.txt %g 1'
      'fprintf.gs totable2 CRU_domain_SSS_'SESItxt.SESI'.txt %g 1'
      'fprintf.gs totable3 CRU_domain_NNN_'SESItxt.SESI'.txt %g 1'
*------------------------------------------------------------
* Print plot 
*------------------------------------------------------------

"quit"
EOF

#------------------------------------------------------------
# Run opengrads 
#------------------------------------------------------------

grads  -lc "DO.gs"
rm -vf DO.gs

done #SESI


