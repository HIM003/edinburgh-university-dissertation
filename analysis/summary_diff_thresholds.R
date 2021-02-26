library("tidyverse", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("dplyr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("caret", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("AppliedPredictiveModeling", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("ggplot2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index/RDS/diff_datasets")

ALL_0_1 <- readRDS("gbmfit_tunelength_down_ALL_0_1.RDS")
ALL_0_5 <- readRDS("gbmfit_tunelength_down_ALL_0_5.RDS")
ALL_0_9 <- readRDS("gbmfit_tunelength_down_ALL_0_9.RDS")


CAVIAR_0_1 <- readRDS("gbmfit_tunelength_down_CAVIAR_0_1.RDS")
CAVIAR_0_5 <- readRDS("gbmfit_tunelength_down_CAVIAR_0_5.RDS")
CAVIAR_0_9 <- readRDS("gbmfit_tunelength_down_CAVIAR_0_9.RDS")


DAPG_0_1 <- readRDS("gbmfit_tunelength_down_DAPG_0_1.RDS")
DAPG_0_5 <- readRDS("gbmfit_tunelength_down_DAPG_0_5.RDS")
DAPG_0_9 <- readRDS("gbmfit_tunelength_down_DAPG_0_9.RDS")


CAVEMAN_0_5 <- readRDS("gbmfit_tunelength_down_CaVEMaN_0_5.RDS")
CAVEMAN_0_9 <- readRDS("gbmfit_tunelength_down_CaVEMaN_0_9.RDS")


resamps <- resamples(list(all_0_1 = ALL_0_1,
                          all_0_5 = ALL_0_5,
                          all_0_9 = ALL_0_9,
			  caviar_0_1 = CAVIAR_0_1,
			  caviar_0_5 = CAVIAR_0_5,
			  caviar_0_9 = CAVIAR_0_9,
			  dapg_0_1 = DAPG_0_1,
			  dapg_0_5 = DAPG_0_5,
			  dapg_0_9 = DAPG_0_9,
			  caveman_0_5 = CAVEMAN_0_5,
			  caveman_0_9 = CAVEMAN_0_9))



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







