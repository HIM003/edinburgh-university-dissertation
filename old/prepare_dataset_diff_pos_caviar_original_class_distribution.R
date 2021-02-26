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
x <-fread("/exports/csce/eddie/inf/groups/mamode_prendergast/Data/outfile.csv", data.table=FALSE)
#x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/outfile.csv", data.table=FALSE)
x <- subset(x, chr != "chrX")	
x$comb <- paste(x$chr, x$variant_pos, sep="_")
x <- x %>% distinct(comb, .keep_all= TRUE)

pos_data <- read_tsv("/exports/csce/eddie/inf/groups/mamode_prendergast/Data/GTEx_v8_finemapping_CAVIAR/CAVIAR_Results_v8_GTEx_LD_HighConfidentVariants")
pos_data <- pos_data %>% filter(Probability>0.9)
pos_data$CHROM <- paste("chr", pos_data$CHROM, sep="")
pos_data <- subset(pos_data, CHROM != "chrX")	
#pos_data$comb <- paste(pos_data$CHROM, pos_data$POS, pos_data$TISSUE, sep="_")
#pos_data1 <- pos_data %>% distinct(comb, .keep_all= TRUE)
#y <- table(pos_data$comb) %>% as.data.frame() %>% 
#        arrange(desc(Freq))
x_pos_table <- table(pos_data$CHROM)/table(x$chr)
print(x_pos_table)
#print(pos_data[pos_data$comb=="chr19_21570287_Whole_Blood", ])

data_needing_mod <- read_csv("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_5sf_CAVIAR_0.9_outfile.csv")


#x <- left_join(x, pos_data, by = c("chr" = "CHROM", "variant_pos" = "POS"))
#print(dim(x))
#x <- x %>% mutate(x, CLASS = ifelse(is.na(Probability), "Negative", "Positive"))

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


data_needing_mod_pos <- data_needing_mod %>% filter(data_needing_mod$CLASS == "Positive")
data_needing_mod_neg <- data_needing_mod %>% filter(data_needing_mod$CLASS == "Negative")
#x_pos_table <- table(x_pos$chr) / table(x_neg$chr)
x_neg_names <- unique(data_needing_mod$chr)
print(x_neg_names)
x_comp <- data.frame()

j = 1
for (i in seq(1,length(x_neg_names),1)) {
	print(i)
        for (j in seq(1,length(x_neg_names),1)) {
		print(names(x_pos_table[j]))
		print(x_neg_names[i])
                if (x_neg_names[i] == names(x_pos_table[j])) {
                        data_needing_mod_chr <- data_needing_mod_pos %>% filter(data_needing_mod_pos$chr == x_neg_names[i])
                        k = x_pos_table[j]
                        set.seed(3456)
                        trainIndex <- createDataPartition(data_needing_mod_chr$CLASS, p = k,
                           list = FALSE, times = 1)
                        data_needing_mod_chr <- data_needing_mod_chr[as.vector(trainIndex),]
                        x_comp <- bind_rows(x_comp, data_needing_mod_chr)
                        print(dim(x_comp))
                }

        }

j = 1
}

x_comp <- bind_rows(x_comp, data_needing_mod_neg)
x_comp$comb <- paste(x_comp$chr, x_comp$CLASS, sep="_")
print(table(x_comp$comb))
print(dim(x_comp))
q()

dropped_class <- subset(x_comp, select=c("chr","variant_pos","CLASS","TISSUE"))
drops <- c("chr","variant_pos","CLASS","TISSUE", "GENE","eQTL", "Probability","comb")
x_comp <- x_comp[ , !(names(x_comp) %in% drops)]
x_comp <- log(x_comp+1)
x_comp <- format(x_comp, digits = 5)
x_comp <- cbind(x_comp, dropped_class)
fwrite(x_comp, file="dataset_downsampled_cleaned_caret_5sf_CAVIAR_0.5_outfile.csv", sep=",")


