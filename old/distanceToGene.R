library(tidyverse)
library(GenomicRanges)

setwd("D:/OneDrive/Documents/Edinburgh Uni/Dissertation")

#file containg the locations of the start of genes (gene start is termed TSS)
#obtained from https://www.ensembl.org/biomart/martview
tss<-read_tsv("tss_ensembl_98.txt")

#as an example 5we will just get nearest gene to each eQTL in CaVEMaN results
#however will want to annotate all variants not just these ones
eqtl<-read_tsv("GTEx_v8_finemapping_CaVEMaN/GTEx_v8_CaVEMaN_results")

#add the index as a column
eqtl$col_ref <- rownames(eqtl)

#rename columns as makeGRangesFromDataFrame needs to know the chromosome, position and strand columns
tss2<-select(tss, seqnames=Chromosome, start=TSS, strand=Strand, Gene_type, Gene_stable_ID) %>% mutate(end=start) 
#recode strand
tss2$strand<-recode(tss2$strand, "1"="+", "-1"="-")
#make granges object of TSS locations
tss_GR<-makeGRangesFromDataFrame(as.data.frame(tss2), keep.extra.columns=TRUE)

#do the same for the eqtl locations
#we unique the data frame as some eQTLs appear more than once
#though dont have to do this
eqtl2<-(as.data.frame(select(eqtl, seqnames=CHROM, start=POS, eQTL, col_ref) %>% mutate(end=start)))
eqtl2$col_ref <- as.numeric(eqtl$col_ref)

eqtl_GR<-makeGRangesFromDataFrame(eqtl2, keep.extra.columns=TRUE)
#annoyingly biologists sometimes refer to chromosomes as "chr1" and sometimes just "1"
#the line below sets it so this is the same format for both granges
#if in doubt just run this every time make a granges object
seqlevelsStyle(eqtl_GR) <- "NCBI"

#get a hits object which provide index of each gene nearest to each eQTL
#and the absolute distance between them
dist<-distanceToNearest(eqtl_GR, tss_GR)
dist <- data.frame(dist)
eqtl2 <- merge(x=eqtl2,y=dist,by.x="col_ref",by.y="queryHits", all=TRUE)
colnames(eqtl2)[length(eqtl2)] <- c("all_genes")

gene_names <- unique(tss2$Gene_type)
for(i in (1:length(gene_names))) {
  tss2_filtered<- tss2[tss2$Gene_type==gene_names[i],]
  tss_GR_filtered<-makeGRangesFromDataFrame(as.data.frame(tss2_filtered), keep.extra.columns=TRUE)
  dist<-distanceToNearest(eqtl_GR, tss_GR_filtered)
  dist <- data.frame(dist)
  
  print(gene_names[i])
  if(dim(dist)[1]!=0) {
    eqtl2 <- merge(x=eqtl2,y=dist,by.x="col_ref",by.y="queryHits", all=TRUE)
    colnames(eqtl2)[length(eqtl2)] <- c(gene_names[i]) 
  }

}

eqtl2 <- eqtl2[,!grepl("subject", colnames(eqtl2))]
write.csv(eqtl2, file = "eqtl2.csv")
