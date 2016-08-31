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

*----------------------------------------------------------------------------------
    'sdfopen ./zona/EOF_'SESItxt.SESI'.nc'
    if (COMBI=1)
         varic1='CRU_EOF'
         varic2='ERA_EOF'
    TITLEtxt='scorr_CRUvsERA40'
    endif
    if (COMBI=2)
         varic1='CRU_EOF'
         varic2='RCM_EOF'
    TITLEtxt='scorr_CRUvsMODENS'
    endif
    if (COMBI=3)
         varic1='ERA_EOF'
         varic2='RCM_EOF'
    TITLEtxt='scorr_ERA40vsMODENS'
    endif


say '------------------------------------------------------------------------->'FILE
      'define  totable1=scorr('varic1'(z=1,t=1),'varic2'(z=1,t=1),lon=-25,lon=35,lat=35.5,lat=72)'
      'define  totable2=scorr('varic1'(z=1,t=2),'varic2'(z=1,t=2),lon=-25,lon=35,lat=35.5,lat=72)'
      'define  totable3=scorr('varic1'(z=1,t=3),'varic2'(z=1,t=3),lon=-25,lon=35,lat=35.5,lat=72)'

     'fprintf.gs totable1 EOFs_1_'TITLEtxt'_domain_all_'SESItxt.SESI'.txt %g 1'
     'fprintf.gs totable2 EOFs_2_'TITLEtxt'_domain_all_'SESItxt.SESI'.txt %g 1'
     'fprintf.gs totable3 EOFs_3_'TITLEtxt'_domain_all_'SESItxt.SESI'.txt %g 1'
*------------------------------------------------------------
* Print plot 
*------------------------------------------------------------

"quit"
EOF

#------------------------------------------------------------
# Run opengrads 
#------------------------------------------------------------

/home/ivan/Programs/grads-2.0.2.oga.2/Classic/bin/grads  -blc "DO.gs"
rm -vf DO.gs

done #SESI
done #COMBI
