#####################################################################################################
#															
# This script is to get the distance between the Full GTEx dataset and the nearest gene
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
# This section is to get the the distance
#
######################################################################################################

setwd("/exports/csce/eddie/inf/groups/mamode_prendergast/Scripts")

#we will get the nearest gene to each eQTL in Full Dataset 
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


#file containg the locations of the start of genes (gene start is termed TSS)
#obtained from https://www.ensembl.org/biomart/martview
tss<-read_tsv("../Data/tss_ensembl_98.txt")

#rename columns as makeGRangesFromDataFrame needs to know the chromosome, position and strand columns
tss2<-select(tss, seqnames=Chromosome, start=TSS, strand=Strand, Gene_type, Gene_stable_ID) %>% mutate(end=start) 
#recode strand
tss2$strand<-recode(tss2$strand, "1"="+", "-1"="-")
#make granges object of TSS locations
tss_GR<-makeGRangesFromDataFrame(as.data.frame(tss2), keep.extra.columns=TRUE)

#get a hits object which provide index of each gene nearest to each eQTL
#and the absolute distance between them
dist<-distanceToNearest(eqtl_GR, tss_GR)
dist <- data.frame(dist)
eqtl2 <- merge(x=eqtl,y=dist,by.x="col_ref",by.y="queryHits", all=TRUE)
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
print("About to Print Data")
write.csv(eqtl2, file = "eqtl_tss.csv")


######################################################################################################
#
# This section is to remove those columns with NaNs
#
######################################################################################################

setwd("/exports/csce/eddie/inf/groups/mamode_prendergast/Scripts")

eqtl_tss<-read_csv("eqtl_tss.csv")
c <- colnames(eqtl_tss)
column_list<-vector()

for(i in (1:length(c))) {
  a = c[i]
  eqtl_filtered<- eqtl_tss[[a]]

  if(sum(is.na(eqtl_tss[[a]]))>0){
    print(a)
    print(sum(is.na(eqtl_tss[[a]])))
    column_list <- c(column_list, a)
  }    
}

eqtl_tss <- eqtl_tss[ , !(names(eqtl_tss) %in% column_list)]
write.csv(eqtl_tss, file = "eqtl_tss_filtered.csv")
