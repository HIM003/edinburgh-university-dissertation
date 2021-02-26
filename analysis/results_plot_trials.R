################################################################################################################################
#
# This script is to compare PR and ROC curves for different ML models
#
#
################################################################################################################################


library("crayon", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("rstudioapi", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("cli", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("withr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("readr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("tidyverse", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("BiocGenerics", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("S4Vectors", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("IRanges", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("GenomeInfoDb", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("GenomicRanges", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("R.methodsS3", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("R.oo", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("R.utils", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("data.table", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("ggplot2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("plyr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("caret", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("dplyr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("AppliedPredictiveModeling", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("reshape2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("pROC", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("MLmetrics", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("xgboost", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("LiblineaR", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("gbm", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("naivebayes", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("ranger", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("nodeHarvest", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("kknn", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("adabag", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("ada", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("libcoin", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("partykit", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("evtree", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("kernlab", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("TeachingDemos", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("plotrix", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("plotmo", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("earth", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("pryr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("mda", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("MLeval", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")




setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index/")

base1 <- readRDS("RDS/0_10/gbmfit_tunelength_down_0_10.RDS")
base2 <- readRDS("RDS/trials/gbmfit_tunelength_down_0_10_no_data_transform.RDS")
base3 <- readRDS("RDS/trials/gbmfit_tunelength_down_0_10_no_data_transform_no_scale_no_center.RDS")
base4 <- readRDS("RDS/trials/gbmfit_tunelength_down_0_10_no_data_transform_no_scale_no_center_no_nzv.RDS")
base5 <- readRDS("RDS/trials/gbmfit_tunelength_down_0_10_no_data_transform_no_scale_no_center_no_nzv_no_hcf.RDS")



resamps <- resamples(list("Base Case" = base1,
                          "Base Case \n no Data Transform" = base2,
                          "Base Case \n no Data Transform \n no Centering or Scaling" = base3,
                          "Base Case \n no Data Transform \n no Centering or Scaling \n no Near-Zero Variants" = base4,
                          "Base Case \n no Data Transform \n no Centering or Scaling \n no Near-Zero Variants \n no Highly-Correlated Features" = base5))



jpeg("compare_trials_gbm.jpg", width = 1000, height = 1000)
theme1 <- trellis.par.get()
theme1$plot.symbol$col = rgb(.2, .2, .2, .4)
theme1$plot.symbol$pch = 16
theme1$plot.line$col = rgb(1, 0, 0, .7)
theme1$plot.line$lwd <- 20
theme1$axis.text$cex <- 1.6
theme1$axis.label$cex <- 1.6
#theme1$par.ylab.text$cex <- 1.8
theme1$par.main.text$cex <- 1.8
trellis.par.set(theme1)

bwplot(resamps,
       main="Impact of Different Sensitivities",
       layout=(c(3,1)), par.strip.text = list(cex=2), scales=list(y=list(labels=c("Base Case \n no Data Transform \n no Centering or Scaling \n no Near-Zero Variants \n no Highly-Correlated Features", 
       "Base Case \n no Data Transform \n no Centering or Scaling \n no Near-Zero Variants","Base Case \n no Data Transform \n no Centering or Scaling", "Base Case \n no Data Transform", "Base Case"))))


dev.off()

#bwplot(resamps, layout = c(3, 1))
