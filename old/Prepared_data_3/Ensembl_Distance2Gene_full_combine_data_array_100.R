#####################################################################################################
#
# This code is used to combine all the data 
#
#
#####################################################################################################

##setwd("/exports/csce/eddie/inf/groups/mamode_prendergast/Scripts")

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
#library("tools", lib.loc = "/exports/csce/eddie/inf/groups/mamode_prendergast/R_packages/")
library(tools)

#we will get the nearest gene to each eQTL in CaVEMaN results 
##eqtl<-read_tsv("../Data/GTEx_Analysis_2017-06-05_v8_WholeGenomeSeq_838Indiv_Analysis_Freeze.lookup_table.txt")
##eqtl <- eqtl[-c(1,6,7,8)]

#add the index as a column & select certain columns
##eqtl$col_ref <- rownames(eqtl)
##eqtl_chromatin<-(as.data.frame(select(eqtl, seqnames=chr, start=variant_pos, col_ref) %>% mutate(end=start)))
##eqtl_chromatin$col_ref <- as.numeric(eqtl$col_ref)

setwd("/exports/eddie/scratch/s1772751/Prepared_data_3")
#setwd("D:/Dissertation_Data/Eddie/Prepared_data_2")

#find the paths of all the files in the folder
files <- list.files(pattern = ".zip$", recursive = TRUE, full.names = TRUE)

#length(files)
#for each file
for(i in (81:100)) {
    #read in to chromatin variable
    chromatin<-read_csv(files[i], col_names = TRUE)
    
    #name columns
    folders <- strsplit(files[i],"/")
    name <- substr(folders[[1]][2], 1, nchar(folders[[1]][2]) -8)
    names(chromatin)[names(chromatin) == 'distance'] <- name
 	
    print(folders)
    
    #delete unneccessary column
    chromatin <- chromatin[ , !names(chromatin) %in% c("queryHits")]
    
    print(files[i])
    print(i)

    file_name_gz <- paste(name,'.csv.gz', sep="")
    file_name_zip <- paste(name,'.csv.zip', sep="")
	  
    #file_path <- file_path_as_absolute(file_name_zip)
    #file_path <- strsplit(file_path,"/")
    file_to_save <- paste(folders[[1]][1], file_name_gz, sep="/")
    file_to_remove <- paste(folders[[1]][1], file_name_zip, sep="/")

    print(file_to_save)
	  
    write.csv(chromatin, file = gzfile(file_to_save))
    #file.remove(file_to_remove)
    
    #rm(list=setdiff(ls(), "files"))
    rm(list=ls()[! ls() %in% c("files","i")])
    print(getwd())
    print(gc())  
}



###########################################################################################################

#setwd("D:/OneDrive/Documents/Edinburgh Uni/Dissertation")
#
#
#chromatin <- read.csv("eqtl_chromatin_new_2.csv", nrows = 10, header = TRUE) #, colClasses = column_list)
#chromatin_nan <- chromatin[colSums(!is.na(chromatin)) > 0]
#chromatin_col <- colnames(chromatin)
#chromatin_nan_col <- colnames(chromatin_nan)
#drop <- c(setdiff(chromatin_col, chromatin_nan_col))
#
#chromatin <- read.csv("eqtl_chromatin_new_2.csv", header = TRUE)
#chromatin <- chromatin[ , !(names(chromatin) %in% drop)]
#write.csv(chromatin, file = "D:/OneDrive/Documents/Edinburgh Uni/Dissertation/eqtl_chromatin_new_2_v.csv")
#
#
#chromatin2 <- read.csv("eqtl_chromatin2.csv", header = TRUE)
#chromatin2_nan <- chromatin2[colSums(!is.na(chromatin2)) > 0]
#chromatin2_col <- colnames(chromatin2)
#chromatin2_nan_col <- colnames(chromatin2_nan)
#drop <- c(setdiff(chromatin2_col, chromatin2_nan_col))
#chromatin2_new <- chromatin2[ , !(names(chromatin2) %in% drop)]
#write.csv(chromatin2_new, file = "D:/OneDrive/Documents/Edinburgh Uni/Dissertation/eqtl_chromatin2_new.csv")
#
#
#
################################################################################################################
#
#
#column_class <- sapply(chromatin, class)
#length(column_class)
#column_list<-vector()
#
#for (i in 1:length(column_class)){
#  #list.append(column_list,column_class[i][[1]]
#  if (column_class[i][[1]]=='integer') {
#    column_list <- c(column_list, 'int')
#  } else if (column_class[i][[1]]=='logical') {
#    print(i)
#    column_list <- c(column_list, 'logi')
#  } else {
#    column_list <- c(column_list, column_class[i][[1]])
#  }
#}
#
#column_list[1:1015] <- "integer"
#column_list[1:2] <- "factor"
#column_list[c(3,5)] <- "character"
#column_list[c(78,80,624,627,661)] <- "logical"
#column_list[600:1015] <- "NULL"
#column_list[c(7:600,1015)] <- "NULL"
#col_ <- column_list
#
#
#
#
#col_ = c(rep("NULL", 10), rep("integer", 5), rep("NULL", 1000))
#col_ = c("factor", rep("NULL", 1014))
#col_ = c(column_list[1:4], rep("NULL", 1011))
#chromatin <- read.csv("eqtl_chromatin.csv", nrows = 10, header = TRUE)
#chromatin_b <- read.csv("eqtl_chromatin2.csv", nrows = 10, header = TRUE)
#chromatin <- read.csv("eqtl_chromatin.csv", nrows = -1, header = TRUE, colClasses = col_)
#
#
#chromatin <- read.csv("eqtl_chromatin_new_3.csv", nrows = -1, header = TRUE)
#chromatin <- chromatin[ -c(1:2) ]
#write.csv(chromatin, file = "D:/OneDrive/Documents/Edinburgh Uni/Dissertation/eqtl_chromatin_new_3a.csv")
#
