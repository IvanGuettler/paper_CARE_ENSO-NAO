#!/bin/bash

RESO=150

for IND  in 1 2       ; do
for VAR  in 1         ; do
for SESI in 1 2       ; do
for MEAN in 1         ; do

#---------------------------------------------------------------------

cat > addLines1 << EOF
function addLines1
     VAR=${VAR}
     if (VAR=1);  'set clevs -1 -0.5 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.5 1';  endif
     if (VAR=2);  'set clevs -40 -30 -20 -10 -5 5 10 20 30 40'        ;  endif
return
EOF
cat > addLines2 << EOF
function addLines2
     VAR=${VAR}
     if (VAR=1);  'set clevs 0.5 1 1.5 2 2.5 3 3.5 4 4.5';  endif
     if (VAR=2);  'set clevs 10 20 30 40 50 60 70 80 90 ';  endif
return
EOF

#---------------------------------------------------------------------

cat > addPlottingstuff << EOF
function plottingstuff
    "set grads off"
    "set frame on"
    "set clopts 1 3 0.11"
    "set string 1 l 5"
    "set font 0"
    "set annot 1 5"
    "set xlint 10"
    "set ylint 10"
    "set strsiz 0.2 0.2"
    "set xlopts 1 1 0.16"
    "set ylopts 1 1 0.16"
return
EOF

#---------------------------------------------------------------------

cat > DO.gs << EOF

VAR=${VAR}
IND=${IND}
SESI=${SESI}
MEAN=${MEAN}

*Generalno
varTXT.1=' R (mm/day)';
varTXT.2=' zg500 (m)'; 

VARtxt.1='pr'
VARtxt.2='zg500'
SESItxt.1='JFM'
SESItxt.2='AMJ'
INDtxt.1='ENSO'
INDtxt.2='NAO'
MEANtxt.1='All'
MEANtxt2.1='All'
MEANtxt.2=INDtxt.IND'plus'
MEANtxt2.2=INDtxt.IND'minus'

*--------------------------------------------------------------------------------------------------------
if (VAR=1)
    'sdfopen  ./DIR_RCM/'VARtxt.VAR'_MOD_ENSAVG_SM_'SESItxt.SESI'_All'INDtxt.IND'plus_anomalyVS'MEANtxt.MEAN'_SMS.nc'
    'sdfopen  ./DIR_RCM/'VARtxt.VAR'_MOD_ENSAVG_SM_'SESItxt.SESI'_All'INDtxt.IND'minus_anomalyVS'MEANtxt2.MEAN'_SMS.nc'
*    'sdfopen  ./DIR_RCM/'VARtxt.VAR'_MOD_ENSAVG_SM_'SESItxt.SESI'_All'INDtxt.IND'plus_SquaredAnomalyVS'MEANtxt.MEAN'_SMS.nc'
*    'sdfopen  ./DIR_RCM/'VARtxt.VAR'_MOD_ENSAVG_SM_'SESItxt.SESI'_All'INDtxt.IND'minus_SquaredAnomalyVS'MEANtxt2.MEAN'_SMS.nc'
     varic1='pr'
    offset1=0
    factor1=86400
endif
if (VAR=2)
    'sdfopen  ./DIR_'INDtxt.IND'plus_'VARtxt.VAR'/'VARtxt.VAR'_MOD_ENSAVG_SM_'SESItxt.SESI'_All'INDtxt.IND'plus_anomalyVS'MEANtxt.MEAN'.nc'
    'sdfopen  ./DIR_'INDtxt.IND'minus_'VARtxt.VAR'/'VARtxt.VAR'_MOD_ENSAVG_SM_'SESItxt.SESI'_All'INDtxt.IND'minus_anomalyVS'MEANtxt2.MEAN'.nc'
*    'sdfopen  ./DIR_'INDtxt.IND'plus_'VARtxt.VAR'/'VARtxt.VAR'_MOD_ENSAVG_SM_'SESItxt.SESI'_All'INDtxt.IND'plus_SquaredAnomalyVS'MEANtxt.MEAN'.nc'
*    'sdfopen  ./DIR_'INDtxt.IND'minus_'VARtxt.VAR'/'VARtxt.VAR'_MOD_ENSAVG_SM_'SESItxt.SESI'_All'INDtxt.IND'minus_SquaredAnomalyVS'MEANtxt2.MEAN'.nc'
     varic1='zg'
    offset1=0
    factor1=1
endif

*--------------------------------------------------------------------------------------------------------
*LONstart=-32; LONend=62;
*LATstart=29;  LATend=73;
*'set lon 'LONstart' 'LONend
*'set lat 'LATstart' 'LATend

*------------------------------------------------------------
* Plot
*------------------------------------------------------------
FILE=1
while FILE<=2
say '------------------------------------------------------------------------->'FILE
      'set dfile 'FILE
      'run addPlottingstuff'
      'run addPage q'FILE
      'define toplot1=('varic1'.'FILE'(z=1,t=1))*'factor1'+'offset1
      'set gxout shaded'
      if (FILE<3); 'run addNewcol 62'; endif
      if (FILE>2); 'run addNewcol 1';  endif
      if (FILE<3); 'run addLines1';    endif
      if (FILE>2); 'run addLines2';    endif
      'd toplot1'
      'run addColbar 1'
      'set gxout contour'
      if (FILE<3); 'run addLines1'; endif
      if (FILE>2); 'run addLines2'; endif
      'd toplot1'

      if (FILE=1); 'draw title ENSEMBLES 'varTXT.VAR' 'SESItxt.SESI' 'INDtxt.IND'+ composite'; endif
      if (FILE=2); 'draw title ENSEMBLES 'varTXT.VAR' 'SESItxt.SESI' 'INDtxt.IND'- composite';   endif
      if (FILE=3); 'draw title ENSEMBLES 'varTXT.VAR' 'SESItxt.SESI' 'INDtxt.IND'+ spread'; endif
      if (FILE=4); 'draw title ENSEMBLES 'varTXT.VAR' 'SESItxt.SESI' 'INDtxt.IND'- spread';   endif
FILE=FILE+1
endwhile
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

grads -lbc "DO.gs"

INDtxt[1]='ENSO'
INDtxt[2]='NAO'
SESItxt[1]='JFM'
SESItxt[2]='AMJ'
VARtxt[1]='pr'
VARtxt[2]='zg500'

FILE=${INDtxt[${IND}]}_${SESItxt[${SESI}]}_${VARtxt[${VAR}]}_vsMEAN${MEAN}


gxeps -i     fig.gmf -o ${FILE}.eps
rm -vf DO.gs fig.gmf addLines* addPlottingstuff

convert -density ${RESO} -rotate "90<" ${FILE}.eps ${FILE}.jpg
rm ${FILE}.eps

done #IND
done #VAR
done #SESI
done #MEAN
