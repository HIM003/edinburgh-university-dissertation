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

args <- commandArgs(trailingOnly = TRUE)
path_1 <- paste("RDS/trials/",args[1], sep="") 
path_2 <- paste(args[2],".csv",sep="")
#path_3 <- paste("results/", args[2], "/", args[1], "_results_",args[2],".csv", sep="")
#path_4 <- paste("results/", args[2], "/", args[1], "_predictors_",args[2],".csv", sep="")
#
#print(path_1)
#print(path_2)
#print(path_3)
#print(path_4)

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index")
x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.1_rebalanced_outfile_new.csv.gz", data.table=FALSE)
dropped <- c("row_number", "chr", "variant_pos","TISSUE", "REF", "ALT")
x <- x[ , !(names(x) %in% dropped)]

i <- 0.8
set.seed(3456)
trainIndex <- createDataPartition(x$CLASS, p = i,
                  list = FALSE, times = 1)

x_train <- x[as.vector(trainIndex),]
x_test <- x[as.vector(-trainIndex),]


Fit <- readRDS(path_1)

predicted <- predict(Fit, x_test, type="prob")
predicted_raw <- predict(Fit, x_test, type="raw")
confusionMatrix(data = predicted_raw, reference = factor(x_test$CLASS), positive = "Positive")

## This section of code extracts all the results form the confusion matrix function

thres <- c()
results_byClass <- c()
results_overall <- c()
results_table <- c()
names_byClass <- c()
names_overall <- c()
names_table <- c()

for (i in seq(0, 1, by=0.005)) {
	#based on the value i, then assign C as the class
	pred <- predicted %>% mutate(C = ifelse(Negative > i, "Negative", "Positive"))
	pred <- pred$C
	a <- confusionMatrix(data = factor(pred), reference = factor(x_test$CLASS), positive = "Positive")
	
	#extract the byClass attributes from the confusionMatrix for a given value of i
	for (j in seq(1, length(a$byClass), by=1)) {	
		results_byClass <- c(results_byClass, a$byClass[[j]])	
	}

	#extract the overall attributes from the confusionMatrix for a given value of i
	for (j in seq(1, length(a$overall), by=1)) {
                results_overall <- c(results_overall, a$overall[[j]])
        }

	#extract the table attributes from the confusionMatrix for a given value of i
	for (j in seq(1, length(a$table), by=1)) {
                results_table <- c(results_table, a$table[[j]])
        }


	thres  <- c(thres, i)
}

#these are to get the names of the different attributes
for (j in seq(1, length(a$byClass), by=1)) {
	names_byClass <- c(names_byClass, names(a$byClass[j]))
}


for (j in seq(1, length(a$overall), by=1)) {
        names_overall <- c(names_overall, names(a$overall[j]))
}

names_table <- c("TN", "FP", "FN", "TP")


#these are to reshape the matrix into something more understandable and make it into a df
results_byClass <- matrix(unlist(results_byClass), ncol = length(results_byClass)/length(a$byClass), nrow = length(a$byClass))
results_byClass <- as.data.frame(t(results_byClass))
colnames(results_byClass) <- names_byClass


results_overall <- matrix(unlist(results_overall), ncol = length(results_overall)/length(a$overall), nrow = length(a$overall))
results_overall <- as.data.frame(t(results_overall))
colnames(results_overall) <- names_overall


results_table <- matrix(unlist(results_table), ncol = length(results_table)/length(a$table), nrow = length(a$table))
results_table <- as.data.frame(t(results_table))
colnames(results_table) <- names_table


full_results <- data.frame(results_byClass, results_overall, results_table)
write.csv(full_results, path_2)
#write.csv(predictors(Fit), path_4)

q()
### This section plots the ROC curves

par(pty="s") 


vdata_Y <- data.frame(x_test$CLASS,predicted)
colnames(vdata_Y)[1] <- "CLASS"

#this calculates the AUC 
roc(vdata_Y$CLASS, vdata_Y$Positive)

#This plots the ROC curve with some error margins
roc1 <- roc(vdata_Y$CLASS, vdata_Y$Negative, percent=TRUE,
            # arguments for auc
            partial.auc=c(100, 0), partial.auc.correct=TRUE,
            partial.auc.focus="sens",
            # arguments for ci
            ci=TRUE, boot.n=100, ci.alpha=0.9, stratified=FALSE,
            # arguments for plot
            plot=TRUE, auc.polygon=TRUE, max.auc.polygon=TRUE, grid=TRUE,
            print.auc=TRUE, show.thres=TRUE, legacy.axes=TRUE)

sens.ci <- ci.se(roc1, specificities=seq(0, 100, 5))
plot(sens.ci, type="shape", col="lightblue")
plot(sens.ci, type="bars")

#This plots the ROC curve much more simply
lrROC <- roc(vdata_Y$CLASS, vdata_Y$Negative,plot=TRUE,print.auc=TRUE,col="green",lwd =4,legacy.axes=TRUE,main="ROC Curves")

#prep data
data_combined <- data.frame(predicted_raw, x_test$CLASS, predicted)
colnames(data_combined)[1] <- "pred"
colnames(data_combined)[2] <- "obs"

#metrics
mnLogLoss(data_combined, lev=c("Positive","Negative"))
mnLogLoss(data_combined, lev=c("Negative","Positive"))
defaultSummary(data_combined, lev=c("Negative","Positive"))
twoClassSummary(data_combined, lev=c("Negative","Positive"))
prSummary(data_combined, lev=c("Negative","Positive"))

#
lift_results <- predict(Fit, x_test, type = "prob")[,"Negative"]
lift_results <- data.frame(lift_results)
lift_results <- data.frame(x_test$CLASS, lift_results)
colnames(lift_results)[1] <- "Class"
colnames(lift_results)[2] <- "prob"

trellis.par.set(caretTheme())
lift_obj <- lift(Class ~ prob, data = lift_results)
plot(lift_obj, values = 60, auto.key = list(columns = 1,
                                            lines = TRUE,
                                            points = FALSE))


plot(b$thres, b$bal_accuracy)


