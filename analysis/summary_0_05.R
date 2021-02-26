library("tidyverse", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("dplyr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("caret", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("AppliedPredictiveModeling", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("ggplot2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index/")

LogitBoost <- readRDS("RDS/0_05/LogitBoost_tunelength_down_0_05.RDS")
xgbTree <- readRDS("RDS/0_05/xgbTree_tunelength_down_0_05.RDS")
LogRegression <- readRDS("RDS/0_05/regLogistic_tunelength_down_0_05.RDS")
lda <- readRDS("RDS/0_05/lda_tunelength_down_0_05.RDS")
lda2 <- readRDS("RDS/0_05/lda2_tunelength_down_0_05.RDS")
gbm <- readRDS("RDS/0_05/gbmfit_tunelength_down_0_05.RDS")
naivebayes <- readRDS("RDS/0_05/naivebayes_tunelength_down_0_05.RDS")
knn <- readRDS("RDS/0_05/knn_tunelength_down_0_05.RDS")
ranger <- readRDS("RDS/0_05/ranger_tunelength_down_0_05.RDS")
bag <- readRDS("RDS/0_05/bag_tunelength_down_0_05.RDS")
nodeHarvest <- readRDS("RDS/0_05/nodeHarvest_tunelength_down_0_05.RDS")
kknn <- readRDS("RDS/0_05/kknn_tunelength_down_0_05.RDS")
adabag <- readRDS("RDS/0_05/adabag_tunelength_down_0_05.RDS")
ada <- readRDS("RDS/0_05/ada_tunelength_down_0_05.RDS")
evtree <- readRDS("RDS/0_05/evtree_tunelength_down_0_05.RDS")
glm <- readRDS("RDS/0_05/glm_tunelength_down_0_05.RDS")
bagFDAGCV <- readRDS("RDS/0_05/bagFDAGCV_tunelength_down_0_05.RDS")


resamps <- resamples(list(LogitBoost = LogitBoost,
                          xgbTree = xgbTree,
                          LogRegression = LogRegression,
			  lda = lda,
			  lda2 = lda2,
			  gbm = gbm,
			  naivebayes = naivebayes,
			  knn = knn, 
			  ranger = ranger,
  			  bag = bag,
  			  nodeHarvest = nodeHarvest,
			  kknn = kknn, 
			  adabag = adabag,
			  ada = ada,
			  evtree = evtree,
			  glm = glm,
			  bagFDAGCV = bagFDAGCV))



jpeg("plot.jpg", width = 1000, height = 1000)
theme1 <- trellis.par.get()
theme1$plot.symbol$col = rgb(.2, .2, .2, .4)
theme1$plot.symbol$pch = 16
theme1$plot.line$col = rgb(1, 0, 0, .7)
theme1$plot.line$lwd <- 20
theme1$axis.text$cex <- 1.8
theme1$par.main.text$cex <- 1.8
theme1$par.strip.text$cex <- 2.5

trellis.par.set(theme1)
bwplot(resamps, layout = c(3, 1), par.strip.text = list(cex=3))
dev.off()
