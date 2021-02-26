library("tidyverse", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("data.table", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("plyr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("caret", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("dplyr", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library("AppliedPredictiveModeling", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/index/")
print("reading full dataset")
x <-fread("outfile_CaVEMaN.csv", data.table=FALSE)
#x <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/index/dataset_downsampled_cleaned_caret_5sf_CaVEMaN_0.5.csv", data.table=FALSE)
print("finished reading full dataset")

x$comb <- paste(x$chr, x$variant_pos, sep="_")
x <- x %>% distinct(comb, .keep_all= TRUE)


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

x_comp$comb <- paste(x_comp$chr, x_comp$variant_pos, sep="_")
x_comp <- x_comp %>% distinct(comb, .keep_all= TRUE)

dim(x_comp)
print(head(x_comp))

q()
