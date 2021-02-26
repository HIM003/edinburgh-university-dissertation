library("tidyverse", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("dplyr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("caret", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("AppliedPredictiveModeling", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("ggplot2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index/RDS/trials")

CS_0_1 <- readRDS("gbmfit_tunelength_caveman_original_dist_0.1_weighted.RDS")
CS_0_3 <- readRDS("gbmfit_tunelength_caveman_original_dist_0.3_weighted.RDS")
CS_0_5 <- readRDS("gbmfit_tunelength_caveman_original_dist_0.5_weighted.RDS")
CS_0_7 <- readRDS("gbmfit_tunelength_caveman_original_dist_0.7_weighted.RDS")
CS_0_9 <- readRDS("gbmfit_tunelength_caveman_original_dist_0.9_weighted.RDS")

resamps <- resamples(list(CS_0_1 = CS_0_1,
                          CS_0_3 = CS_0_3,
                          CS_0_5 = CS_0_5,
                          CS_0_7 = CS_0_7,
                          CS_0_7 = CS_0_9))
			  

jpeg("plot.jpg", width = 1000, height = 1000)
theme1 <- trellis.par.get()
theme1$plot.symbol$col = rgb(.2, .2, .2, .4)
theme1$plot.symbol$pch = 16
theme1$plot.line$col = rgb(1, 0, 0, .7)
theme1$plot.line$lwd <- 20
theme1$axis.text$cex <- 1.8
theme1$par.main.text$cex <- 1.8

trellis.par.set(theme1)
bwplot(resamps, layout = c(3, 1))
dev.off()







