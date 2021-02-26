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
library(tools)

args <- commandArgs(trailingOnly = TRUE)
print(args[1])

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/sep_files")
data <- read_csv(args[1])
data <- data.frame(data)
col_name <- colnames(data)[1]

data_neg <- filter(data, CLASS %in% c(1))
data_pos <- filter(data, CLASS %in% c(2))

data_neg_count <- sum(length(data_neg[[1]]))
data_pos_count <- sum(length(data_pos[[1]]))

print(max(data_pos[[1]]))
print(max(data_neg[[1]]))

data_range <- seq(0,round_any(max(max(data_pos[[1]]), data_neg[[1]]),100000,f=ceiling), by = round_any(max(max(data_pos[[1]]), data_neg[[1]]),100000,f=ceiling)/20)

print(data_range)

data_neg_hist <- hist(data_neg[[1]],breaks=data_range)
data_pos_hist <- hist(data_pos[[1]],breaks=data_range)

c_ <- data.frame(data_pos_hist$mids,data_neg_hist$counts / data_neg_count,data_pos_hist$counts / data_pos_count)
colnames(c_) <- c('mids','Neg','Pos')

 
c_melted <- melt(c_, id.vars = "mids")

g <- ggplot(c_melted, aes(x = mids, y = value, colour = variable)) + 
  geom_point() + 
  geom_line() +
  xlab('Distance') +
  ylab('Relative Frequency') +
  ggtitle(col_name) 

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/sep_files/graphs")
ggsave(paste(col_name,".png",sep=""))
#full_data <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/test_full_dataset_v2.csv", select = c("chr", "variant_pos"), nrows=10)
