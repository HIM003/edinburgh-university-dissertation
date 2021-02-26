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
x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz", data.table=FALSE)
dropped <- c("row_number", "chr", "variant_pos","TISSUE", "REF", "ALT")
x <- x[ , !(names(x) %in% dropped)]

i <- 0.80
set.seed(3456)
trainIndex <- createDataPartition(x$CLASS, p = i,
                  list = FALSE, times = 1)

x_train <- x[as.vector(trainIndex),]
x_test <- x[as.vector(-trainIndex),]

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




names_ <- c("LogitBoost","xgbTree","LogRegression", "lda", "lda2", "gbm", "naivebayes", "knn","ranger", "bag", "nodeHarvest","kknn", "adabag", "ada", "evtree", "glm", "bagFDAGCV")

AUC_PR <- c()
AUC_ROC <- c()
SENS_F1 <- c()
PREC <- c()
F1 <- c()
SENS_J <- c()
J <- c()
FPR <- c()

#LogitBoost, xgbTree, LogRegression, lda, lda2, gbmfit, naivebayes, ranger, bag, nodeHarvest, kknn, adabag_, ada, evtree, glm, bagFDAGCV
j = i

for (j in list(LogitBoost, xgbTree, LogRegression, lda, lda2, gbm, naivebayes, knn, ranger, bag, nodeHarvest, kknn, adabag, ada, evtree, glm, bagFDAGCV)) { 
		
		predicted <- predict(j, x_test, type="prob")
		all_data <- cbind(data.frame(predicted), data.frame(x_test$CLASS))
		res <- evalm(all_data)
		
		for (i in seq(1:length(rownames(res$optres$Group1)))) {
  			if(rownames(res$optres$Group1)[i] == "AUC-PR") {
    				AUC_PR <- c(AUC_PR, res$optres$Group1$Score[i])
  			}

			if(rownames(res$optres$Group1)[i] == "AUC-ROC") {
                                AUC_ROC <- c(AUC_ROC, res$optres$Group1$Score[i])
                        }

		}	
		
		x <- res$proc$data
		x <- data.frame(x)		
		x <- x %>% filter_if(~is.numeric(.), all_vars(!is.infinite(.)))
		x <- x[which.max(x$F1),]
		
		print(dim(x))
		for (i in seq(1:length(colnames(x)))) {
			#print(colnames(x)[i])
			if(colnames(x)[i] == "SENS"){
				SENS_F1 <- c(SENS_F1,x[[i]])	
                        }
			else if(colnames(x)[i] == "PREC") {
                                PREC <- c(PREC, x[[i]]) 
                        }
		
			else if(colnames(x)[i] == "F1") {
                                F1 <- c(F1, x[[i]])
                        } else {}

		}		

			

		x <- res$proc$data
                x <- data.frame(x)
		x$J <- x$SENS - (1 - x$SPEC)
		x <- x %>% filter_if(~is.numeric(.), all_vars(!is.infinite(.)))
		x <- x[which.max(x$J),]
		#x <- x %>% filter(J==max(J))

		for (i in seq(1:length(colnames(x)))) {

                        if(colnames(x)[i] == "SENS") {
                                SENS_J <- c(SENS_J, x[[i]])
                        }
                        else if(colnames(x)[i] == "FPR") {
                                FPR <- c(FPR, x[[i]])
                        }

                        else if(colnames(x)[i] == "J") {
                                J <- c(J, x[[i]])
                        } else {}

                }

		
	#	j = j + 1

}

print(AUC_PR)
print(AUC_ROC)
print(SENS_F1)
print(PREC)
print(F1)
print(SENS_J)
print(J)
print(FPR)
df <- data.frame(AUC_PR, AUC_ROC, SENS_F1, PREC, F1, SENS_J, J, FPR)
rownames(df) <- names_
print(df)
write.csv(df,"Summary_Metrics.csv")

