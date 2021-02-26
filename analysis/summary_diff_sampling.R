library("tidyverse", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("dplyr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("caret", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("AppliedPredictiveModeling", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("ggplot2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index/RDS/trials")

down <- readRDS("gbmfit_rebalanced_caveman_0.5_down_sampled.RDS")
rose <- readRDS("gbmfit_rebalanced_caveman_0.5_rose_sampled.RDS")
smote <- readRDS("gbmfit_rebalanced_caveman_0.5_smote_sampled.RDS")
up <- readRDS("gbmfit_rebalanced_caveman_0.5_up_sampled.RDS")


resamps <- resamples(list(down_0.5 = down,
                          rose_0.5 = rose,
                          smote_0.5 = smote,
			  up_0.5 = up))



jpeg("resampling.jpg", width = 1000, height = 1000)
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
