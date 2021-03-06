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
print("reading full dataset")
full_data <-fread("/exports/eddie/scratch/s1772751/Prepared_Data/full_dataset.csv", data.table=FALSE)
print("reading in Caveman results")
pos_data <- fread("/exports/eddie/scratch/s1772751/Prepared_Data/GTEx_v8_CaVEMaN_results_For_Eddie", data.table=FALSE)
print("about to join")
inCaveman<-semi_join(full_data, pos_data, by = c("chr" = "chr", "variant_pos" = "variant_pos"))
inCaveman$CLASS[is.na(inCaveman$CLASS)] <- 2
print("about to write")
fwrite(inCaveman, file="full_dataset_v3.csv.gz")





#dat2 <-read_tsv("/exports/csce/eddie/inf/groups/mamode_prendergast/Data/GTEx_v8_CaVEMaN_results")
#dat2$row_number <- rownames(dat2)
#dat2$row_number <- as.numeric(dat2$row_number)
#dat_new <- left_join(dat, dat2, by=c("row_number"="row_number"))


#as.vector(dat$chr)
#as.vector(dat$CHROM)

#dat_extract <- select(dat, chr, variant_pos,CHROM,POS)
#fwrite(dat_extract, "extract_new.csv")
#print(sum(ifelse(as.vector(dat$CHROM)==as.vector(dat$CHROM),1,0)))

#print(sum(ifelse(dat$chr==dat$CHROM,ifelse(dat$variant_pos==dat$POS,1,0),0)))

#col_names <- readLines("../col_names_v3.txt"me))
#col_names <- strsplit(col_names, ","me))
#col_namesx <- list()
#for (i in (1:length(col_names[[1]]))) {
#	col_namesx <- append(col_namesx, col_names[[1]][i])
#}
#
##col_names <- sapply(strsplit(col_names, '[, ]+'), function(x) toString(dQuote(x)))
#split_files <- list.files(pattern = "dt_split", recursive = TRUE, full.names = TRUE)
#other_dt <- fread("combined_new2.csv", data.table=FALSE)
#
#for (i in (1)) {
#	dt <- fread(split_files[i], data.table=FALSE)
#	print(split_files[i])
#	names(dt) <- col_namesx
#	#print(head(dt))
#	#print(head(other_dt))
#	new_dt <- left_join(dt, other_dt, by = c("row_number"="col_ref"))
#	new_file_name <- paste(split_files[i],'_new', sep="")
#	fwrite(new_dt, file = new_file_name)
#	remove(dt, new_dt)
#	gc()
#}


#setwd("/exports/eddie/scratch/s1772751/Prepared_Data/")
#
#cpg <- read_csv("eqtl_cpg_islands.csv")
#tss <- read_csv("eqtl_tss_filtered_v3.csv")
#phast100 <- read_csv("phastCons100way.UCSC.hg38_full_dataset.csv")
#phast7 <- read_csv("phastCons7way.UCSC.hg38_full_dataset.csv")
#
#combine <- merge(x=cpg,y=tss,by.x="col_ref",by.y="col_ref", all=TRUE)
#combine <- merge(x=combine,y=phast100,by.x="col_ref",by.y="col_ref", all=TRUE)
#combine <- merge(x=combine,y=phast7,by.x="col_ref",by.y="col_ref", all=TRUE)
#write.csv(combine, file = "combined.csv")


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


