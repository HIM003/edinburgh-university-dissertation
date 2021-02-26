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
x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_5sf_CAVIAR_0.1_outfile.csv.gz", data.table=FALSE)
#print(colnames(x))

dropped_class <- subset(x, select=c("CLASS"))
drops <- c("row_number", "chr", "variant_pos", "CLASS", "TISSUE", "REF", "ALT", "comb")
x <- x[ , !(names(x) %in% drops)]
#x <- 10^x - 1
x <- cbind(x, dropped_class)

#nzv <- readRDS("/exports/eddie/scratch/s1772751/Prepared_Data/index/RDS/nzv.RDS")
#drop <- rownames(nzv[nzv$nzv==TRUE,])
#x <- x[ , !(names(x) %in% drop)]

#hcf_95 <- c("HCT116_Jund_dist", "IMR_90_CTCF_dist")
#hcf_90 <- c("IMR_90_H2AK5ac_dist", "HCT116_SIN3A_dist", "M1_CB_H3K36me3_dist", "mononuclear_PB_H3K9ac_dist", "CD4_ab_T_Th_H3K4me1_dist", "H1_hESC_3_H3K4me3_dist","HCT116_SP1_dist","HSMM_H3K4me3_dist", "iPS_20b_H3K4me3_dist", "CM_CD4_ab_T_VB_H3K36me3_dist", "monocyte_VB_DNase1_dist", "CD8_ab_T_PB_H3K4me1_dist", "NHLF_H3K4me3_dist", "GM12878_H3K4me3_dist", "B_PB_H3K36me3_dist", "IMR_90_H3K4me3_dist", "CD4_ab_T_Th_H3K36me3_dist", "placenta_H3K36me3_dist", "CD8_ab_T_PB_H3K4me3_dist","HCT116_CEBPB_dist","HCT116_Srf_dist", "CD14_monocyte_PB_DNase1_dist", "myotube_H3K4me3_dist", "CD14_monocyte_PB_H3K36me3_dist","HCT116_Jund_dist", "IMR_90_CTCF_dist")

#x <- x[ , !(names(x) %in% hcf_90)]


i <- 0.80
set.seed(3456)
trainIndex <- createDataPartition(x$CLASS, p = i,
                  list = FALSE, times = 1)

x_train <- x[as.vector(trainIndex),]
x_test <- x[as.vector(-trainIndex),]


#base <- readRDS("RDS/0_10/regLogistic_tunelength_down_0_10.RDS")
#no_data_transform <- readRDS("RDS/trials/regLogistic_tunegrid_down_0_10_no_data_transform.RDS")
#no_center_no_scale <- readRDS("RDS/trials/gbmfit_tunelength_down_0_10_no_scale_no_center.RDS")
#no_nzv <- readRDS("RDS/trials/gbmfit_tunelength_down_0_10_no_nzv.RDS")
#no_hcf <- readRDS("RDS/trials/gbmfit_tunelength_down_0_10_no_hcf.RDS")

model <- readRDS("RDS/diff_datasets/gbmfit_tunelength_down_CAVIAR_0_1.RDS")



names_ <- c("caviar_0.1")

AUC_PR_Eval <- c()
AUC_ROC_Eval <- c()

AUC_PR <- c()
AUC_ROC <- c()
SENS <- c()
SPEC <- c()
PREC <- c()
RECALL <- c()
F1 <- c()

j = i

for (j in list(model)) { 
		
		predicted <- predict(j, x_test, type="prob")
		all_data <- cbind(data.frame(predicted), data.frame(x_test$CLASS))
		res <- evalm(all_data)
		
		for (i in seq(1:length(rownames(res$optres$Group1)))) {
  			if(rownames(res$optres$Group1)[i] == "AUC-PR") {
    				AUC_PR_Eval <- c(AUC_PR_Eval, res$optres$Group1$Score[i])
  			}

			if(rownames(res$optres$Group1)[i] == "AUC-ROC") {
                                AUC_ROC_Eval <- c(AUC_ROC_Eval, res$optres$Group1$Score[i])
                        }

		}	
		
		predicted$obs <- as.factor(x_test$CLASS)
		print(table(predicted$obs))
		
		predicted$pred <- as.factor(ifelse(predicted$Negative >= .5, "Negative", "Positive"))
		
		print(head(predicted))
		print(levels(predicted$pred))
		x <- twoClassSummary(predicted, lev = levels(predicted$obs))
		y <- prSummary(predicted, lev = levels(predicted$obs))
		AUC_ROC <- c(AUC_ROC, x[[1]])
		SENS <- c(SENS, x[[2]])
		SPEC <- c(SPEC, x[[3]])
		AUC_PR <- c(AUC_PR, y[[1]])
		PREC <- c(PREC, y[[2]])
		RECALL <- c(RECALL, y[[3]])
		F1 <- c(F1, y[[4]])
		rm(predicted)	
		


}

print(AUC_PR)
print(AUC_ROC)
print(SENS)
print(SPEC)
print(PREC)
print(RECALL)
print(F1)
df <- data.frame(AUC_PR_Eval, AUC_ROC_Eval, AUC_PR, AUC_ROC, SENS, SPEC, PREC, RECALL, F1)
rownames(df) <- names_
print(df)
write.csv(df,"Summary_Metrics_gbm_caviar_0.1.csv")

