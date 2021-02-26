######################################################################################################################
#
# This scripts allows you to extract the ROC curve and Lift Curve
# You need to specify some paramters.  Also check which dataset you want to extract the test set from.
#
#####################################################################################################################


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

#args are of the form "adabag" 0_05, i.e. the name followed by the sampling size
args <- commandArgs(trailingOnly = TRUE)
path_1 <- paste(args[1],"_tunelength_down_",args[2],".RDS", sep="")
path_2 <- paste("RDS/",args[2],"/",path_1,sep="")
path_3 <- paste("roc_",args[2],sep="")
path_4 <- paste("lift_",args[2],sep="")
path_5 <- paste("results/", args[2], "/", args[1], "_roc_",args[2],".csv", sep="")
path_6 <- paste("results/", args[2], "/", args[1], "_lift_",args[2],".csv", sep="")

print(path_1)
print(path_2)
print(path_3)
print(path_4)
print(path_5)
print(path_6)

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index")
x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_1.csv.gz", data.table=FALSE)
dropped <- c("row_number", "chr", "variant_pos","TISSUE", "REF", "ALT")
x <- x[ , !(names(x) %in% dropped)]

i <- 0.80
set.seed(3456)
trainIndex <- createDataPartition(x$CLASS, p = i,
                  list = FALSE, times = 1)

x_train <- x[as.vector(trainIndex),]
x_test <- x[as.vector(-trainIndex),]

Fit <- readRDS(path_2)

j = 1

for (i in list(Fit)) { 
		
		predicted <- predict(i, x_test, type="prob")
		all_data <- cbind(data.frame(x_test$CLASS), data.frame(predicted))
		roc_results <- roc(all_data[,1], all_data[,3])
		roc_results_data <- data.frame(roc_results$sensitivities, roc_results$specificities)
		colnames(roc_results_data) <- c("sens", "spec")
		roc_results_data$one_min_spec <- 1 - roc_results_data$spec
		#assign(names_[j], roc_results_data)
		#all_data <- data.frame()
		#rm(roc_results_data)
		
		#lift calcs
		lift_results <- predict(i, x_test, type = "prob")
		lift_results <- data.frame(lift_results[,"Negative"])
		lift_results <- data.frame(x_test$CLASS, lift_results)
		colnames(lift_results)[1:2] <- c("Class","prob")
		#assign(names_lift[j], lift_results)
		
		j = j + 1

}


write.csv(roc_results_data, path_5)
write.csv(lift_results, path_6)
