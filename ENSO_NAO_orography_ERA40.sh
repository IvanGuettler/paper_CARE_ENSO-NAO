#!/bin/bash

RESO=150
for VAR in 4 5; do

#---------------------------------------------------------------------

cat > addLines1 << EOF
function addLines1
     VAR=${VAR}
     if (VAR=1);  'set clevs   100 300 500 700 1000 1200 1500 1800 2000';  endif
     if (VAR=2);  'set clevs   100 300 500 700 1000 1200 1500 1800 2000';  endif
     if (VAR=3);  'set clevs   100 300 500 700 1000 1200 1500 1800 2000';  endif
     if (VAR=4);  'set clevs   -75 -60 -45 -30 -15 15 30 45 60 75'      ;  endif
     if (VAR=5);  'set clevs   -75 -60 -45 -30 -15 15 30 45 60 75'      ;  endif
return
EOF
cat > addLines2 << EOF
function addLines2
     VAR=${VAR}
     if (VAR=1);  'set clevs   100 300 500 700 1000 1200 1500 1800 2000';  endif
     if (VAR=2);  'set clevs   100 300 500 700 1000 1200 1500 1800 2000';  endif
     if (VAR=3);  'set clevs   100 300 500 700 1000 1200 1500 1800 2000';  endif
     if (VAR=4);  'set clevs   -75 -60 -45 -30 -15 15 30 45 60 75'      ;  endif
     if (VAR=5);  'set clevs   -75 -60 -45 -30 -15 15 30 45 60 75'      ;  endif
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
*Generalno
varTXT.1='ERA40 orography on 1.125deg x 1.125deg grid (m)';
varTXT.2='ERA40 orography on 0.5  deg x 0.5  deg grid (m)';
varTXT.3='ERA40 orography on 0.5  deg x 0.5  deg grid (nearest neigh. from 1.125deg x 1.125deg grid) (m)';
varTXT.4='ERA40 orography (1.125x1.125)nn - (0.5x0.5)   (m)';
varTXT.5='ERA40 orography (1.125x1.125)   - (0.5x0.5)nn (m)';

*--------------------------------------------------------------------------------------------------------
    if (VAR=1)
     varic1='z'
    'sdfopen /home/ivan/OBS/ERA40/netcdf-atls00-20141114145833-6511-11084.nc'
    endif
    if (VAR=2)
     varic1='z'
*v1  varic2='pre'
*v1 'sdfopen /home/ivan/OBS/ERA40/netcdf-atls00-20141114145833-6511-11084.nc'
*v1 'sdfopen /home/ivan/OBS/CRU/cru_ts_3_10_01.1901.2009.pre.dat_nc4.nc'
*v2 Napravio sam provjeru. Daju v1&v2 isto polje. Lijepo :)
    'sdfopen /home/ivan/OBS/ERA40/netcdf-atls00-20141114145833-6511-11084_remapbil05.nc'
    endif
    if (VAR=3)
     varic1='z'
    'sdfopen /home/ivan/OBS/ERA40/netcdf-atls00-20141114145833-6511-11084_remapnn05.nc'
    endif
    if (VAR=4)
     varic1='z'
     varic2='z'
    'sdfopen /home/ivan/OBS/ERA40/netcdf-atls00-20141114145833-6511-11084_remapnn05.nc'
    'sdfopen /home/ivan/OBS/ERA40/netcdf-atls00-20141114145833-6511-11084_remapbil05.nc'
    endif
    if (VAR=5)
     varic1='z'
     varic2='z'
    'sdfopen /home/ivan/OBS/ERA40/netcdf-atls00-20141114145833-6511-11084.nc'
    'sdfopen /home/ivan/OBS/ERA40/netcdf-atls00-20141114145833-6511-11084_remapbil05_remapnn1125.nc'
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
*v1   'define toplot1=lterp('varic1'(t=1,z=1)/9.81,'varic2'.2(t=1,z=1))'
      if (VAR<4)
          'define toplot1='varic1'(t=1,z=1)/9.81'
          'set gxout shaded'
      endif
      if (VAR>3)
          'define toplot1=('varic1'.1(t=1,z=1)-'varic2'.2(t=1,z=1))/9.81'
          'set gxout grfill'
      endif
      'run addPlottingstuff'
      if (VAR<4)
          'run addNewcol 1b';
      endif
      if (VAR>3)
          'run addNewcol 3b';
      endif

      'run addLines1';
      'd toplot1'
      'run addColbar 1'

      if (VAR<4)
         'set gxout contour'
         'run addLines2'
         'd toplot1'
      endif

      if (VAR<4)
       'draw title 'varTXT.VAR' \ clevs 100 300 500 700 1000 1200 1500 1800 2000'
      endif
      if (VAR>3)
       'draw title 'varTXT.VAR' \ clevs  15 30 45 60 75'
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

/home/ivan/Programs/grads-2.0.2.oga.2/Classic/bin/grads  -lbc "DO.gs"

FILE=ERA40_OROGRAPHY_VAR${VAR}


gxeps -i     fig.gmf -o ${FILE}.eps
rm -vf DO.gs fig.gmf addLines* addPlottingstuff

convert -density ${RESO} -rotate "90<" ${FILE}.eps ${FILE}.jpg
rm ${FILE}.eps

done #VAR


