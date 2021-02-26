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
#library("doParallel", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
#library("doSNOW", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")

#cl <- makeForkCluster(3)
#registerDoParallel(cl)
#cl <- makeCluster(3, type = "FORKS")
#registerDoSNOW(cl)
#clusterCall(cl, function(x) .libPaths(x), .libPaths())
#clusterEvalQ(cl, .libPaths("/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/"))

print("This is using the tunelength")
print(Sys.time())

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index")
#print(mem_used())
print("reading full dataset")
x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_1.csv.gz", data.table=FALSE)
print("finished reading full dataset")
#print(mem_used())

drops <- c("row_number", "chr", "variant_pos", "TISSUE", "REF", "ALT")
x <- x[ , !(names(x) %in% drops)]


hcf_95 <- c("HCT116_Jund_dist", "IMR_90_CTCF_dist")
hcf_90 <- c("IMR_90_H2AK5ac_dist", "HCT116_SIN3A_dist", "M1_CB_H3K36me3_dist", "mononuclear_PB_H3K9ac_dist", "CD4_ab_T_Th_H3K4me1_dist", "H1_hESC_3_H3K4me3_dist","HCT116_SP1_dist","HSMM_H3K4me3_dist", "iPS_20b_H3K4me3_dist", "CM_CD4_ab_T_VB_H3K36me3_dist", "monocyte_VB_DNase1_dist", "CD8_ab_T_PB_H3K4me1_dist", "NHLF_H3K4me3_dist", "GM12878_H3K4me3_dist", "B_PB_H3K36me3_dist", "IMR_90_H3K4me3_dist", "CD4_ab_T_Th_H3K36me3_dist", "placenta_H3K36me3_dist", "CD8_ab_T_PB_H3K4me3_dist","HCT116_CEBPB_dist","HCT116_Srf_dist", "CD14_monocyte_PB_DNase1_dist", "myotube_H3K4me3_dist", "CD14_monocyte_PB_H3K36me3_dist","HCT116_Jund_dist", "IMR_90_CTCF_dist")

x <- x[ , !(names(x) %in% hcf_90)]

i <- 0.80
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

saveRDS(gbmFit, "gbmfit_tunelength_down_0_10_no_hcf.RDS")
