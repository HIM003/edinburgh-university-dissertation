#####################################################################################################
#
# This code is to get the distance between the GTEx data and the Peaks Open Chromatin Data
#
#####################################################################################################

##libraries

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

######################################################################################################
#
# This section is to get the the distance between the GTEx data and the Peaks data
#
######################################################################################################

#setwd("/exports/csce/eddie/inf/groups/mamode_prendergast/Scripts")

#we will get the nearest Peak Chromoatin data to each eQTL in the full GTEx dataset
eqtl<-read_tsv("../Data/GTEx_Analysis_2017-06-05_v8_WholeGenomeSeq_838Indiv_Analysis_Freeze.lookup_table.txt")
eqtl <- eqtl[-c(1,6,7,8)]

#add the index as a column & select certain columns
eqtl$col_ref <- rownames(eqtl)
eqtl_chromatin<-(as.data.frame(select(eqtl, seqnames=chr, start=variant_pos, col_ref) %>% mutate(end=start)))
eqtl_chromatin$col_ref <- as.numeric(eqtl$col_ref)

eqtl_GR<-makeGRangesFromDataFrame(eqtl_chromatin, keep.extra.columns=TRUE)

#annoyingly biologists sometimes refer to chromosomes as "chr1" and sometimes just "1"
#the line below sets it so this is the same format for both granges
#if in doubt just run this every time make a granges object
seqlevelsStyle(eqtl_GR) <- "NCBI"


#Each represents the genomic locations of a particular type of chromatin data in a particular tissue/cell type.
#I have saved it from here ftp://ftp.ensembl.org/pub/current_regulation/homo_sapiens/Peaks

setwd("../Data/homo_sapiens/Peaks")

#find the paths of all the bed files in the folder
bed_files <- list.files(pattern = ".bed.gz$", recursive = TRUE, full.names = TRUE)

#for each bed file
for(i in (1:length(bed_files))) {
    #unzip the bed file, read in to chromatin variable, and name columns
    gunzip(bed_files[i], remove=FALSE, overwrite=TRUE)
    chromatin<-read_tsv(bed_files[i], col_names = FALSE)
    colnames(chromatin) <- c('seqnames','start','end','Gene_type','number','strand')
    #select only certain columns
    chromatin2<-select(chromatin, seqnames, start, end, strand) 
    #make granges object of chromatin locations
    chromatin_GR<-makeGRangesFromDataFrame(as.data.frame(chromatin2), keep.extra.columns=TRUE)
    try(seqlevelsStyle(chromatin_GR) <- "NCBI",TRUE)
    
    rm(chromatin, chromatin2)
    #get a hits object which provide index of each gene nearest to each eQTL
    #and the absolute distance between them
    dist<-distanceToNearest(eqtl_GR, chromatin_GR)
    
    dist <- data.frame(dist)
    print(bed_files[i])
    
    #delete unnecessary columns
    dist <- dist[ , !names(dist) %in% c("subjectHits")]
    #use name of folder structure to name column
    folders <- strsplit(bed_files[i],"/")
    col_name <- paste(folders[[1]][2],'_',folders[[1]][3],'_dist', sep="")
  
    write.csv(dist, file = paste("/exports/eddie/scratch/s1772751/Prepared_data/",col_name,".csv", sep=""))
}

######################################################################################################
#
# This section was becuase the names of the columns within the csv file was not descriptive and 
# was generically called 'distance'
#
######################################################################################################

##find the paths of all the files in the folder
#files <- list.files(pattern = ".zip$", recursive = TRUE, full.names = TRUE)
#
#for(i in (1:length(files))) {
#    
#   #name columns
#   folders <- strsplit(files[i],"/")
#   name <- substr(folders[[1]][3], 1, nchar(folders[[1]][3]) -8)
#...file_name_gz <- paste(name,'.csv.gz', sep="")
#   file_name_zip <- paste(name,'.csv.zip', sep="")
#...file_name_csv <- paste(name,'.csv', sep="")
#...file_gz <- paste(folders[[1]][1], folders[[1]][2], file_name_gz, sep="/")
#   file_zip <- paste(folders[[1]][1], folders[[1]][2], file_name_zip, sep="/")
#...file_csv <- paste(folders[[1]][1], folders[[1]][2], file_name_csv, sep="/")
#
#...unzip(file_zip)
#   chromatin<-read_csv(file_csv, col_names = TRUE)
#   names(chromatin)[names(chromatin) == 'distance'] <- name
#   chromatin <- chromatin[ , !names(chromatin) %in% c("queryHits")]
#    
#   write.csv(chromatin, file = gzfile(file_gz))
#
#}
#
######################################################################################################
#
# This section was used to combine a number of csv files together in an array format 
# 
#
######################################################################################################


#setwd("/exports/eddie/scratch/s1772751/Prepared_Data")
#temp = list.files(pattern="*.csv")
#named.list <- lapply(temp, read.csv)
#dt <- do.call(cbind, named.list)
#print("combined dt")
###colnames(dt)[1] <- c("row_number")
###dt <- dt[ , -which(names(dt) %in% c("X","X1"))]
#data.table::fwrite(dt, file = "peaks_tss.csv.gz")



