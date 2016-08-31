function newcol (icol)

*       newcol : GrADS script to set the colour scale
*
*       Command : run newcol <icol>
*       where:  icol   = colour scale index
*               1 : warm palette only (positive fld, e.g. rainfall)
*              -1 : warm palette only, reverse order
*               2 : cold palette only (negative fld)
*              -2 : cold palette only, reverse order
*               3 : anomaly scale, no shading in central interval 
*               6 : brown-green palette
*               7 : blue-red palette


* Warm palette (pale yellow to dark red); white is the first colour band

"set rgb 20 230 230 230";* gray
"set rgb 21 255 255 255";* white
"set rgb 22 255 255 170";* 
"set rgb 23 255 255  10";* 
"set rgb 24 255 220  31";* 
"set rgb 25 255 192  60";
"set rgb 26 240 130  41";* 
"set rgb 27 230 100   0";* 
"set rgb 28 255   0   0";* 
"set rgb 29 240   0   0";*
"set rgb 30 240   0  70";*

* Cold palette (light blue to dark blue); white is the first colour band

"set rgb 31 255 255 255";* white
"set rgb 32 225 255 255"
"set rgb 33 180 240 250"
"set rgb 34 150 210 250"
"set rgb 35 120 185 250"
"set rgb 36  80 165 245"
"set rgb 37  60 150 245"
"set rgb 38  40 130 240"
"set rgb 39  30 110 235"
"set rgb 40  20 100 210"

* brown-green pallete
*brown
'set rgb 41 160 82 45'
'set rgb 42 204 132 51'
'set rgb 43 243 175 109'
'set rgb 44 238 213 183'
'set rgb 45 249 249 206'
'set rgb 46 250 249 226'

*green
'set rgb 50 220 255 220'
'set rgb 51 200 235 200'
'set rgb 52 160 215 160'
'set rgb 53 120 195 120'
'set rgb 54 80 175 80'
'set rgb 55 40 155 40'

* blue-red pallete
*blue
'set rgb 56 10 10 255'
'set rgb 57 50 50 255'
'set rgb 58 90 90 255'
'set rgb 59 130 130 255'
'set rgb 60 170 170 255'
'set rgb 61 210 210 255'

*red
'set rgb 62 255 210 210'
'set rgb 63 255 170 170'
'set rgb 64 255 130 130'
'set rgb 65 255 90 90'
'set rgb 66 255 50 50'
'set rgb 67 255 0 0'


*   Warm palette only (full field of a single sign)

if (icol = 1)
  "set rbcols 21 22 23 24 25 26 27 28 29 30"
endif
if (icol = 1b)
  "set rbcols 21 22 23 24 25 26 27 28 29 30"
endif
if (icol = -1)
  "set rbcols 30 29 28 27 26 25 24 23 22 21"
endif

*   Cold palette only (full field of a single sign)

if (icol = 2)
  "set rbcols 31 32 33 34 35 36 37 38 39 40"
endif

if (icol = -2)
  "set rbcols 40 39 38 37 36 35 34 33 32 31"
endif

*   Positive diff/anom warm palette, negative diff/anom cold palette
*   Max 6 contours (colours) allowed in each range (pos/neg)

if (icol = 3)
  "set rbcols 37 36 35 34 33 32  0 22 23 24 25 26 27"
endif
if (icol = 3b)
  "set rbcols 37 36 35 34 33 0 23 24 25 26 27"
endif

if (icol = 4)
  "set rbcols 37 36 35 34 33 32 22 23 24 25 26 27 28"
endif

*   brown-green palette
if (icol = 6)
  "set ccols  41 42 43 44 45 46 0 50 51 52 53 54 55"
endif
if (icol = 61)
  "set ccols  41 42 43 44 45 46 50 51 52 53 54 55"
endif
if (icol = 62)
  "set ccols  42 43 44 45 46 0 50 51 52 53 54"
endif
if (icol = 64)
  "set ccols  41 42 43 44 45 0 50 51 52 53 54"
endif
if (icol = 63)
  "set ccols  0 50 51 52 53 54 55"
endif

*   blue-red palette
if (icol = 7)
  "set ccols  57 58 59 60 61 0 62 63 64 65 66"
endif

*   blue-red palette
if (icol = 8)
  "set ccols  56 57 58 59 60 61 0 62 63 64 65 66 67"
endif
if (icol = 8b)
  "set ccols  56 57 58 59 60 61 20 62 63 64 65 66 67"
endif
*   blue-red palette
if (icol = 9)
  "set ccols  56 57 58 59 60 61 62 63 64 65 66 67"
endif
if (icol = 9b)
  "set ccols  56 57 58 59 60 0 63 64 65 66 67"
endif

"set grads off"
*"set grid off"
*"set gxout shaded"

return



