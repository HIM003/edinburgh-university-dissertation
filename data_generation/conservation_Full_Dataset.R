#####################################################################################################
#
# This code is used to get the conservation scores 
#
#
#####################################################################################################

library(tidyverse)
library(GenomicRanges)
library(GenomicScores)
library(R.utils)
library(BiocManager)
library(phastCons100way.UCSC.hg38)
library(phastCons7way.UCSC.hg38)

#BiocManager::install("phastCons7way.UCSC.hg38")
#BiocManager::install("phastCons100way.UCSC.hg38")

phast <- phastCons100way.UCSC.hg38
setwd("D:/OneDrive/Documents/Edinburgh Uni/Dissertation/scripts")

#we will get the conversation scores for each variant in the GTEx dataset 
eqtl<-read_tsv("D:/Dissertation_Data/GTEx_Analysis_2017-06-05_v8_WholeGenomeSeq_838Indiv_Analysis_Freeze.lookup_table.txt")
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

#gscores(phast, GRanges("chr1:146321543-146321543"))
phast_scores <- gscores(phast, eqtl_GR)
phast_scores <- data.frame(as.data.frame(phast_scores), keep.extra.columns=TRUE)


#delete unnecessary columns
phast_scores <- phast_scores[ , !names(phast_scores) %in% c("width","strand","keep.extra.columns")]
colnames(phast_scores)[length(colnames(phast_scores))] <- "phastCons100way.UCSC.hg38"
write.csv(phast_scores, file = "D:/OneDrive/Documents/Edinburgh Uni/Dissertation/prepared_datasets/phastCons100way.UCSC.hg38_full_dataset.csv")
