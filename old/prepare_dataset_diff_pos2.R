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

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index/")
print("reading full dataset")
x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/outfile.csv", data.table=FALSE)
print(dim(x))
print("finished reading full dataset")
#x <- x %>% drop_na(phastCons7way.UCSC.hg38, phastCons100way.UCSC.hg38)
x <- subset(x, chr != "chrX")	
print(dim(x))

q()

drops <- c("row_number", "CLASS", "TISSUE", "REF", "ALT")
x <- x[ , !(names(x) %in% drops)]

pos_data <- read_tsv("/exports/csce/eddie/inf/groups/mamode_prendergast/Data/GTEx_v8_CaVEMaN_results")
pos_data <- pos_data %>% filter(Probability>0.5)

#pos_data$comb <- paste(pos_data$CHROM, pos_data$POS, sep="_")
#pos_data <- pos_data %>% distinct(comb, .keep_all= TRUE)

x <- left_join(x, pos_data, by = c("chr" = "CHROM", "variant_pos" = "POS"))

print(dim(x))

x <- x %>% mutate(x, CLASS = ifelse(is.na(Probability), "Negative", "Positive"))

#print(colnames(x))
#x$CLASS_chr <- paste(x$CLASS, x$chr, sep="_")

i <- sum(x$CLASS == "Positive") / sum(x$CLASS == "Negative")

x_pos <- x %>% filter(x$CLASS == "Positive")
x <- x %>% filter(x$CLASS == "Negative")
x_comp <- data.frame()

set.seed(3456)
trainIndex <- createDataPartition(x$CLASS, p = i,
                  list = FALSE, times = 1, y=x$chr)
x <- x[as.vector(trainIndex),]

print(dim(x))

x_comp <- bind_rows(x, x_pos)
x <- x_comp
print(table(x$CLASS))



dropped_class <- subset(x, select=c("chr","variant_pos","CLASS","TISSUE","REF","ALT"))
drops <- c("chr","variant_pos","CLASS","TISSUE", "GENE","eQTL","REF", "ALT", "Probability")
x <- x[ , !(names(x) %in% drops)]
x <- log(x+1)
x <- format(x, digits = 5)
x <- cbind(x, dropped_class)
fwrite(x, file="dataset_downsampled_cleaned_caret_5sf_CaVEMaN_0.5.csv", sep=",")


