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

args <- commandArgs(trailingOnly = TRUE)
value <- args[1]
value_name_original <- paste("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_5sf_CAVEMAN_", value, "_rebalanced_outfile.csv", sep="")
value_name <- paste("dataset_downsampled_cleaned_caret_5sf_CAVEMAN_", value, "_rebalanced_outfile_new.csv", sep="")

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index/")
x <-fread(value_name_original, data.table=FALSE)
#x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/outfile_trial.csv", data.table=FALSE)
print("finished reading full dataset")
#x <- x %>% drop_na(phastCons7way.UCSC.hg38, phastCons100way.UCSC.hg38)
#x <- subset(x, chr != "chrX")	
#drops <- c("row_number", "CLASS", "TISSUE", "REF", "ALT")
#x <- x[ , !(names(x) %in% drops)]

pos_data <- read_tsv("/exports/csce/eddie/inf/groups/mamode_prendergast/Data/GTEx_v8_CaVEMaN_results")
pos_data <- pos_data %>% filter(Probability>value)
pos_data <- subset(pos_data, CHROM != "chrX")

#x$comb <- paste(x$chr, x$variant_pos, sep="_")
#x <- x %>% distinct(comb, .keep_all= TRUE)
#x <- left_join(x, pos_data, by = c("chr" = "CHROM", "variant_pos" = "POS"))
#x <- x %>% mutate(x, CLASS = ifelse(is.na(Probability), "Negative", "Positive"))

############################################################################################################### 
# Get originial data distribution
############################################################################################################### 

GTEx <-fread("/exports/csce/eddie/inf/groups/mamode_prendergast/Data/GTEX_chr_pos.csv", data.table=FALSE)
GTEx <- subset(GTEx, chr != "chrX")
GTEx$comb <- paste(GTEx$chr, GTEx$variant_pos, sep="_")
GTEx <- GTEx %>% distinct(comb, .keep_all= TRUE)

############################################################################################################### 
print(dim(GTEx))
print(dim(pos_data))
print(table(pos_data$CHROM)/table(GTEx$chr))

x_pos <- x %>% filter(x$CLASS == "Positive")
x_neg <- x %>% filter(x$CLASS == "Negative")



i <- 0.2
set.seed(3456)
trainIndex <- createDataPartition(x_pos$CLASS, p = i,
                  list = FALSE, times = 1, y=x_pos$chr)
x_pos <- x_pos[as.vector(trainIndex),]



x_pos_table <- table(GTEx$chr)/table(pos_data$CHROM)*table(x_pos$chr)/table(x_neg$chr)
print(x_pos_table)

x_neg_names <- unique(x_neg$chr)
x_comp <- data.frame()

j = 1
for (i in seq(1,length(x_neg_names),1)) {

        for (j in seq(1,length(x_neg_names),1)) {

                if (x_neg_names[i] == names(x_pos_table[j])) {
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
print("final distribution")
print(as.data.frame(table(x_comp$comb)))


#dropped_class <- subset(x_comp, select=c("chr","variant_pos","CLASS","TISSUE","REF","ALT"))
#drops <- c("chr","variant_pos","CLASS","TISSUE", "GENE","eQTL", "Probability","comb","REF","ALT")
#x_comp <- x_comp[ , !(names(x_comp) %in% drops)]
#x_comp <- log(x_comp+1)
#x_comp <- format(x_comp, digits = 5)
#x_comp <- cbind(x_comp, dropped_class)
fwrite(x_comp, file=value_name, sep=",")
