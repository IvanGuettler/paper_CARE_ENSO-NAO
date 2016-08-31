#!/bin/bash
# 2014-07-07 sve pretvaramo u smth9

RESO=150

#for VAR  in 1 2 3 4      ; do
for VAR   in 1            ; do
for GGG   in 2 4          ; do
for SESI  in 1            ; do

#---------------------------------------------------------------------

cat > addLines1 << EOF
function addLines1
     VAR=${VAR}
     SESI=${SESI}
      if (VAR=1);  'set clevs    1 2 3 4 5 6 7 8 9'                    ;  endif;
      if (VAR=2);  'set clevs    10   20   30   40  50  60  70  80  90';  endif;
      if (VAR=3);  'set clevs    10   20   30   40  50  60  70  80  90';  endif;
      if (VAR=4);  'set clevs    10   20   30   40  50  60  70  80  90';  endif;
return
EOF
cat > addLines2 << EOF
function addLines2
     VAR=${VAR}
     SESI=${SESI}
      if (VAR=1);  'set clevs    1 2 3 4 5 6 7 8 9'                                ;  endif;
      if (VAR=2);  'set clevs    10   20   30   40  50  60  70  80  90 100 150 200';  endif;
      if (VAR=3);  'set clevs    10   20   30   40  50  60  70  80  90 100 150 200';  endif;
      if (VAR=4);  'set clevs    10   20   30   40  50  60  70  80  90 100 150 200';  endif;
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

SESI=${SESI}
GGGG=${GGG}
VAR=${VAR}
*Generalno
varTXT.1=' R (mm/day)';
varTXT.2=' zg500hPa (m)';
varTXT.3=' zg300hPa (m)';
VARtxt.1='pr'
VARtxt.2='zg'
VARtxt.3='zg'

SESItxt.1='JFM'
SESItxt.2='AMJ'


if (GGGG=1);
TYPEtxt.1='ENSO ++  , NAO 0'
TYPEtxt.2='ENSO +   , NAO 0'
TYPEtxt.3='ENSO ++/+, NAO 0'
TYPEtxt.4='ENSO -   , NAO 0'
TYPEtxt.5='ENSO --  , NAO 0'
TYPEtxt.6='ENSO --/-, NAO 0'
endif
if (GGGG=2);
TYPEtxt.1='ENSO ++  , NAO all'
TYPEtxt.2='ENSO +   , NAO all'
TYPEtxt.3='ENSO ++/+, NAO all'
TYPEtxt.4='ENSO -   , NAO all'
TYPEtxt.5='ENSO --  , NAO all'
TYPEtxt.6='ENSO --/-, NAO all'
endif
if (GGGG=3);
TYPEtxt.1='ENSO 0 , NAO ++'
TYPEtxt.2='ENSO 0 , NAO +'
TYPEtxt.3='ENSO 0 , NAO ++/+'
TYPEtxt.4='ENSO 0 , NAO -'
TYPEtxt.5='ENSO 0 , NAO --'
TYPEtxt.6='ENSO 0 , NAO --/-'
endif
if (GGGG=4);
TYPEtxt.1='ENSO all , NAO ++'
TYPEtxt.2='ENSO all , NAO +'
TYPEtxt.3='ENSO all , NAO ++/+'
TYPEtxt.4='ENSO all , NAO -'
TYPEtxt.5='ENSO all , NAO --'
TYPEtxt.6='ENSO all , NAO --/-'
endif
if (GGGG=5);
TYPEtxt.1='ENSO ++  , NAO all nonzero'
TYPEtxt.2='ENSO +   , NAO all nonzero'
TYPEtxt.3='ENSO ++/+, NAO all nonzero'
TYPEtxt.4='ENSO -   , NAO all nonzero'
TYPEtxt.5='ENSO --  , NAO all nonzero'
TYPEtxt.6='ENSO --/-, NAO all nonzero'
endif
if (GGGG=6);
TYPEtxt.1='ENSO all  nonzero , NAO ++'
TYPEtxt.2='ENSO all  nonzero , NAO +'
TYPEtxt.3='ENSO all  nonzero , NAO ++/+'
TYPEtxt.4='ENSO all  nonzero , NAO -'
TYPEtxt.5='ENSO all  nonzero , NAO --'
TYPEtxt.6='ENSO all  nonzero , NAO --/-'
endif


*--------------------------------------------------------------------------------------------------------
TIT=1
while TIT<=6
FILE=TIT+6*(GGGG-1)
    if (VAR=1); 'sdfopen /home/guettler/bonus_disk/MODELS/ENSEMBLES/DIR_ANALIZA_ENSO_NAO/2016_pr/FILES_RCM/pr_MOD_ENSAVG_SM_'SESItxt.SESI'_TIP'FILE'_spread3_SMS_2016.nc';         endif
    TIT=TIT+1
endwhile
if (VAR=1);
     varic1='pr'
    offset1=0
    factor1=86400
endif

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

TIT=1
while TIT<=6
say '------------------------------------------------------------------------->'FILE
      'set dfile 'TIT
      'run page.gs 'PAGE.TIT' 23'
      'define toplot1=smth9('varic1'.'TIT'(z=1,t=1))*'factor1'+'offset1
      'set gxout shaded'
      'run addPlottingstuff'
*     'run addNewcol 62';
      'run addNewcol 1b';
      'run addLines1';   
      'd toplot1'
      'run addColbar 1'

      'set gxout contour'
      'run addLines2'
      if (VAR=2); 'set clab on'; endif
      if (VAR=3); 'set clab on'; endif
      'd toplot1'

if (VAR=1); 'draw title RCM pr (mm/day) 'SESItxt.SESI' 'TYPEtxt.TIT' spread  \ clevs 1 2 3 4 5 6 7 8 9; smoothed';                          endif
TIT=TIT+1
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

SESItxt[1]='JFM'
SESItxt[2]='AMJ'

if [ ${VAR} == 1 ]; then
FILE=RCM_GROUP${GGG}_${SESItxt[${SESI}]}_pr_spread3_smth9
fi

gxeps -i     fig.gmf -o ${FILE}.eps
rm -vf DO.gs fig.gmf addLines* addPlottingstuff

convert -density ${RESO} -rotate "90<" ${FILE}.eps ${FILE}.jpg
rm ${FILE}.eps

done #SESI
done #GGG
done #VAR

