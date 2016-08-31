
for A in 1 2; do
    for SEAS in DJF JFM FMA MAM AMJ MJJ JJA JAS ASO SON OND NDJ; do
    convert -density 150  STAN_AREA${A}_${SEAS}.eps STAN_AREA${A}_${SEAS}.jpg
    done
done

