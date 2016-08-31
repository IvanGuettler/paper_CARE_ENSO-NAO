#!/bin/bash

RESO=150

for  VAR  in 1      ; do
for SESI  in 1 2 3 4 5 6 7 8 9 10 11 12       ; do

#---------------------------------------------------------------------

cat > addLines1 << EOF
function addLines1
     VAR=${VAR}
     SESI=${SESI}
     if (VAR=1);  'set clevs    -5   -2   -1 -0.5 -0.2 0.2 0.5   1   2     5';    endif;
return
EOF
cat > addLines2 << EOF
function addLines2
     VAR=${VAR}
     SESI=${SESI}
     if (VAR=1);  'set clevs    -5   -2   -1 -0.5 -0.2 0.2 0.5   1   2     5';    endif;
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
    "set font 0"
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

    'sdfopen ./2014_pr/pr_MOD_ENSAVG_TIMAVG_SM_'SESItxt.SESI'_SMS_2014.nc'
    'sdfopen ./2014_pr/pr_ERA40_TIMAVG_SM_'SESItxt.SESI'_SMS_2014.nc'
    'sdfopen ./2014_pr/pr_CRU_TIMAVG_SM_'SESItxt.SESI'_SMS_2014.nc'

if (VAR=1);
     varic1='pr'
    offset1=0
    factor1=86400
     varic2='pr'
    offset2=0
    factor2=86400
     varic3='pre'
    offset3=0
    factor3=1
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
      'define toplot1=('varic1'.1(z=1,t=1))*'factor1'+'offset1
      'define toplot2=('varic2'.2(z=1,t=1))*'factor2'+'offset2
      'define toplot3=('varic3'.3(z=1,t=1))*'factor3'+'offset3
      'set gxout shaded'
      'run addPlottingstuff'
      'run addNewcol 3b';
      'run addLines1';
      'd smth9(lterp(toplot1,toplot3)-lterp(toplot2,toplot3))'
      'run addColbar 1'

      'set gxout contour'
      'run addLines2'
      if (VAR>1); 'set clab on'; endif
      'd smth9(lterp(toplot1,toplot3)-lterp(toplot2,toplot3))'

      if (VAR=1); 'draw title RCM-ERA40 pr (mm/day) 'SESItxt.SESI' \ clevs 0.2 0.5 1 2 5; smoothed'; endif

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

/home/ivan/Programs/grads-2.0.2.oga.2/Classic/bin/grads -lbc "DO.gs"

#SESItxt[1]='JFM'
#SESItxt[2]='AMJ'
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

if [ ${VAR} == 1 ]; then
FILE=RCM_${SESItxt[${SESI}]}_pr_climatology_errors_vsERA40
fi

gxeps -i     fig.gmf -o ${FILE}.eps
rm -vf DO.gs fig.gmf addLines* addPlottingstuff

convert -density ${RESO} -rotate "90<" ${FILE}.eps ${FILE}.jpg
rm ${FILE}.eps

done #SESI
done #VAR


