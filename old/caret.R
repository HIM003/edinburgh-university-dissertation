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
library("tidyverse", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("AppliedPredictiveModeling", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("ggplot2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("reshape2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("kernlab", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("gbm", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("pryr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("caret", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("doParallel", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index")
print(mem_used())
print("reading full dataset")
x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_test.csv", data.table=FALSE)
print("finished reading full dataset")
print(mem_used())

#dropped_class <- subset(x, select=c("CLASS"))
#drops <- c("row_number", "chr", "variant_pos", "CLASS", "TISSUE", "REF", "ALT")
#x <- x[ , !(names(x) %in% drops)]
#x <- log(x+1)
#x <- cbind(x, dropped_class)
#fwrite(x, file="dataset_downsampled_cleaned_caret.csv", sep=",")

#cl <- makePSOCKcluster(5)
#registerDoParallel(cl)

#clusterCall(cl, function(x) .libPaths(x), .libPaths())
#foreach(i = 1:2) %dopar% { .libPaths("/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/") library("caret") ... }

fitControl <- trainControl(
  method = "repeatedcv",
  number = 5,
  ## repeated ten times
  repeats = 2, verboseIter = TRUE, 
  returnResamp = "all",
  savePredictions = "all",
  classProbs = TRUE,
  summaryFunction = twoClassSummary)

print(mem_used())

set.seed(825)
gbmFit <- train(CLASS ~ ., data = x, 
                 method = "gbm", 
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
		 preProc = c("center", "scale"),                 
		 verbose = FALSE, 
                 tuneLength = 2,
		 metric = "ROC")

saveRDS(gbmFit, "gbmfit.RDS")
print(mem_used())

set.seed(825)
svmFit <- train(CLASS ~ ., data = x, 
                method = "svmRadial", 
                trControl = fitControl, 
                preProc = c("center", "scale"),
                verbose = FALSE,
		tuneLength = 8,
                metric = "ROC")

#stopCluster(cl)

saveRDS(svmFit, "svmfit.RDS")      
