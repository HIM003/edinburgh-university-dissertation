library("tidyverse", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("AppliedPredictiveModeling", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("caret", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("gbm", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("pROC", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("data.table", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("MLeval", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("MLmetrics", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index")

x <-fread("dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.1_rebalanced_outfile_new.csv.gz", data.table=FALSE)

dropped <- c("row_number", "chr", "variant_pos","TISSUE", "REF", "ALT")
x <- x[ , !(names(x) %in% dropped)]

i <- 0.80
set.seed(3456)
trainIndex <- createDataPartition(x$CLASS, p = i,
                  list = FALSE, times = 1)
x_test <- x[as.vector(-trainIndex),]



rm(x)
#rm(Fit)
Fit <- readRDS("RDS/trials/gbmfit_tunelength_caveman_original_dist_0.9_weighted.RDS")
predicted <- predict(Fit, x_test, type="prob")
predicted_raw <- predict(Fit, x_test, type="raw")
a <- confusionMatrix(data = predicted_raw, reference = factor(x_test$CLASS), positive = "Positive")
print(a)
