###############################################################################################################
# This script can be modified to randomly downsample data
# 
# 
#
###############################################################################################################



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
library("pryr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("ggplot2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("reshape2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index")
print("reading full dataset")
full_data <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.1_rebalanced_outfile.csv", data.table=FALSE)
print("finished reading full dataset")
print(mem_used())
full_data$comb <- paste(full_data$chr, full_data$CLASS, sep="_")
print(as.data.frame(table(full_data$comb)))
q()
full_data_pos <- full_data %>% filter(full_data$CLASS == "Positive")
full_data <- full_data %>% filter(full_data$CLASS == "Negative")
full_data_comp <- data.frame()

i <- 0.10
set.seed(3456)
trainIndex <- createDataPartition(full_data$CLASS, p = i,
		  list = FALSE, times = 1, y=full_data$chr)
full_data <- full_data[as.vector(trainIndex),]

i <- 0.10
set.seed(3456)
trainIndex <- createDataPartition(full_data_pos$CLASS, p = i,
		  list = FALSE, times = 1, y=full_data_pos$chr)
full_data_pos <- full_data_pos[as.vector(trainIndex),]

print(mem_used())

full_data_comp <- bind_rows(full_data, full_data_pos)
print(length(full_data_comp$CLASS))
fwrite(full_data_comp, file = "dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.1_0.1_rebalanced_outfile.csv", sep = ",")

#table(chr_data_comp$chr) / length(chr_data_comp$chr) * 100
#table(chr_data$chr) / length(chr_data$chr) * 100
#table(chr_data_comp$CLASS)
#table(chr_data$CLASS)
