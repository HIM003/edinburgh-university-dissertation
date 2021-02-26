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
x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz", data.table=FALSE)
dropped <- c("row_number", "chr", "variant_pos","TISSUE", "REF", "ALT")
x <- x[ , !(names(x) %in% dropped)]

i <- 0.80
set.seed(3456)
trainIndex <- createDataPartition(x$CLASS, p = i,
                  list = FALSE, times = 1)

x_train <- x[as.vector(trainIndex),]
x_test <- x[as.vector(-trainIndex),]

LogitBoost <- readRDS("RDS/0_05/LogitBoost_tunelength_down_0_05.RDS")
xgbTree <- readRDS("RDS/0_05/xgbTree_tunelength_down_0_05.RDS")
LogRegression <- readRDS("RDS/0_05/regLogistic_tunelength_down_0_05.RDS")
lda <- readRDS("RDS/0_05/lda_tunelength_down_0_05.RDS")
lda2 <- readRDS("RDS/0_05/lda2_tunelength_down_0_05.RDS")
gbm <- readRDS("RDS/0_05/gbmfit_tunelength_down_0_05.RDS")
naivebayes <- readRDS("RDS/0_05/naivebayes_tunelength_down_0_05.RDS")
knn <- readRDS("RDS/0_05/knn_tunelength_down_0_05.RDS")
ranger <- readRDS("RDS/0_05/ranger_tunelength_down_0_05.RDS")
bag <- readRDS("RDS/0_05/bag_tunelength_down_0_05.RDS")
nodeHarvest <- readRDS("RDS/0_05/nodeHarvest_tunelength_down_0_05.RDS")
kknn <- readRDS("RDS/0_05/kknn_tunelength_down_0_05.RDS")
adabag <- readRDS("RDS/0_05/adabag_tunelength_down_0_05.RDS")
ada <- readRDS("RDS/0_05/ada_tunelength_down_0_05.RDS")
evtree <- readRDS("RDS/0_05/evtree_tunelength_down_0_05.RDS")
glm <- readRDS("RDS/0_05/glm_tunelength_down_0_05.RDS")
bagFDAGCV <- readRDS("RDS/0_05/bagFDAGCV_tunelength_down_0_05.RDS")




names_ <- c("roc_LogitBoost","roc_xgbTree","roc_LogRegression", "roc_lda", "roc_lda2", "roc_gbm", "roc_naivebayes", "roc_knn","roc_ranger", "roc_bag", "roc_nodeHarvest","roc_kknn", "roc_adabag", "roc_ada", "roc_evtree", "roc_glm", "roc_bagFDAGCV")
names_pr <- c("pr_LogitBoost","pr_xgbTree","pr_LogRegression", "pr_lda", "pr_lda2", "pr_gbm", "pr_naivebayes", "pr_knn","pr_ranger", "pr_bag", "pr_nodeHarvest","pr_kknn", "pr_adabag", "pr_ada", "pr_evtree", "pr_glm", "pr_bagFDAGCV")
#names_ <- c("roc_0_05", "roc_0_10", "roc_0_25")
#names_lift <- c("lift_0_05", "lift_0_10", "lift_0_25")
auc <- c()
pr <- c()
#LogitBoost, xgbTree, LogRegression, lda, lda2, gbmfit, naivebayes, ranger, bag, nodeHarvest, kknn, adabag_, ada, evtree, glm, bagFDAGCV
j = 1

for (i in list(LogitBoost, xgbTree, LogRegression, lda, lda2, gbm, naivebayes, knn, ranger, bag, nodeHarvest, kknn, adabag, ada, evtree, glm, bagFDAGCV)) { 
		
		predicted <- predict(i, x_test, type="prob")
		all_data <- cbind(data.frame(x_test$CLASS), data.frame(predicted))
		roc_results <- roc(all_data[,1], all_data[,3])
		auc <- c(auc, round(roc_results$auc[1],digits=3))
		roc_results_data <- data.frame(roc_results$sensitivities, roc_results$specificities)
		colnames(roc_results_data) <- c("sens", "spec")
		roc_results_data$one_min_spec <- 1 - roc_results_data$spec
		assign(names_[j], roc_results_data)
		all_data <- data.frame()
		rm(roc_results_data)
		
		#PR curve
		predicted <- predict(i, x_test, type="prob")
		all_data <- cbind(data.frame(predicted), data.frame(x_test$CLASS))
		pr_curve <- evalm(all_data[,1:3],plots='r',rlinethick=0.8,fsize=8,bins=8)
		
		for (i in seq(1:length(rownames(pr_curve$optres$Group1)))) {
  			if(rownames(pr_curve$optres$Group1)[i] == "AUC-PR") {
    				pr <- c(pr, round((pr_curve$optres$Group1$Score)[i],digits=3))
				print((pr_curve$optres$Group1$Score)[i])
  			}
		}		
		

		pr_curve <- data.frame(pr_curve$proc$data$SENS, pr_curve$proc$data$PREC)
		colnames(pr_curve) <- c("sens","prec")
		assign(names_pr[j], pr_curve)
		all_data <- data.frame()
		rm(pr_curve)
		
			
		#lift calcs
		#lift_results <- predict(i, x_test, type = "prob")
		#lift_results <- data.frame(lift_results[,"Negative"])
		#lift_results <- data.frame(x_test$CLASS, lift_results)
		#colnames(lift_results)[1:2] <- c("Class","prob")
		#assign(names_lift[j], lift_results)
		
		j = j + 1

}


name_1 <- paste("LogitBoost AUC =",auc[1],sep=" ")
name_2 <- paste("xgbTree AUC =",auc[2],sep=" ")
name_3 <- paste("LogRegression AUC =",auc[3],sep=" ")
name_4 <- paste("lda AUC =",auc[4],sep=" ")
name_5 <- paste("lda2 AUC =",auc[5],sep=" ")
name_6 <- paste("gbm AUC =",auc[6],sep=" ")
name_7 <- paste("naivebayes AUC =",auc[7],sep=" ")
name_8 <- paste("knn AUC =",auc[8],sep=" ")
name_9 <- paste("ranger AUC =",auc[9],sep=" ")
name_10 <- paste("bag AUC =",auc[10],sep=" ")
name_11 <- paste("nodeHarvest AUC =",auc[11],sep=" ")
name_12 <- paste("kknn AUC =",auc[12],sep=" ")
name_13 <- paste("adabag AUC =",auc[13],sep=" ")
name_14 <- paste("ada AUC =",auc[14],sep=" ")
name_15 <- paste("evtree AUC =",auc[15],sep=" ")
name_16 <- paste("glm AUC =",auc[16],sep=" ")
name_17 <- paste("bagFDAGCV AUC =",auc[17],sep=" ")

ggplot() + geom_line(data=roc_LogitBoost, aes(one_min_spec,sens,color=name_1),size=3)+
	        geom_line(data=roc_xgbTree, aes(one_min_spec,sens,color=name_2),size=3)+
                geom_line(data=roc_LogRegression, aes(one_min_spec,sens,color=name_3),size=3)+
                geom_line(data=roc_lda, aes(one_min_spec,sens,color=name_4),size=3)+
                #geom_line(data=roc_lda2, aes(one_min_spec,sens,color=name_5),size=3)+
                geom_line(data=roc_gbm, aes(one_min_spec,sens,color=name_6),size=3)+
                geom_line(data=roc_naivebayes, aes(one_min_spec,sens,color=name_7),size=3)+
                geom_line(data=roc_knn, aes(one_min_spec,sens,color=name_8),size=3)+
                geom_line(data=roc_ranger, aes(one_min_spec,sens,color=name_9),size=3)+
                geom_line(data=roc_bag, aes(one_min_spec,sens,color=name_10),size=3)+
                geom_line(data=roc_nodeHarvest, aes(one_min_spec,sens,color=name_11),size=3)+
                #geom_line(data=roc_kknn, aes(one_min_spec,sens,color=name_12),size=3)+
                geom_line(data=roc_adabag, aes(one_min_spec,sens,color=name_13),size=3)+
                geom_line(data=roc_ada, aes(one_min_spec,sens,color=name_14),size=3)+
                geom_line(data=roc_evtree, aes(one_min_spec,sens,color=name_15),size=3)+
                geom_line(data=roc_glm, aes(one_min_spec,sens,color=name_16),size=3)+
                geom_line(data=roc_bagFDAGCV, aes(one_min_spec,sens,color=name_17),size=3)+
    		ggtitle("ROC Curve") + xlab("False Positive Rate") + ylab("True Positive Rate") +
		theme(axis.title.x = element_text(size=28), axis.title.y = element_text(size=28), axis.text.x = element_text( angle = 0,  hjust = 1, size = 18 ), axis.text.y = element_text( size = 18 ),
 	        plot.title = element_text(size=34), strip.text = element_text(size=34), legend.text = element_text(color = "blue", size = 28), legend.title = element_blank()) 


ggsave("compare_all_new.png", width = 15, height = 15)







name_1 <- paste("LogitBoost AUC =",pr[1],sep=" ")
name_2 <- paste("xgbTree AUC =",pr[2],sep=" ")
name_3 <- paste("LogRegression AUC =",pr[3],sep=" ")
name_4 <- paste("lda AUC =",pr[4],sep=" ")
name_5 <- paste("lda2 AUC =",pr[5],sep=" ")
name_6 <- paste("gbm AUC =",pr[6],sep=" ")
name_7 <- paste("naivebayes AUC =",pr[7],sep=" ")
name_8 <- paste("knn AUC =",pr[8],sep=" ")
name_9 <- paste("ranger AUC =",pr[9],sep=" ")
name_10 <- paste("bag AUC =",pr[10],sep=" ")
name_11 <- paste("nodeHarvest AUC =",pr[11],sep=" ")
name_12 <- paste("kknn AUC =",pr[12],sep=" ")
name_13 <- paste("adabag AUC =",pr[13],sep=" ")
name_14 <- paste("ada AUC =",pr[14],sep=" ")
name_15 <- paste("evtree AUC =",pr[15],sep=" ")
name_16 <- paste("glm AUC =",pr[16],sep=" ")
name_17 <- paste("bagFDAGCV AUC =",pr[17],sep=" ")

ggplot() + geom_line(data=pr_LogitBoost, aes(sens, prec,color=name_1), size=3)+
                geom_line(data=pr_xgbTree, aes(sens, prec,color=name_2), size=3) +
                geom_line(data=pr_LogRegression, aes(sens,prec,color=name_3), size=3) +
                geom_line(data=pr_lda, aes(sens,prec,color=name_4), size=3)+
                #geom_line(data=pr_lda2, aes(sens,prec,color=name_5), size=3)+
                geom_line(data=pr_gbm, aes(sens,prec,color=name_6), size=3)+
                geom_line(data=pr_naivebayes, aes(sens,prec,color=name_7), size=3)+
                geom_line(data=pr_knn, aes(sens,prec,color=name_8), size=3)+
                geom_line(data=pr_ranger, aes(sens,prec,color=name_9), size=3)+
                geom_line(data=pr_bag, aes(sens,prec,color=name_10), size=3)+
                geom_line(data=pr_nodeHarvest, aes(sens,prec,color=name_11), size=3)+
                #geom_line(data=pr_kknn, aes(sens,prec,color=name_12), size=3)+
                geom_line(data=pr_adabag, aes(sens,prec,color=name_13), size=3)+
                geom_line(data=pr_ada, aes(sens,prec,color=name_14), size=3)+
                geom_line(data=pr_evtree, aes(sens,prec,color=name_15), size=3)+
                geom_line(data=pr_glm, aes(sens,prec,color=name_16), size=3)+
                geom_line(data=pr_bagFDAGCV, aes(sens,prec,color=name_17), size=3)+
                ggtitle("Precision-Recall Curve") + xlab("Recall") + ylab("Precision") +
                theme(axis.title.x = element_text(size=28), axis.title.y = element_text(size=28), axis.text.x = element_text( angle = 0,  hjust = 1, size = 18 ), axis.text.y = element_text( size = 18 ),
                plot.title = element_text(size=34), strip.text = element_text(size=34), legend.text = element_text(color = "blue", size = 28), legend.title = element_blank())


ggsave("compare_all_pr_new.png", width = 15, height = 15)


