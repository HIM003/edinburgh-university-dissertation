#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -N ada             
#$ -o /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts/0_25/jobs/
#$ -e /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts/0_25/jobs/                 
#$ -l h_rt=96:00:00 
#$ -l h_vmem=64G
#$ -pe sharedmem 2
#$ -R y
#$ -P roslin_prendergast_cores

#  These options are:
#  job name: -N
#  use the current working directory: -cwd
#  runtime limit of 5 minutes: -l h_rt
#  memory limit of 1 Gbyte: -l h_vmem

# Initialise the environment modules
. /etc/profile.d/modules.sh
 
# Load Python
module load igmm/apps/R/3.6.1
 
cd /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts/0_25/
#gunzip dataset_downsampled_cleaned.csv.gz
#gzip dataset_downsampled.csv

#cut -d "," -f1,1528,1529,1545 combined_reduced_dataset.csv > com_reduced.csv
#cut -d "," -f1,1528,1529,1545 dataset_downsampled.csv  > dat_reduced.csv


#awk 'BEGIN{FS=","} { if(($1528 == "chr1") && ($1529 == 14677)) { print } }' test_full_dataset_v2.csv > hello1.csv
#gunzip -c /exports/eddie/scratch/s1772751/Prepared_Data/dt_all.gz > dt_all.csv
#'BEGIN{FS=","} { for(fn=1;fn<=NF;fn++) {print fn" = "$fn;}; exit; }' dt_all.csv >> names.txt

#ls * | parallel gzip

#Rscript ./graphing_features.R "outfile_new_887.csv"
Rscript ./caret_ada.R
