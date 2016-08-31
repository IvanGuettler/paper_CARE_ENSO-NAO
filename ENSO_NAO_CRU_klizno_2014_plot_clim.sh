#!/bin/bash

RESO=150
VAR=1

for SESI  in 1 2 3 4 5 6 7 8 9 10 11 12      ; do

#---------------------------------------------------------------------

cat > addLines1 << EOF
function addLines1
     VAR=${VAR}
     SESI=${SESI}
     if (VAR=1);  'set clevs   0.5 1 2 3 4 5 6 9 12';  endif
return
EOF
cat > addLines2 << EOF
function addLines2
     VAR=${VAR}
     SESI=${SESI}
     if (VAR=1);  'set clevs   0.5 1 2 3 4 5 6 9 12';  endif
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

SESI=${SESI}
*Generalno
varTXT.1=' R (mm/day)';
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

*--------------------------------------------------------------------------------------------------------
*---DHMZ stolno
    'sdfopen /home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_CRU/pr_CRU_TIMAVG_SM_'SESItxt.SESI'_SMS_2014.nc'
*---DHMZ
     varic1='pre'
    offset1=0
    factor1=1


*------------------------------------------------------------
* Plot over Europe
*------------------------------------------------------------

LONstart=-23.875; LONend=45.375;
LATstart= 29.125; LATend=71.375;
'set lon 'LONstart' 'LONend
'set lat 'LATstart' 'LATend

PAGE.1=13
PAGE.2=12
PAGE.3=11

PAGE.4=22
PAGE.5=23
PAGE.6=21

say '------------------------------------------------------------------------->'FILE
      'set dfile 1'
*     'run page.gs 'PAGE.TIT' 23'
      'define toplot1=('varic1'.1(z=1,t=1))*'factor1'+'offset1
      'set gxout shaded'
      'run addPlottingstuff'
      'run addNewcol 1b';
      'run addLines1';
      'd toplot1'
      'run addColbar 1'

      'set gxout contour'
      'run addLines2'
      'd toplot1'

       'draw title CRU pr (mm/day) 'SESItxt.SESI' climatology \ clevs 0.5 1 2 3 4 5 6 9 12'


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

SESItxt[1]='01'
SESItxt[2]='02'
SESItxt[3]='03'
SESItxt[4]='04'
SESItxt[5]='05'
SESItxt[6]='06'
SESItxt[7]='07'
SESItxt[8]='08'
SESItxt[9]='09'
SESItxt[10]='10'
SESItxt[11]='11'
SESItxt[12]='12'

FILE=CRU_${SESItxt[${SESI}]}_pr_climatology


gxeps -i     fig.gmf -o ${FILE}.eps
rm -vf DO.gs fig.gmf addLines* addPlottingstuff

convert -density ${RESO} -rotate "90<" ${FILE}.eps ${FILE}.jpg
rm ${FILE}.eps

done #SESI


