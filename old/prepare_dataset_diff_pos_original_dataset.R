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
x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos.csv", data.table=FALSE)
#x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/outfile.csv", data.table=FALSE)
print("finished reading full dataset")
print(dim(x))
x <- x %>% drop_na(phastCons7way.UCSC.hg38, phastCons100way.UCSC.hg38)
x <- subset(x, chr != "chrX")	

#drops <- c("row_number", "CLASS", "TISSUE", "REF", "ALT")
#x <- x[ , !(names(x) %in% drops)]

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
values <- table(x_neg$chr) / table(x_pos$chr)
print(values)
x_neg_names <- unique(x_neg$chr)
x_comp <- data.frame()

j = 1
for (i in seq(1,length(x_neg_names),1)) {
               
	for (j in seq(1,length(x_neg_names),1)) {

                if (x_neg_names[i] == names(values[j])) {

       			 x_pos_chr <- x_pos %>% filter(x_pos$chr == x_neg_names[i])
        		 k = 0.027 * values[j]
        		 set.seed(3456)
        		 trainIndex <- createDataPartition(x_pos_chr$CLASS, p = k,
             		 	list = FALSE, times = 1)
        		 x_pos_chr <- x_pos_chr[as.vector(trainIndex),]
        		 x_comp <- bind_rows(x_comp, x_pos_chr)
			 dim(x_comp)
                }
	}
j=1
}


x_comp <- bind_rows(x_comp, x_neg)
x_comp$comb <- paste(x_comp$chr, x_comp$CLASS, sep="_")
print(table(x_comp$comb))
print(table(x_comp$CLASS))

fwrite(x_comp, file="rebalanced_to_original.csv", sep=",")


