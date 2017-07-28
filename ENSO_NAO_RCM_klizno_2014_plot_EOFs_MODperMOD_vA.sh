#!/bin/bash

RESO=150

for  VAR  in 1                          ; do
for SESI  in 1 7         		; do
#for SESI in 1 2 3 4 5 6 7 8 9 10 11 12 ; do
#for EOFS in 1 2 3 4 5                  ; do
for EOFS  in 1                          ; do

#---------------------------------------------------------------------

cat > addLines1 << EOF
function addLines1
     VAR=${VAR}
     SESI=${SESI}
     if (VAR=1);  'set clevs    -1.6 -1.2 -0.8 -0.4 -0.1 0.1 0.4 0.8 1.2 1.6';    endif;
*    if (VAR=1);  'set clevs    -2 -1.5 -1 -0.5 -0.1 0.1 0.5 1 1.5 2';            endif;
return
EOF
cat > addLines2 << EOF
function addLines2
     VAR=${VAR}
     SESI=${SESI}
     if (VAR=1);  'set clevs    -1.6 -1.2 -0.8 -0.4 -0.1 0.1 0.4 0.8 1.2 1.6';    endif;
*    if (VAR=1);  'set clevs    -2 -1.5 -1 -0.5 -0.1 0.1 0.5 1 1.5 2';            endif;
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
SESI=${SESI}
EOFS=${EOFS}

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

    'sdfopen   /home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2014_pr/FILES_EOF/EOF_'SESItxt.SESI'_MODperMOD_vA.nc'

if (VAR=1);
     varic1='rcm_eof'
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
      'define toplot1='varic1'.1(z=1,t='EOFS')'
      'set gxout shaded'
      'run addPlottingstuff'
      'run addNewcol 3b';
      'run addLines1';
*dodao sam x(-1) radi usporedivosti sa CRU i ERA40
      'd toplot1*(-1)'
      'run addColbar 1'

      'set gxout contour'
      'run addLines2'
      if (VAR>1); 'set clab on'; endif
*dodao sam x(-1) radi usporedivosti sa CRU i ERA40
      'd toplot1*(-1)'

*      if (VAR=1); 'draw title RCM EOF'EOFS' 'SESItxt.SESI' \ 0.1 0.4 0.8 1.2 1.6'; endif
       if (VAR=1); 'draw title ENS EOF'EOFS' 'SESItxt.SESI                        ; endif

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
FILE=RCM_${SESItxt[${SESI}]}_pr_EOF${EOFS}_MODperMOD_vA
fi

gxeps -i     fig.gmf -o ${FILE}.eps
rm -vf DO.gs fig.gmf addLines* addPlottingstuff

convert -density ${RESO} -rotate "90<" ${FILE}.eps ${FILE}.jpg
rm ${FILE}.eps

done #EOFS
done #SESI
done #VAR

