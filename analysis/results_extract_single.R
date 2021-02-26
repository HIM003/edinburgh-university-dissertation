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
dataset <- paste("/exports/eddie/scratch/s1772751/Prepared_Data/index/", name, sep="")
zipped <- paste("/exports/eddie/scratch/s1772751/Prepared_Data/index/RDS/", rds, sep="")
print(head(dataset))



setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index")
x <-fread(dataset, data.table=FALSE)
dropped <- c("row_number", "chr", "variant_pos","TISSUE", "REF", "ALT", "comb")
x <- x[ , !(names(x) %in% dropped)]
print(head(x))

i <- 0.80
set.seed(3456)
trainIndex <- createDataPartition(x$CLASS, p = i,
                  list = FALSE, times = 1)

x_train <- x[as.vector(trainIndex),]
x_test <- x[as.vector(-trainIndex),]


file <- readRDS(zipped)
print(file)
#down <- readRDS("RDS/trials/gbmfit_rebalanced_caveman_0.5_down_sampled.RDS")
#smote <- readRDS("RDS/trials/gbmfit_rebalanced_caveman_0.5_smote_sampled.RDS")
#rose <- readRDS("RDS/trials/gbmfit_rebalanced_caveman_0.5_rose_sampled.RDS")
#up <- readRDS("RDS/trials/gbmfit_rebalanced_caveman_0.5_up_sampled.RDS")



names_ <- c(save)

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

for (j in list(file)) { 
		
		predicted <- predict(j, x_test, type="prob")
		print(head(predicted))		

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
		print(levels(predicted$obs))
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
write.csv(df,save)

