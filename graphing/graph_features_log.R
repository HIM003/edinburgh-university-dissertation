#########################################################################################################
#
# This script is to plot the the negative and positive classes per chromosome as well as for different
# sampling ratios, except for plotting the log
#
#
#########################################################################################################



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

args <- commandArgs(trailingOnly = TRUE)
setwd("/exports/eddie/scratch/s1772751/Prepared_Data/sep_files_/files")
chr_data <- read_csv(args[1])
#read_csv("/exports/eddie/scratch/s1772751/Prepared_Data/sep_files/chr_new.csv")
chr_data <- data.frame(chr_data)
chr_data[[1]] <- log(chr_data[[1]]+1)
chr_data$CLASS[chr_data$CLASS==1] <- "Positive"
chr_data$CLASS[chr_data$CLASS==2] <- "Negative"
chr_data_pos <- chr_data %>% filter(chr_data$CLASS == "Positive")
chr_data <- chr_data %>% filter(chr_data$CLASS == "Negative")
chr_data_comp <- data.frame()

for (i in c(0.1,0.3,0.5,0.7,0.9)) {

	print(i)
	
	set.seed(3456)
	trainIndex <- createDataPartition(chr_data$CLASS, p = i,
		  list = FALSE, times = 1, y = chr_data$CLASS)
	chr_data_i <- chr_data[as.vector(trainIndex),]
        #print(chr_data_i)
	chr_data_i$CLASS[chr_data_i$CLASS=="Negative"] <- i


	#table(chr_data_comp$chr) / length(chr_data_comp$chr) * 100
	#table(chr_data$chr) / length(chr_data$chr) * 100

	chr_data_comp <- bind_rows(chr_data_comp, chr_data_i)
	print(length(chr_data_comp$CLASS))

}
chr_data <- bind_rows(chr_data, chr_data_comp, chr_data_pos)

#table(chr_data_comp$CLASS)
table(chr_data$CLASS)
#rm(chr_data_comp, chr_data_i, chr_data_pos)

chr_data <- chr_data %>% filter(chr!=c("chrX"))
write_csv(chr_data, "file_new_.csv")

for (i in c(2)){
  if(i==1) {
    set <- c(0.1,0.3,0.5,0.7,0.9,"Negative")
    labels_ <- c( "10% Neg Data", "30% Neg Data", "50% Neg Data", "70% Neg Data", "90% Neg Data", "100% Neg Data")
    graph_name <- paste(colnames(chr_data)[1],"10_Neg","30_Neg","50_Neg","70_Neg","90_Neg","100_Neg",".png",sep = "_")
  } else if (i==2) {
    set <- c("Negative","Positive")
    labels_ <- c("100% Neg Data", "100% Pos Data")
    graph_name <- paste(colnames(chr_data)[1],"100_Neg","100_Pos",".png",sep = "_")
  } else if (i==3) {
    set <- c(0.1,"Negative")
    labels_ <- c("10% Neg Data","100% Neg Data")
    graph_name <- paste(colnames(chr_data)[1],"10_Neg","100_Neg",".png",sep = "_")
  } else if (i==4) {
    set <- c(0.05,"Negative","Positive")
    labels_ <- c("5% Neg Data","100% Neg Data", "100% Pos Data")
    graph_name <- paste(colnames(chr_data)[1],"5_Neg","100_Neg","100_Pos",".png",sep = "_")
  } else if (i==5) {
    set <- c(0.1,"Negative","Positive")
    labels_ <- c("10% Neg Data","100% Neg Data", "100% Pos Data")
    graph_name <- paste(colnames(chr_data)[1],"10_Neg","100_Neg","100_Pos",".png",sep = "_")
  } else if (i==6) {
    set <- c(0.3,"Negative")
    labels_ <- c("30% Neg Data","100% Neg Data")
    graph_name <- paste(colnames(chr_data)[1],"30_Neg","100_Neg",".png",sep = "_")
  } else if (i==7) {
    set <- c(0.5,"Negative")
    labels_ <- c("50% Neg Data","100% Neg Data")
    graph_name <- paste(colnames(chr_data)[1],"50_Neg","100_Neg",".png",sep = "_")
  } else if (i==8) {
    set <- c(0.7,"Negative","Positive")
    labels_ <- c("70% Neg Data","100% Neg Data", "100% Pos Data")
    graph_name <- paste(colnames(chr_data)[1],"70_Neg","100_Neg","100_Pos",".png",sep = "_")
  } else if (i==9) {
    set <- c(0.9,"Negative","Positive")
    labels_ <- c("90% Neg Data","100% Neg Data", "100% Pos Data")    
    graph_name <- paste(colnames(chr_data)[1],"90_Neg","100_Neg","100_Pos",".png",sep = "_")
  } else {
    print("none")
  }
  
  data_full_compare_subset <- chr_data %>% filter(chr_data$CLASS %in% set)
  print(table(data_full_compare_subset$CLASS))
  #write_csv(data_full_compare_subset, paste("/exports/eddie/scratch/s1772751/Prepared_Data/sep_files_/",i,".csv", sep=""))
 # g <- ggplot(data_full_compare_subset,aes(x=data_full_compare_subset[[1]], fill=CLASS)) + geom_density(alpha=0.2) + facet_wrap(~chr, ncol = 6, scales = "free") +
  #  ggtitle(colnames(data_full_compare_subset)[1]) + xlab("Conservation Score") + scale_fill_discrete(labels = labels_) + scale_x_continuous(limits = c(0,1))
  
  g <- ggplot(data_full_compare_subset,aes(x=data_full_compare_subset[[1]], fill=CLASS)) + geom_density(alpha=0.2) + facet_wrap(~chr, ncol = 5, scales = "free") +
    ggtitle(colnames(data_full_compare_subset)[1]) + xlab("Genomic Distance") + scale_fill_discrete(labels = labels_)

  g <- g + theme(axis.title.x = element_text(size=34), axis.title.y = element_text(size=34), axis.text.x = element_text( angle = 0,  hjust = 1, size = 16 ), axis.text.y = element_text( size = 16 ),
	 plot.title = element_text(size=40), strip.text = element_text(size=34), legend.text = element_text(color = "blue", size = 34), legend.title = element_text(color = "blue", size = 28) ) + xlim(0,20)
  
  setwd("/exports/eddie/scratch/s1772751/Prepared_Data/sep_files_/graphs")
  ggsave(graph_name, width = 35, height = 20)
  
  print("saved graph")
}

