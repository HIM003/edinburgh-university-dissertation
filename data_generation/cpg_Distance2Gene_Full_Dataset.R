#####################################################################################################
#
# This code is used to get the distances between the eqtl data and the CPG Islands 
#
#
#####################################################################################################

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


setwd("/exports/csce/eddie/inf/groups/mamode_prendergast/Scripts")

#we will get the nearest gene to each eQTL in CaVEMaN results 
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


#CPG Island located from the following location
#https://genome.ucsc.edu/cgi-bin/hgTables?hgsid=780219149_uKWdFdK5MNzXk4aJT8IFu8ETNV8H&clade=mammal&org=
#Human&db=hg38&hgta_group=regulation&hgta_track=knownGene&hgta_table=0&hgta_regionType=genome&position=c
#hr1%3A11%2C102%2C837-11%2C267%2C747&hgta_outputType=primaryTable&hgta_outFileName=

cpg_islands<-read_tsv("../Data/cpg_islands.txt", col_names = TRUE)
cpg_islands<-select(cpg_islands, seqnames=chrom, start=chromStart, end=chromEnd)
#colnames(cpg_islands) <- c('seqnames','start','end','Gene_type','number','strand')
#make granges object of chromatin locations
cpg_islands_GR<-makeGRangesFromDataFrame(as.data.frame(cpg_islands), keep.extra.columns=TRUE)
try(seqlevelsStyle(cpg_islands_GR) <- "NCBI",TRUE)
    
#get a hits object which provide index of each gene nearest to each eQTL
#and the absolute distance between them
dist<-distanceToNearest(eqtl_GR, cpg_islands_GR)
dist <- data.frame(dist)
    
#add all the chromatin distance data to single dataframe
eqtl_chromatin <- merge(x=eqtl_chromatin,y=dist,by.x="col_ref",by.y="queryHits", all=TRUE)
#delete unnecessary columns
eqtl_chromatin <- eqtl_chromatin[ , !names(eqtl_chromatin) %in% c("subjectHits")]
colnames(eqtl_chromatin)[length(colnames(eqtl_chromatin))] <- "cpg_island"
write.csv(eqtl_chromatin, file = "eqtl_cpg_islands.csv")
