###############################################################################################################
# This script takes the CAVIAR dataset where you can specify the posterior probability threshold and extract
# these from the full prepeared dataset.  It also takes the same number of negative samples from the full prepared
# dataset, whilst respecting the number per chromosome
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
library("AppliedPredictiveModeling", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("ggplot2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("reshape2", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index/")
print("reading full dataset")
x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned.csv", data.table=FALSE)
#x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/outfile.csv", data.table=FALSE)
print("finished reading full dataset")
x <- x %>% drop_na(phastCons7way.UCSC.hg38, phastCons100way.UCSC.hg38)
x <- subset(x, chr != "chrX")	

drops <- c("row_number", "CLASS", "TISSUE", "REF", "ALT")
x <- x[ , !(names(x) %in% drops)]

pos_data <- read_tsv("/exports/csce/eddie/inf/groups/mamode_prendergast/Data/GTEx_v8_finemapping_CAVIAR/CAVIAR_Results_v8_GTEx_LD_HighConfidentVariants")
pos_data <- pos_data %>% filter(Probability>0)
pos_data$CHROM <- paste("chr", pos_data$CHROM, sep="")

x$comb <- paste(x$chr, x$variant_pos, sep="_")
x <- x %>% distinct(comb, .keep_all= TRUE)

x <- left_join(x, pos_data, by = c("chr" = "CHROM", "variant_pos" = "POS"))

print(dim(x))

x <- x %>% mutate(x, CLASS = ifelse(is.na(Probability), "Negative", "Positive"))

#print(colnames(x))
#x$CLASS_chr <- paste(x$CLASS, x$chr, sep="_")

##i <- sum(x$CLASS == "Positive") / sum(x$CLASS == "Negative")
##
##x_pos <- x %>% filter(x$CLASS == "Positive")
##x <- x %>% filter(x$CLASS == "Negative")
##x_comp <- data.frame()
##
##set.seed(3456)
##trainIndex <- createDataPartition(x$CLASS, p = i,
##                 list = FALSE, times = 1, y=x$chr)
##x <- x[as.vector(trainIndex),]
##
##print(dim(x))
##
##x_comp <- bind_rows(x, x_pos)
##x <- x_comp
##print(table(x$CLASS))



x_pos <- x %>% filter(x$CLASS == "Positive")
x_neg <- x %>% filter(x$CLASS == "Negative")
x_pos_table <- table(x_pos$chr) / table(x_neg$chr)
x_neg_names <- unique(x_neg$chr)
x_comp <- data.frame()

j = 1
for (i in seq(1,length(x_neg_names),1)) {
        print(i)

        for (j in seq(1,length(x_neg_names),1)) {

                if (x_neg_names[i] == names(x_pos_table[j])) {
                        print("here")
                        x_neg_chr <- x_neg %>% filter(x_neg$chr == x_neg_names[i])
                        k = x_pos_table[j]
                        set.seed(3456)
                        trainIndex <- createDataPartition(x_neg_chr$CLASS, p = k,
                           list = FALSE, times = 1)
                        x_neg_chr <- x_neg_chr[as.vector(trainIndex),]
                        x_comp <- bind_rows(x_comp, x_neg_chr)
                        dim(x_comp)
                }

        }

j = 1
}

x_comp <- bind_rows(x_comp, x_pos)
x_comp$comb <- paste(x_comp$chr, x_comp$CLASS, sep="_")
print(table(x_comp$comb))
dim(x_comp)

dropped_class <- subset(x_comp, select=c("chr","variant_pos","CLASS","TISSUE"))
drops <- c("chr","variant_pos","CLASS","TISSUE", "GENE","eQTL", "Probability","comb")
x_comp <- x_comp[ , !(names(x_comp) %in% drops)]
x_comp <- log(x_comp+1)
x_comp <- format(x_comp, digits = 5)
x_comp <- cbind(x_comp, dropped_class)
fwrite(x_comp, file="dataset_downsampled_cleaned_caret_5sf_CAVIAR_0.1_outfile.csv", sep=",")


