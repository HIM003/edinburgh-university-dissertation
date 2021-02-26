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


args <- commandArgs(trailingOnly = TRUE)
name <- args[1]
rds <- args[2]
save <- args[3]
k <- as.double(args[4])
dataset <- paste("/exports/eddie/scratch/s1772751/Prepared_Data/index/", name, sep="")
zipped <- paste("/exports/eddie/scratch/s1772751/Prepared_Data/index/RDS/", rds, sep="")
print(head(dataset))



setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index")
x <-fread(dataset, data.table=FALSE)


dropped_class <- subset(x, select=c("CLASS"))
drops <- c("row_number", "chr", "variant_pos", "CLASS", "TISSUE", "REF", "ALT")
x <- x[ , !(names(x) %in% drops)]
#x <- 10^x - 1
x <- cbind(x, dropped_class)

#nzv <- readRDS("/exports/eddie/scratch/s1772751/Prepared_Data/index/RDS/nzv.RDS")
#drop <- rownames(nzv[nzv$nzv==TRUE,])
#x <- x[ , !(names(x) %in% drop)]

#hcf_95 <- c("HCT116_Jund_dist", "IMR_90_CTCF_dist")
#hcf_90 <- c("IMR_90_H2AK5ac_dist", "HCT116_SIN3A_dist", "M1_CB_H3K36me3_dist", "mononuclear_PB_H3K9ac_dist", "CD4_ab_T_Th_H3K4me1_dist", "H1_hESC_3_H3K4me3_dist","HCT116_SP1_dist","HSMM_H3K4me3_dist", "iPS_20b_H3K4me3_dist", "CM_CD4_ab_T_VB_H3K36me3_dist", "monocyte_VB_DNase1_dist", "CD8_ab_T_PB_H3K4me1_dist", "NHLF_H3K4me3_dist", "GM12878_H3K4me3_dist", "B_PB_H3K36me3_dist", "IMR_90_H3K4me3_dist", "CD4_ab_T_Th_H3K36me3_dist", "placenta_H3K36me3_dist", "CD8_ab_T_PB_H3K4me3_dist","HCT116_CEBPB_dist","HCT116_Srf_dist", "CD14_monocyte_PB_DNase1_dist", "myotube_H3K4me3_dist", "CD14_monocyte_PB_H3K36me3_dist","HCT116_Jund_dist", "IMR_90_CTCF_dist")

#x <- x[ , !(names(x) %in% hcf_90)]




i <- 0.8
set.seed(3456)
trainIndex <- createDataPartition(x$CLASS, p = i,
                  list = FALSE, times = 1)

x_train <- x[as.vector(trainIndex),]
x_test <- x[as.vector(-trainIndex),]

x_test_neg <- x_test %>% filter(CLASS=="Negative")
x_test_pos <- x_test %>% filter(CLASS=="Positive")

#k <- 0.00055
set.seed(3456)
trainIndex <- createDataPartition(x_test_pos$CLASS, p = k,
                  list = FALSE, times = 1)
x_test_pos <- x_test_pos[as.vector(trainIndex),]
x_test <- bind_rows(x_test_neg, x_test_pos)

print("class imbalance")
print(table(x_test$CLASS)[[2]]/table(x_test$CLASS)[[1]])

file <- readRDS(zipped)
print(file)
#down <- readRDS("RDS/trials/gbmfit_rebalanced_caveman_0.5_down_sampled.RDS")
#smote <- readRDS("RDS/trials/gbmfit_rebalanced_caveman_0.5_smote_sampled.RDS")
#rose <- readRDS("RDS/trials/gbmfit_rebalanced_caveman_0.5_rose_sampled.RDS")
#up <- readRDS("RDS/trials/gbmfit_rebalanced_caveman_0.5_up_sampled.RDS")



names_ <- c(save)


AUC_PR <- c()
AUC_ROC <- c()
SENS <- c()
SPEC <- c()
PREC <- c()
RECALL <- c()
F1 <- c()

j = i

for (j in list(file)) { 
		
		predicted <- predict(j, x_test, type="prob")
		all_data <- cbind(data.frame(predicted), data.frame(x_test$CLASS))
		res <- evalm(all_data)
		
		for (i in seq(1:length(rownames(res$optres$Group1)))) {
  			if(rownames(res$optres$Group1)[i] == "AUC-PR") {
    				AUC_PR <- c(AUC_PR, res$optres$Group1$Score[i])
  			}

		}	
		
		predicted$obs <- as.factor(x_test$CLASS)
		predicted$pred <- as.factor(ifelse(predicted$Negative >= .5, "Negative", "Positive"))
		
		x <- twoClassSummary(predicted, lev = levels(predicted$obs))
		predicted_raw <- predict(j, x_test, type="raw")
		y <- confusionMatrix(data = predicted_raw, reference = factor(x_test$CLASS), positive = "Positive")
		
		for (i in seq(1:length(names(y$byClass)))) {

			 if(names(y$byClass)[i] =="Sensitivity") {
				SENS <- c(SENS, (y$byClass)[i][[1]])
			}


			 if(names(y$byClass)[i] =="Specificity") {
                                SPEC <- c(SPEC, (y$byClass)[i][[1]])
                        }


			 if(names(y$byClass)[i] =="Precision") {
                                PREC <- c(PREC, (y$byClass)[i][[1]])
                        }


			 if(names(y$byClass)[i] =="Recall") {
                                RECALL <- c(RECALL, (y$byClass)[i][[1]])
                        }


			if(names(y$byClass)[i] =="F1") {
                                F1 <- c(F1, (y$byClass)[i][[1]])
                        }


		}
		
		AUC_ROC <- c(AUC_ROC, x[[1]])
		rm(predicted)	
		


}

print(AUC_PR)
print(AUC_ROC)
print(SENS)
print(SPEC)
print(PREC)
print(RECALL)
print(F1)
df <- data.frame(AUC_PR, AUC_ROC, SENS, SPEC, PREC, RECALL, F1)
rownames(df) <- names_
print(df)
write.csv(df,save)

