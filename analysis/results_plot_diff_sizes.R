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




setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index")

#0.05% datasets
LogitBoost_05 <- readRDS("RDS/0_05/LogitBoost_tunelength_down_0_05.RDS")
lda_05 <- readRDS("RDS/0_05/lda_tunelength_down_0_05.RDS")
lda2_05 <- readRDS("RDS/0_05/lda2_tunelength_down_0_05.RDS")
gbm_05 <- readRDS("RDS/0_05/gbmfit_tunelength_down_0_05.RDS")
naivebayes_05 <- readRDS("RDS/0_05/naivebayes_tunelength_down_0_05.RDS")
bag_05 <- readRDS("RDS/0_05/bag_tunelength_down_0_05.RDS")
ada_05 <- readRDS("RDS/0_05/ada_tunelength_down_0_05.RDS")
glm_05 <- readRDS("RDS/0_05/glm_tunelength_down_0_05.RDS")
bagFDAGCV_05 <- readRDS("RDS/0_05/bagFDAGCV_tunelength_down_0_05.RDS")
regLogistic_05 <- readRDS("RDS/0_05/regLogistic_tunelength_down_0_05.RDS")

print("loaded 5%")

#0.1% datasets
LogitBoost_10 <- readRDS("RDS/0_10/LogitBoost_tunelength_down_0_10.RDS")
lda_10 <- readRDS("RDS/0_10/lda_tunelength_down_0_10.RDS")
lda2_10 <- readRDS("RDS/0_10/lda2_tunelength_down_0_10.RDS")
gbm_10 <- readRDS("RDS/0_10/gbmfit_tunelength_down_0_10.RDS")
naivebayes_10 <- readRDS("RDS/0_10/naivebayes_tunelength_down_0_10.RDS")
bag_10 <- readRDS("RDS/0_10/bag_tunelength_down_0_10.RDS")
ada_10 <- readRDS("RDS/0_10/ada_tunelength_down_0_10.RDS")
glm_10 <- readRDS("RDS/0_10/glm_tunelength_down_0_10.RDS")
bagFDAGCV_10 <- readRDS("RDS/0_10/bagFDAGCV_tunelength_down_0_10.RDS")
regLogistic_10 <- readRDS("RDS/0_10/regLogistic_tunelength_down_0_10.RDS")

print("loaded 10%")

#0.25% datasets
LogitBoost_25 <- readRDS("RDS/0_25/LogitBoost_tunelength_down_0_25.RDS")
lda_25 <- readRDS("RDS/0_25/lda_tunelength_down_0_25.RDS")
lda2_25 <- readRDS("RDS/0_25/lda2_tunelength_down_0_25.RDS")
gbm_25 <- readRDS("RDS/0_25/gbmfit_tunelength_down_0_25.RDS")
naivebayes_25 <- readRDS("RDS/0_25/naivebayes_tunelength_down_0_25.RDS")
bag_25 <- readRDS("RDS/0_25/bag_tunelength_down_0_25.RDS")
ada_25 <- readRDS("RDS/0_25/ada_tunelength_down_0_25.RDS")
glm_25 <- readRDS("RDS/0_25/glm_tunelength_down_0_25.RDS")
bagFDAGCV_25 <- readRDS("RDS/0_25/bagFDAGCV_tunelength_down_0_25.RDS")
regLogistic_25 <- readRDS("RDS/0_25/regLogistic_tunelength_down_0_25.RDS")


print("loaded 25%")

#1% datasets
LogitBoost_100 <- readRDS("RDS/1_00/LogitBoost_tunelength_down_1_00.RDS")
lda_100 <- readRDS("RDS/1_00/lda_tunelength_down_1_00.RDS")
lda2_100 <- readRDS("RDS/1_00/lda2_tunelength_down_1_00.RDS")
gbm_100 <- readRDS("RDS/1_00/gbmfit_tunelength_down_1_00.RDS")
naivebayes_100 <- readRDS("RDS/1_00/naivebayes_tunelength_down_1_00.RDS")
bag_100 <- readRDS("RDS/1_00/bag_tunelength_down_1_00.RDS")
glm_100 <- readRDS("RDS/1_00/glm_tunelength_down_1_00.RDS")
regLogistic_100 <- readRDS("RDS/1_00/regLogistic_tunelength_down_1_00.RDS")



print("loaded 100%")

names_ <- c("LogitBoost_05","lda_05", "lda2_05", "gbm_05", "naivebayes_05", "bag_05", "ada_05", "glm_05", "bagFDAGCV_05", "regLogistic_05", "LogitBoost_10","lda_10", "lda2_10", "gbm_10", "naivebayes_10", "bag_10", "ada_10", "glm_10", "bagFDAGCV_10", "regLogistic_10", "LogitBoost_25","lda_25", "lda2_25", "gbm_25", "naivebayes_25", "bag_25", "ada_25", "glm_25", "bagFDAGCV_25", "regLogistic_25", "LogitBoost_100","lda_100", "lda2_100", "gbm_100", "naivebayes_100", "bag_100", "glm_100", "regLogistic_100")


T1 <- c()
T2 <- c()
T3 <- c()

i = 1

for (j in list(LogitBoost_05, lda_05, lda2_05, gbm_05, naivebayes_05, bag_05, ada_05, glm_05, bagFDAGCV_05, regLogistic_05, LogitBoost_10, lda_10, lda2_10, gbm_10, naivebayes_10, bag_10, ada_10, glm_10, bagFDAGCV_10, regLogistic_10, LogitBoost_25, lda_25, lda2_25, gbm_25, naivebayes_25, bag_25, ada_25, glm_25, bagFDAGCV_25, regLogistic_25, LogitBoost_100, lda_100, lda2_100, gbm_100, naivebayes_100, bag_100, glm_100, regLogistic_100)) { 
		
		t1 <- j$results$ROC
		print(t1)
		T1 <- c(T1, t1)
		
		if(grepl("05", names_[i], fixed = TRUE)==TRUE) {
			
			t3 <- c(rep("0.075% Neg & 2.5% Pos", length(t1)))
                	print(t3)
			#t3.f <- factor(t3, levels=c("0_05"), labels=c("5%"))
			T3 <- c(T3, t3)			

			a <- str_remove(names_[i], "_05")
			t2 <- c(rep(a, length(t1)))
			print(t2)
        	       	#t2.f <- factor(t2, levels=c(a), labels=c(a))
			T2 <- c(T2, t2)
		}

		if(grepl("10", names_[i], fixed = TRUE)==TRUE) {

                        t3 <- c(rep("0.15% Neg & 5% Pos", length(t1)))
                        print(t3)
                        #t3.f <- factor(t3, levels=c("0_05"), labels=c("5%"))
                        T3 <- c(T3, t3)

                        a <- str_remove(names_[i], "_10")
                        t2 <- c(rep(a, length(t1)))
                        print(t2)
                        #t2.f <- factor(t2, levels=c(a), labels=c(a))
                        T2 <- c(T2, t2)
                }

		if(grepl("25", names_[i], fixed = TRUE)==TRUE) {

                        t3 <- c(rep("0.375% Neg & 12.5% Pos", length(t1)))
                        print(t3)
                        #t3.f <- factor(t3, levels=c("0_05"), labels=c("5%"))
                        T3 <- c(T3, t3)

                        a <- str_remove(names_[i], "_25")
                        t2 <- c(rep(a, length(t1)))
                        print(t2)
                        #t2.f <- factor(t2, levels=c(a), labels=c(a))
                        T2 <- c(T2, t2)
                }


		
		if(grepl("100", names_[i], fixed = TRUE)==TRUE) {

                        t3 <- c(rep("1.5% Neg & 50% Pos", length(t1)))
                        print(t3)
                        #t3.f <- factor(t3, levels=c("0_05"), labels=c("5%"))
                        T3 <- c(T3, t3)

                        a <- str_remove(names_[i], "_100")
                        t2 <- c(rep(a, length(t1)))
                        print(t2)
                        #t2.f <- factor(t2, levels=c(a), labels=c(a))
                        T2 <- c(T2, t2)
                }



		
		
		i = i + 1

}

t3.f <- factor(T3, levels=c(unique(T3)), labels=c(unique(T3)))
t2.f <- factor(T2, levels=c(unique(T2)), labels=c(unique(T2)))


print(T1)
print(t2.f)
print(t3.f)


jpeg("compare_dataset_sizes_ROC.jpg", width = 1000, height = 1000)
theme1 <- trellis.par.get()
theme1$plot.symbol$col = rgb(.2, .2, .2, .4)
theme1$plot.symbol$pch = 16
theme1$plot.line$col = rgb(1, 0, 0, .7)
theme1$plot.line$lwd <- 20
theme1$axis.text$cex <- 1.8
theme1$axis.label$cex <- 1.8
theme1$par.main.text$cex <- 1.8
trellis.par.set(theme1)

bwplot(t3.f~T1|t2.f,
       ylab=list("Dataset Size", fontsize=24), xlab=list("ROC AUC", fontsize=24),
       main="Impact of Dataset size on ROC AUC for different Algorithms",
       layout=(c(5,2)), par.strip.text = list(cex=2))


dev.off()

#bwplot(resamps, layout = c(3, 1))
