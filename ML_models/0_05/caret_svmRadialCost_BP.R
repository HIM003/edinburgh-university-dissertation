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
library("pryr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("caret", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("liquidSVM", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
#library("doParallel", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
#library("doSNOW", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")

#cl <- makeForkCluster(3)
#registerDoParallel(cl)
#cl <- makeCluster(3, type = "FORKS")
#registerDoSNOW(cl)
#clusterCall(cl, function(x) .libPaths(x), .libPaths())
#clusterEvalQ(cl, .libPaths("/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/"))

print("This is using svmRadialCost and tunelength")
print(Sys.time())

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index")
#print(mem_used())
print("reading full dataset")
x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv", data.table=FALSE)
print("finished reading full dataset")
#print(mem_used())

dropped <- c("row_number", "chr", "variant_pos","TISSUE", "REF", "ALT")
x <- x[ , !(names(x) %in% dropped)]
x$CLASS <- as.factor(x$CLASS)


#dropped_class <- subset(x, select=c("CLASS"))
#drops <- c("row_number", "chr", "variant_pos", "CLASS", "TISSUE", "REF", "ALT")
#x <- x[ , !(names(x) %in% drops)]
#x <- log(x+1)
#x <- cbind(x, dropped_class)
#fwrite(x, file="dataset_downsampled_cleaned_caret.csv", sep=",")

i <- 0.05
set.seed(3456)
trainIndex <- createDataPartition(x$CLASS, p = i,
                  list = FALSE, times = 1)

x_train <- x[as.vector(trainIndex),]
x_test <- x[as.vector(-trainIndex),]


x_train_new <- x_train[,1:length(x_train)-1]
y_target <- x_train[,length(x_train)]

#base kernal package
#kerner <- ksvm(as.matrix(x_train_new),y_target, type = "C-svc", kernel = 'vanilladot')

#liquidSVM package
kerner <- mcSVM(CLASS ~. , x_train, max_gamma=25)
kerner <- mcSVM(CLASS ~. , x_train, gammas=c(0.1,1,10,100))
kerner <- mcSVM(CLASS ~. , x_train, gamma_steps=10, min_gamma=0.2, max_gamma=125)
kerner <- mcSVM(CLASS ~. , x_train, gamma_steps=10, min_gamma=0.2, max_gamma=125, lambdas=c(1.0, 0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.0000001))
kerner <- rocSVM(CLASS ~. , x_train, max_gamma=3125)


result <- test(kerner, x_test)
errors(result)
predicted <- predict(kerner, x_test, type="prob")



saveRDS(kerner, "kerner_BP.RDS")
print(kerner)
print(Sys.time())

q()

fitContron <- trainControl(
  method = "cv",
  ## repeated ten times
  number = 3, verboseIter = TRUE,
  returnResamp = "final",
  savePredictions = "final",
#  classProbs = TRUE,
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
Fit <- train(CLASS ~ ., data = x_train,
                 method = "svmRadialCost",
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 preProc = c("center", "scale"),
                 verbose = FALSE,
                 tuneLength = 5)
#                 metric = "ROC")


print("just about to save")
print(Sys.time())

#stopCluster(cl)

saveRDS(Fit, "svmRadialCost_tunelength_down_0_05.RDS")

#predicted <- predict(gbmFit, x_test)
#print(head(predicted))
