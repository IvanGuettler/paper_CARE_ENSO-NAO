#!/bin/bash


for COMBI in 1 2 3                           ; do
for SESI  in 1 2 3 4 5 6 7 8 9 10 11 12      ; do

#---------------------------------------------------------------------

cat > DO.gs << EOF

SESI=${SESI}
COMBI=${COMBI}

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
    if (COMBI=1)
         'sdfopen /bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_CRU/pr_CRU_TIMAVG_SM_'SESItxt.SESI'_SMS_2014_interp.nc'
         varic1='pre'
         factor1=1
         'sdfopen /bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_ERA/pr_ERA40_TIMAVG_SM_'SESItxt.SESI'_SMS_2014_interp.nc'
         varic2='pr'
         factor2=86400
    TITLEtxt='scorr_CRUvsERA40'
    endif
    if (COMBI=2)
         'sdfopen /bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_CRU/pr_CRU_TIMAVG_SM_'SESItxt.SESI'_SMS_2014_interp.nc'
         varic1='pre'
         factor1=1
         'sdfopen /bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_RCM/pr_MOD_ENSAVG_TIMAVG_SM_'SESItxt.SESI'_SMS_2014_interp.nc'
         varic2='pr'
         factor2=86400
    TITLEtxt='scorr_CRUvsRCM'
    endif
    if (COMBI=3)
         'sdfopen /bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_ERA/pr_ERA40_TIMAVG_SM_'SESItxt.SESI'_SMS_2014_interp.nc'
         varic1='pr'
         factor1=86400
         'sdfopen /bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_RCM/pr_MOD_ENSAVG_TIMAVG_SM_'SESItxt.SESI'_SMS_2014_interp.nc'
         varic2='pr'
         factor2=86400
    TITLEtxt='scorr_ERA40vsRCM'
    endif

    'sdfopen /bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_EOF/maska_03.nc'

*------------------------------------------------------------
* Plot over Europe
*------------------------------------------------------------

say '------------------------------------------------------------------------->'FILE
      'set dfile 1'
      'define  totable1=scorr('varic1'.1(z=1,t=1)*'factor1'*pr.3(t=1,z=1),'varic2'.2(z=1,t=1)*'factor2'*pr.3(t=1,z=1),lon=-25,lon=35,lat=35.5,lat=72)'
      'define  totable2=scorr('varic1'.1(z=1,t=1)*'factor1'*pr.3(t=1,z=1),'varic2'.2(z=1,t=1)*'factor2'*pr.3(t=1,z=1),lon=-25,lon=35,lat=35.5,lat=50)'
      'define  totable3=scorr('varic1'.1(z=1,t=1)*'factor1'*pr.3(t=1,z=1),'varic2'.2(z=1,t=1)*'factor2'*pr.3(t=1,z=1),lon=-25,lon=35,lat=50,lat=72)'

      'fprintf.gs totable1 'TITLEtxt'_domain_all_'SESItxt.SESI'.txt %g 1'
      'fprintf.gs totable2 'TITLEtxt'_domain_SSS_'SESItxt.SESI'.txt %g 1'
      'fprintf.gs totable3 'TITLEtxt'_domain_NNN_'SESItxt.SESI'.txt %g 1'
*------------------------------------------------------------
* Print plot 
*------------------------------------------------------------

"quit"
EOF

#------------------------------------------------------------
# Run opengrads 
#------------------------------------------------------------

grads   -lc "DO.gs"
     rm -vf  DO.gs

done #SESI
done #COMBI
