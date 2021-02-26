library("tidyverse", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("dplyr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("caret", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("AppliedPredictiveModeling", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("ggplot2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index/RDS/diff_datasets")

SuRE_0.01 <- readRDS("gbmfit_tunelength_down_SuRE_0.01.RDS")
SuRE_0.0001 <- readRDS("gbmfit_tunelength_down_SuRE_1e-04.RDS")
SuRE_0.000001 <- readRDS("gbmfit_tunelength_down_SuRE_1e-06.RDS")


resamps <- resamples(list(SuRE_0.01 = SuRE_0.01,
                          SuRE_0.0001 = SuRE_0.0001,
                          SuRE_0.000001 = SuRE_0.000001))


object.size(resamps)

saveRDS(resamps, "resamps.RDS")

jpeg("plot_SuRE.jpg", width = 1000, height = 1000)
theme1 <- trellis.par.get()
theme1$plot.symbol$col = rgb(.2, .2, .2, .4)
theme1$plot.symbol$pch = 16
theme1$plot.line$col = rgb(1, 0, 0, .7)
theme1$plot.line$lwd <- 20
theme1$axis.text$cex <- 1.8
theme1$par.main.text$cex <- 1.8

trellis.par.set(theme1)
bwplot(resamps, layout = c(3, 1), par.strip.text=list(cex=2))
#bwplot(resamps, layout = c(3, 1))
dev.off()







