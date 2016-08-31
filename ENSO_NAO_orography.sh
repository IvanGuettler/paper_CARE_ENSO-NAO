#!/bin/bash

RESO=150
for VAR in 1 2 ; do

#---------------------------------------------------------------------

cat > addLines1 << EOF
function addLines1
     VAR=${VAR}
     if (VAR=1);  'set clevs   100 250 500 750 1000 1250 1500 1750 2000';  endif
     if (VAR=2);  'set clevs   10  25  50  75  100  125  150  175  200';   endif
*    if (VAR=1);  'set clevs   100 300 500 700 1000 1200 1500 1800 2000';  endif
*    if (VAR=2);  'set clevs   10 30 50 70 100 120 150 180 200';           endif
return
EOF
cat > addLines2 << EOF
function addLines2
     VAR=${VAR}
     if (VAR=1);  'set clevs   100 250 500 750 1000 1250 1500 1750 2000';  endif
     if (VAR=2);  'set clevs   10  25  50  75  100  125  150  175  200';   endif
*    if (VAR=1);  'set clevs   100 300 500 700 1000 1200 1500 1800 2000';  endif
*    if (VAR=2);  'set clevs   10 30 50 70 100 120 150 180 200';           endif
return
EOF

#---------------------------------------------------------------------

cat > addPlottingstuff << EOF
function plottingstuff
    "set grads off"
    "set frame on"
    "set clopts 1 3 0.11"
    "set clab off"
    "set string 1 l 5"
    "set font 4"
    "set annot 1 5"
    "set xlint 10"
    "set ylint 10"
    "set strsiz 0.2 0.2"
    "set xlopts 1 1 0.16"
    "set ylopts 1 1 0.16"
    "set cthick 1"
return
EOF

#---------------------------------------------------------------------

cat > DO.gs << EOF

VAR=${VAR}
*Generalno
*varTXT.1='ENSEMBLES mean orography (m)';
*varTXT.2='ENSEMBLES orography spread (m)';
varTXT.1='ENS mean orography (m)';
varTXT.2='ENS orography spread (m)';

*--------------------------------------------------------------------------------------------------------
*---DHMZ stolno
    'sdfopen /home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/ENSEMBLES_orography.nc'
*Ivan 2016-04-24
    'sdfopen /home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_CRU/pr_CRU_TIMAVG_SM_DJF_SMS_2014.nc'

*---DHMZ stolno
    if (VAR=1)
     varic1='MeanOrography'
    endif
    if (VAR=2)
     varic1='SpreadOrography'
    endif


*------------------------------------------------------------
* Plot over Europe
*------------------------------------------------------------

LONstart=-23.875; LONend=45.375;
LATstart= 29.125; LATend=71.375;
'set lon 'LONstart' 'LONend
'set lat 'LATstart' 'LATend

say '------------------------------------------------------------------------->'FILE
      'set dfile 1'
      if (VAR=1)
*Ivan 2016-04-24      'define toplot1='varic1'(t=1,z=1)'
                      'define toplot1=lterp('varic1'(t=1,z=1),pre.2)'
      endif
      if (VAR=2)
*Ivan 2016-04-24      'define toplot1=smth9('varic1'(t=1,z=1))'
                      'define toplot1=lterp('varic1'(t=1,z=1),pre.2)'
      endif
      'set gxout shaded'
      'run addPlottingstuff'
      'run addNewcol 1b';
      'run addLines1';
      'd toplot1'
      'run addColbar 1'

      'set gxout contour'
      'run addLines2'
      'd toplot1'

      if (VAR=1)
*Cedo      'draw title 'varTXT.VAR' \ clevs 100 300 500 700 1000 1200 1500 1800 2000'
*          'draw title 'varTXT.VAR' \ clevs 100 250 500 750 1000 1250 1500 1750 2000'
           'draw title 'varTXT.VAR
      endif
      if (VAR=2)
*Cedo 2016-03-01 Smoothed removed       'draw title 'varTXT.VAR' \ clevs 10 30 50 70 100 120 150 180 200; smoothed'
*Cedo      'draw title 'varTXT.VAR' \ clevs 10 30 50 70 100 120 150 180 200'
*          'draw title 'varTXT.VAR' \ cles 10  25  50  75  100  125  150  175  200'
           'draw title 'varTXT.VAR
      endif


*------------------------------------------------------------
* Print plot 
*------------------------------------------------------------

"enable print fig.gmf"
"print"
"disable print"
"quit"
EOF

#------------------------------------------------------------
# Run opengrads 
#------------------------------------------------------------

grads  -lbc "DO.gs"

FILE=OROGRAPHY_VAR${VAR}_2016


gxeps -i     fig.gmf -o ${FILE}.eps
rm -vf DO.gs fig.gmf addLines* addPlottingstuff

convert -density ${RESO} -rotate "90<" ${FILE}.eps ${FILE}.jpg
rm ${FILE}.eps

done #VAR


