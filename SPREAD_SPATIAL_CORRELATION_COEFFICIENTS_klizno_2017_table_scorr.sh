#!/bin/bash

for OBOR  in 1 2                             ; do
for SESI  in 1 2 3 4 5 6 7 8 9 10 11 12      ; do

#---------------------------------------------------------------------

cat > DO.gs << EOF

OBOR=${OBOR}
SESI=${SESI}

TIPtxt.1='pr'
TIPtxt.2='prc'

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
         'sdfopen /home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/ENSEMBLES_orography.nc'
         varic1='SpreadOrography'
         factor1=1

         if (OBOR=1);
         'sdfopen /home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr_MOD/FILES_RCM/pr_MOD_ENSSPREAD_TIMAVG_SM_'SESItxt.SESI'_SMS_2014.nc'
         varic2='pr'
         factor2=86400
         endif
         if (OBOR=2);
         'sdfopen /home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2016_prc/FILES_RCM/prc_MOD_ENSSPREAD_TIMAVG_SM_'SESItxt.SESI'_SMS_2014.nc'
         varic2='prc'
         factor2=86400
         endif
         
         'sdfopen /bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_EOF/maska_03.nc'

*------------------------------------------------------------
* Plot over Europe
*------------------------------------------------------------

say '------------------------------------------------------------------------->'FILE
      'set dfile 1'
      'define  totable1=scorr(lterp('varic1'.1(z=1,t=1)*'factor1',pr.3(t=1,z=1))*pr.3(t=1,z=1) ,lterp('varic2'.2(z=1,t=1)*'factor2',pr.3(t=1,z=1))*pr.3(t=1,z=1),lon=-25,lon=35,lat=35.5,lat=72)'
      'define  totable2=scorr(lterp('varic1'.1(z=1,t=1)*'factor1',pr.3(t=1,z=1))*pr.3(t=1,z=1) ,lterp('varic2'.2(z=1,t=1)*'factor2',pr.3(t=1,z=1))*pr.3(t=1,z=1),lon=-25,lon=35,lat=35.5,lat=50)'
      'define  totable3=scorr(lterp('varic1'.1(z=1,t=1)*'factor1',pr.3(t=1,z=1))*pr.3(t=1,z=1) ,lterp('varic2'.2(z=1,t=1)*'factor2',pr.3(t=1,z=1))*pr.3(t=1,z=1),lon=-25,lon=35,lat=50.0,lat=72)'

      'fprintf.gs totable1 SPREAD_SCORR_domain_all_'TIPtxt.OBOR'_'SESItxt.SESI'.txt %g 1'
      'fprintf.gs totable2 SPREAD_SCORR_domain_SSS_'TIPtxt.OBOR'_'SESItxt.SESI'.txt %g 1'
      'fprintf.gs totable3 SPREAD_SCORR_domain_NNN_'TIPtxt.OBOR'_'SESItxt.SESI'.txt %g 1'
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
done #OBOR
