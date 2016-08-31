#--  montage CRU_*_pr_climatology.jpg -tile 3x4 -geometry 3508x2480 climatology_CRU.jpg
#--  montage ERA40_*_pr_climatology.jpg -tile 3x4 -geometry 3508x2480 climatology_ERA40.jpg
#--  montage RCM_*_pr_climatology_grid2.jpg -tile 3x4 -geometry 3508x2480    climatology_RCM_grid2.jpg
#--  montage ERA40_*_pr_climatology_grid2.jpg -tile 3x4 -geometry 3508x2480  climatology_ERA40_grid2.jpg
#--  montage RCM_*_pr_climatology.jpg -tile 3x4 -geometry 3508x2480 climatology_RCM.jpg
#--  montage RCM_*_pr_climatology_errors_vsCRU.jpg   -tile 3x4 -geometry 3508x2480 errors_RCM_vs_CRU.jpg
#--  montage ERA40_*_pr_climatology_errors_vsCRU.jpg   -tile 3x4 -geometry 3508x2480 errors_ERA40_vs_CRU.jpg
#--  montage RCM_*_pr_climatology_errors_vsERA40.jpg -tile 3x4 -geometry 3508x2480 errors_RCM_vs_ERA40.jpg
#--  montage RCM_*_pr_errorSpread_vsCRU.jpg          -tile 3x4 -geometry 3508x2480 errorsSpread_RCM_vs_CRU.jpg
#--  montage RCM_*_pr_errorSpread_vsERA40.jpg        -tile 3x4 -geometry 3508x2480 errorsSpread_RCM_vs_ERA40.jpg

#--montage STAN_AREA1_DJF.jpg STAN_AREA1_JFM.jpg STAN_AREA1_FMA.jpg STAN_AREA1_MAM.jpg STAN_AREA1_AMJ.jpg STAN_AREA1_MJJ.jpg STAN_AREA1_JJA.jpg STAN_AREA1_JAS.jpg STAN_AREA1_ASO.jpg STAN_AREA1_SON.jpg STAN_AREA1_OND.jpg STAN_AREA1_NDJ.jpg  -tile 3x4 -geometry 1200x900 STAND_precip_AREA1.jpg
#--montage STAN_AREA2_DJF.jpg STAN_AREA2_JFM.jpg STAN_AREA2_FMA.jpg STAN_AREA2_MAM.jpg STAN_AREA2_AMJ.jpg STAN_AREA2_MJJ.jpg STAN_AREA2_JJA.jpg STAN_AREA2_JAS.jpg STAN_AREA2_ASO.jpg STAN_AREA2_SON.jpg STAN_AREA2_OND.jpg STAN_AREA2_NDJ.jpg  -tile 3x4 -geometry 1200x900 STAND_precip_AREA2.jpg

# 2016-01-21
montage RASAP_STAN_AREA1_{DJF,JFM,FMA,MAM,AMJ,MJJ,JJA,JAS,ASO,SON,OND,NDJ}.jpg -tile 3x4 -geometry 1200x900 RASAP_STAND_precip_AREA1.jpg
montage RASAP_STAN_AREA2_{DJF,JFM,FMA,MAM,AMJ,MJJ,JJA,JAS,ASO,SON,OND,NDJ}.jpg -tile 3x4 -geometry 1200x900 RASAP_STAND_precip_AREA2.jpg

# 2016-01-11
#montage CRU_01_*jpg ERA40_01_*jpg RCM_01_*jpg -tile 5x3 -geometry 2806x1984 EOFs_DJF.jpg
#montage CRU_02_*jpg ERA40_02_*jpg RCM_02_*jpg -tile 5x3 -geometry 2806x1984 EOFs_JFM.jpg
#montage CRU_03_*jpg ERA40_03_*jpg RCM_03_*jpg -tile 5x3 -geometry 2806x1984 EOFs_FMA.jpg
#montage CRU_04_*jpg ERA40_04_*jpg RCM_04_*jpg -tile 5x3 -geometry 2806x1984 EOFs_MAM.jpg
#montage CRU_05_*jpg ERA40_05_*jpg RCM_05_*jpg -tile 5x3 -geometry 2806x1984 EOFs_AMJ.jpg
#montage CRU_06_*jpg ERA40_06_*jpg RCM_06_*jpg -tile 5x3 -geometry 2806x1984 EOFs_MJJ.jpg
#montage CRU_07_*jpg ERA40_07_*jpg RCM_07_*jpg -tile 5x3 -geometry 2806x1984 EOFs_JJA.jpg
#montage CRU_08_*jpg ERA40_08_*jpg RCM_08_*jpg -tile 5x3 -geometry 2806x1984 EOFs_JAS.jpg
#montage CRU_09_*jpg ERA40_09_*jpg RCM_09_*jpg -tile 5x3 -geometry 2806x1984 EOFs_ASO.jpg
#montage CRU_10_*jpg ERA40_10_*jpg RCM_10_*jpg -tile 5x3 -geometry 2806x1984 EOFs_SON.jpg
#montage CRU_11_*jpg ERA40_11_*jpg RCM_11_*jpg -tile 5x3 -geometry 2806x1984 EOFs_OND.jpg
#montage CRU_12_*jpg ERA40_12_*jpg RCM_12_*jpg -tile 5x3 -geometry 2806x1984 EOFs_NDJ.jpg

# 2016-01-19
#montage RCM_01_*MODperMOD_vA.jpg -tile 5x1 -geometry 2806x1984 EOFs_DJF_MODperMOD_vA.jpg
#montage RCM_01_*MODperMOD_vB.jpg -tile 5x1 -geometry 2806x1984 EOFs_DJF_MODperMOD_vB.jpg
#montage RCM_02_*MODperMOD_vA.jpg -tile 5x1 -geometry 2806x1984 EOFs_JFM_MODperMOD_vA.jpg
#montage RCM_02_*MODperMOD_vB.jpg -tile 5x1 -geometry 2806x1984 EOFs_JFM_MODperMOD_vB.jpg
#montage RCM_03_*MODperMOD_vA.jpg -tile 5x1 -geometry 2806x1984 EOFs_FMA_MODperMOD_vA.jpg
#montage RCM_03_*MODperMOD_vB.jpg -tile 5x1 -geometry 2806x1984 EOFs_FMA_MODperMOD_vB.jpg
#montage RCM_04_*MODperMOD_vA.jpg -tile 5x1 -geometry 2806x1984 EOFs_MAM_MODperMOD_vA.jpg
#montage RCM_04_*MODperMOD_vB.jpg -tile 5x1 -geometry 2806x1984 EOFs_MAM_MODperMOD_vB.jpg
#montage RCM_05_*MODperMOD_vA.jpg -tile 5x1 -geometry 2806x1984 EOFs_AMJ_MODperMOD_vA.jpg
#montage RCM_05_*MODperMOD_vB.jpg -tile 5x1 -geometry 2806x1984 EOFs_AMJ_MODperMOD_vB.jpg
#montage RCM_06_*MODperMOD_vA.jpg -tile 5x1 -geometry 2806x1984 EOFs_MJJ_MODperMOD_vA.jpg
#montage RCM_06_*MODperMOD_vB.jpg -tile 5x1 -geometry 2806x1984 EOFs_MJJ_MODperMOD_vB.jpg
#montage RCM_07_*MODperMOD_vA.jpg -tile 5x1 -geometry 2806x1984 EOFs_JJA_MODperMOD_vA.jpg
#montage RCM_07_*MODperMOD_vB.jpg -tile 5x1 -geometry 2806x1984 EOFs_JJA_MODperMOD_vB.jpg
#montage RCM_08_*MODperMOD_vA.jpg -tile 5x1 -geometry 2806x1984 EOFs_JAS_MODperMOD_vA.jpg
#montage RCM_08_*MODperMOD_vB.jpg -tile 5x1 -geometry 2806x1984 EOFs_JAS_MODperMOD_vB.jpg
#montage RCM_09_*MODperMOD_vA.jpg -tile 5x1 -geometry 2806x1984 EOFs_ASO_MODperMOD_vA.jpg
#montage RCM_09_*MODperMOD_vB.jpg -tile 5x1 -geometry 2806x1984 EOFs_ASO_MODperMOD_vB.jpg
#montage RCM_10_*MODperMOD_vA.jpg -tile 5x1 -geometry 2806x1984 EOFs_SON_MODperMOD_vA.jpg
#montage RCM_10_*MODperMOD_vB.jpg -tile 5x1 -geometry 2806x1984 EOFs_SON_MODperMOD_vB.jpg
#montage RCM_11_*MODperMOD_vA.jpg -tile 5x1 -geometry 2806x1984 EOFs_OND_MODperMOD_vA.jpg
#montage RCM_11_*MODperMOD_vB.jpg -tile 5x1 -geometry 2806x1984 EOFs_OND_MODperMOD_vB.jpg
#montage RCM_12_*MODperMOD_vA.jpg -tile 5x1 -geometry 2806x1984 EOFs_NDJ_MODperMOD_vA.jpg
#montage RCM_12_*MODperMOD_vB.jpg -tile 5x1 -geometry 2806x1984 EOFs_NDJ_MODperMOD_vB.jpg
