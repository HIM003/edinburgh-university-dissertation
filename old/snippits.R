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
library(tools)

setwd("/exports/eddie/scratch/s1772751/Prepared_Data/")

cpg <- read_csv("eqtl_cpg_islands.csv")
tss <- read_csv("eqtl_tss_filtered_v3.csv")
phast100 <- read_csv("phastCons100way.UCSC.hg38_full_dataset.csv")
phast7 <- read_csv("phastCons7way.UCSC.hg38_full_dataset.csv")

combine <- merge(x=cpg,y=tss,by.x="col_ref",by.y="col_ref", all=TRUE)
combine <- merge(x=combine,y=phast100,by.x="col_ref",by.y="col_ref", all=TRUE)
combine <- merge(x=combine,y=phast7,by.x="col_ref",by.y="col_ref", all=TRUE)
write.csv(combine, file = "combined_new.csv")



#sorted.out <- out[order(as.numeric(as.character(out$col_ref))), ]


#start_time <- Sys.time()
#mydt <- fread('eqtl_tss_filtered_v3.csv')
#end_time <- Sys.time()
#print("read in first dataframe")
#print(end_time - start_time)
#
#
#start_time <- Sys.time()
#mylookup_dt <- fread("dt_all.csv")
#end_time <- Sys.time()
#print("read in second dataframe")
#print(end_time - start_time)
#
#
#start_time <- Sys.time()
#new_dt <- mylookup_dt[mydt, on = c(row_number = "col_ref")]
#end_time <- Sys.time()
#print("joined dataframes")
#print(end_time - start_time)
#print(head(new_dt))
#
#start_time <- Sys.time()
#fwrite(new_dt, file = "peaks_tss.csv.gz")
#end_time <- Sys.time()
#print("saved dataframe")
#print(end_time - start_time)


