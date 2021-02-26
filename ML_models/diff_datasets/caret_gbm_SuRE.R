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
library("kernlab", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("gbm", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("pryr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")



args <- commandArgs(trailingOnly = TRUE)
threshold <- as.double(args[1])
balance <- as.double(args[2])
file_name <- paste("gbmfit_tunelength_down_SuRE_", threshold, ".RDS", sep="")

print(Sys.time())
setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index")
x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_SuRE_caret_5sf.csv.gz", data.table=FALSE)

#x <- x[!grepl("chrX", x$chr),]
#x <- x %>% drop_na(phastCons7way.UCSC.hg38, phastCons100way.UCSC.hg38)


x <- x %>% mutate(CLASS = ifelse(K562 <= threshold | hepg2 <= threshold, "Positive", "Negative"))
#dropped_class <- subset(x, select=c("K562","hepg2"))
#drops <- c("CLASS","K562", "hepg2", "chr", "variant_pos","TISSUE", "REF", "ALT", "comb", "row_number")
drops <- c("K562", "hepg2")
x <- x[ , !(names(x) %in% drops)]
#x <- log(x+1)
#x <- format(x, digits = 5)
#x <- cbind(x, dropped_class)


#fwrite(x,"dataset_downsampled_cleaned_SuRE_caret_5sf.csv.gz")
#q()

x_pos <- x %>% filter(x$CLASS == "Positive")
x_neg <- x %>% filter(x$CLASS == "Negative")

i <- balance / (table(x$CLASS)[[2]]  / table(x$CLASS)[[1]])
#i <- (table(x$CLASS)[[2]]/table(x$CLASS)[[1]]) / 0.65 * 100
set.seed(3456)
trainIndex <- createDataPartition(x_pos$CLASS, p = i,
                  list = FALSE, times = 1)

x_pos <- x_pos[as.vector(trainIndex),]
x <- bind_rows(x_neg, x_pos)


print(Sys.time())
print(mem_used())

i <- 0.70
set.seed(3456)
trainIndex <- createDataPartition(x$CLASS, p = i,
                  list = FALSE, times = 1)

x_train <- x[as.vector(trainIndex),]
x_test <- x[as.vector(-trainIndex),]



fitControl <- trainControl(
  method = "cv",
  ## repeated ten times
  number = 3, verboseIter = TRUE,
  returnResamp = "final",
  savePredictions = "final",
  classProbs = TRUE,
  summaryFunction = twoClassSummary,
  sampling = "down")

print(mem_used())
print(Sys.time())


#gbmGrid <- expand.grid(interaction.depth = c(1, 10),
#                        n.trees = c(100,500),
#                        shrinkage = c(.1, .25),
#                        n.minobsinnode = 10)


print("just about to train")
print(Sys.time())
set.seed(825)
gbmFit <- train(CLASS ~ ., data = x_train,
                 method = "gbm",
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 preProc = c("center", "scale"),
                 verbose = FALSE,
                 tuneLength = 5,
                 metric = "ROC")


print("just about to save")
print(Sys.time())

#stopCluster(cl)

saveRDS(gbmFit, file_name)
