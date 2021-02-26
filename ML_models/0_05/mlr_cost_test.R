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
library("dplyr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("tidyverse", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("AppliedPredictiveModeling", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("ggplot2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("reshape2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("kernlab", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("pryr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("caret", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("ParamHelpers", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("mlr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("C50", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")


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

i <- 0.01
set.seed(3456)
trainIndex <- createDataPartition(x$CLASS, p = i,
                  list = FALSE, times = 1)

x_train <- x[as.vector(trainIndex),]
x_test <- x[as.vector(-trainIndex),]


##THRESHOLDING APPROACH
#prepare data
eQTL = makeClassifTask(data = x_train, target = "CLASS") 
eQTL = removeConstantFeatures(eQTL)

#cost matrix
costs = matrix(c(0, 1, 5, 0), 2)
colnames(costs) = rownames(costs) = getTaskClassLevels(eQTL)

#standard classification approach
lrn = makeLearner("classif.C50", predict.type = "prob")
mod = train(lrn, eQTL)
pred = predict(mod, task = eQTL)

#applying the cost matrix to the predicted data
th = costs[2,1]/(costs[2,1] + costs[1,2])
pred.th = setThreshold(pred, th)

#performance using the cost matrix
eQTL.costs = makeCostMeasure(id = "eQTL_costs", name = "eQTL costs", costs = costs, best = 0, worst = 5)
performance(pred, measures = list(eQTL.costs, mmce))
performance(pred.th, measures = list(eQTL.costs, mmce))
calculateConfusionMatrix(pred, relative = FALSE, sums = FALSE, set = "both")
calculateConfusionMatrix(pred.th, relative = FALSE, sums = FALSE, set = "both")

#cross-validated performance with theoretical thresholds
rin = makeResampleInstance("CV", iters = 3, task = eQTL)
lrn = makeLearner("classif.C50", predict.type = "prob", predict.threshold = th)
r = resample(lrn, eQTL, resampling = rin, measures = list(eQTL.costs, mmce), show.info = FALSE)

# Cross-validated performance with default thresholds
performance(setThreshold(r$pred, 0.5), measures = list(eQTL.costs, mmce))
calculateConfusionMatrix(r$pred, relative = FALSE, sums = FALSE, set = "both")


d = generateThreshVsPerfData(r, measures = list(eQTL.costs, mmce))
plotThreshVsPerf(d, mark.th = th)

# Tune the threshold based on the predicted probabilities on the 3 test data sets
tune.res = tuneThreshold(pred = r$pred, measure = eQTL.costs)
tune.res


d = generateThreshVsPerfData(r, measures = list(eQTL.costs, mmce))
plotThreshVsPerf(d, mark.th = tune.res$th)


##REBALANCING APPROACH
# Weight for positive class corresponding to theoretical treshold
w = (1 - th)/th
# some algorithms accept observation weights like C50
lrn = makeLearner("classif.C50", predict.type = "prob")
#lrn = makeWeightedClassesWrapper(lrn, wcw.weight = w)
#r = resample(lrn, eQTL, rin, measures = list(eQTL.costs, mmce), show.info = FALSE)
lrn = makeWeightedClassesWrapper(lrn)

ps = makeParamSet(makeDiscreteParam("wcw.weight", seq(1, 12, 0.5)))
ctrl = makeTuneControlGrid()
tune.res = tuneParams(lrn, eQTL, resampling = rin, par.set = ps,
  measures = list(eQTL.costs, mmce, logloss, acc, auc, bac, ber, f1, fp, fn, tp, tn, fnr, fpr, tnr, tpr), control = ctrl, show.info = FALSE)
as.data.frame(tune.res$opt.path)


lrn = makeLearner("classif.C50", predict.type = "prob")
lrn = makeWeightedClassesWrapper(lrn, wcw.weight = 3)
#r = resample(lrn, eQTL, rin, measures = list(eQTL.costs, mmce), show.info = FALSE)
mod = train(lrn, eQTL)
pred = predict(mod, task = eQTL)
performance(pred.th, measures = list(eQTL.costs, mmce))
calculateConfusionMatrix(pred, relative = FALSE, sums = FALSE, set = "both")



#some algorithms accept class weights
lrn = makeWeightedClassesWrapper("classif.ksvm", wcw.weight = w)
r = resample(lrn, eQTL, rin, measures = list(eQTL.costs, mmce), show.info = FALSE)



q()


print("just about to train")
print(Sys.time())
set.seed(825)

print("just about to save")
print(Sys.time())


saveRDS(Fit, "svmRadialCost_tunelength_down_0_05.RDS")

