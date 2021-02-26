###########################################################################################################################
#
# This is to get the highly correlated features
#
#
###########################################################################################################################



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

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index")
print("reading full dataset")
full_data <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned.csv.gz", data.table=FALSE)
print("finished reading full dataset")

drops <- c("row_number","chr","CLASS","TISSUE","REF","ALT")
full_data <- full_data[ , !(names(full_data) %in% drops)]
#full_data <- full_data %>% drop_na()

print(colnames(full_data))

descrCor <-  cor(full_data)
print(summary(descrCor[upper.tri(descrCor)]))

#highCorr <- (descrCor[upper.tri(descrCor)]) > .99
highlyCorDescr <- findCorrelation(descrCor, cutoff = .95)
highlyCorDescr90 <- findCorrelation(descrCor, cutoff = .90)
print(highlyCorDescr)
print(highlyCorDescr90)
#full_data <- full_data[,-highlyCorDescr]

#descrCor2 <- cor(full_data)
#summary(descrCor2[upper.tri(descrCor2)])

saveRDS(highlyCorDescr, "high_corr_features95.RDS")
saveRDS(highlyCorDescr90, "high_corr_features90.RDS")
saveRDS(colnames(full_data), "col_names.RDS")

#fwrite(full_data, file = "/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_corr_removed.csv", sep = ",")
