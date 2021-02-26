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
x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.1_rebalanced_outfile_new.csv.gz", data.table=FALSE)

dropped <- c("row_number", "chr", "variant_pos","TISSUE", "REF", "ALT")
x <- x[ , !(names(x) %in% dropped)]


i <- 0.80
set.seed(3456)
trainIndex <- createDataPartition(x$CLASS, p = i,
                  list = FALSE, times = 1)

x_train <- x[as.vector(trainIndex),]
x_test <- x[as.vector(-trainIndex),]

Weight_0.1 <- readRDS("RDS/trials/gbmfit_tunelength_caveman_original_dist_0.1_weighted.RDS")
Weight_0.3 <- readRDS("RDS/trials/gbmfit_tunelength_caveman_original_dist_0.3_weighted.RDS")
Weight_0.5 <- readRDS("RDS/trials/gbmfit_tunelength_caveman_original_dist_0.5_weighted.RDS")
Weight_0.7 <- readRDS("RDS/trials/gbmfit_tunelength_caveman_original_dist_0.7_weighted.RDS")
Weight_0.9 <- readRDS("RDS/trials/gbmfit_tunelength_caveman_original_dist_0.9_weighted.RDS")



names_ <- c("roc_Weight_0.1","roc_Weight_0.3", "roc_Weight_0.5", "roc_Weight_0.7", "roc_Weight_0.9")
names_pr <- c("pr_Weight_0.1", "pr_Weight_0.3", "pr_Weight_0.5", "pr_Weight_0.7", "pr_Weight_0.9")

auc <- c()
pr <- c()
#LogitBoost, xgbTree, LogRegression, lda, lda2, gbmfit, naivebayes, ranger, bag, nodeHarvest, kknn, adabag_, ada, evtree, glm, bagFDAGCV
j = 1

for (i in list(Weight_0.1, Weight_0.3, Weight_0.5, Weight_0.7, Weight_0.9)) { 
		
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
		
		
		j = j + 1

}


name_1 <- paste("Weights 0.1 AUC =",auc[1],sep=" ")
name_2 <- paste("Weights 0.3 AUC =",auc[2],sep=" ")
name_3 <- paste("Weights 0.5 AUC =",auc[3],sep=" ")
name_4 <- paste("Weights 0.7 AUC =",auc[4],sep=" ")
name_5 <- paste("Weights 0.9 AUC =",auc[5],sep=" ")


ggplot() + geom_line(data=roc_Weight_0.1, aes(one_min_spec,sens,color=name_1),size=3)+
	        geom_line(data=roc_Weight_0.3, aes(one_min_spec,sens,color=name_2),size=3)+
                geom_line(data=roc_Weight_0.5, aes(one_min_spec,sens,color=name_3),size=3)+
                geom_line(data=roc_Weight_0.7, aes(one_min_spec,sens,color=name_4),size=3)+
                geom_line(data=roc_Weight_0.9, aes(one_min_spec,sens,color=name_5),size=3)+
    		ggtitle("ROC Curve") + xlab("False Positive Rate") + ylab("True Positive Rate") +
		theme(axis.title.x = element_text(size=28), axis.title.y = element_text(size=28), axis.text.x = element_text( angle = 0,  hjust = 1, size = 18 ), axis.text.y = element_text( size = 18 ),
 	        plot.title = element_text(size=34), strip.text = element_text(size=34), legend.text = element_text(color = "blue", size = 28), legend.title = element_blank()) 


ggsave("compare_all_new_weights.png", width = 15, height = 15)





name_1 <- paste("Weights 0.1 AUC =",pr[1],sep=" ")
name_2 <- paste("Weights 0.3 AUC =",pr[2],sep=" ")
name_3 <- paste("Weights 0.5 AUC =",pr[3],sep=" ")
name_4 <- paste("Weights 0.7 AUC =",pr[4],sep=" ")
name_5 <- paste("Weights 0.9 AUC =",pr[5],sep=" ")


ggplot() + geom_line(data=pr_Weight_0.1, aes(sens, prec,color=name_1), size=3)+
                geom_line(data=pr_Weight_0.3, aes(sens, prec,color=name_2), size=3) +
                geom_line(data=pr_Weight_0.5, aes(sens,prec,color=name_3), size=3) +
                geom_line(data=pr_Weight_0.7, aes(sens,prec,color=name_4), size=3)+
                geom_line(data=pr_Weight_0.9, aes(sens,prec,color=name_5), size=3)+
                ggtitle("Precision-Recall Curve") + xlab("Recall") + ylab("Precision") +
                theme(axis.title.x = element_text(size=28), axis.title.y = element_text(size=28), axis.text.x = element_text( angle = 0,  hjust = 1, size = 18 ), axis.text.y = element_text( size = 18 ),
                plot.title = element_text(size=34), strip.text = element_text(size=34), legend.text = element_text(color = "blue", size = 28), legend.title = element_blank())


ggsave("compare_all_pr_new_weights.png", width = 15, height = 15)


