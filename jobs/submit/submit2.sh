#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -N ensemble              
#$ -o /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts/jobs/
#$ -e /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts/jobs/
#$ -l h_rt=01:00:00 
#$ -l h_vmem=32G
#$ -pe sharedmem 1
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
 
# Run the program
#./hello.py

#cd /exports/eddie/scratch/s1772751/Prepared_Data/sep_files_/
#gzip full_dataset.csv
#cd /exports/eddie/scratch/s1772751/Prepared_Data
#cut -d "," -f1545,1,1528 test_full_dataset_v2.csv > sep_files/chr.csv


#awk 'BEGIN{FS=","} { if(($1528 == "chr1") && ($1529 == 14677)) { print } }' test_full_dataset_v2.csv > hello1.csv
#cut -d "," -f1528,1529,1545,1546,1547,1548 test_full_dataset_v2.csv > outfile_new.csv
#gunzip test_full_dataset_v2.csv.gz
#cut -d "," -f1528,1529 full_dataset.csv > full_chr_pos
#cut -d, -f1528,1529 --complement full_dataset.csv > full_chr_pos
#gunzip -c /exports/eddie/scratch/s1772751/Prepared_Data/dt_all.gz > dt_all.csv
#'BEGIN{FS=","} { for(fn=1;fn<=NF;fn++) {print fn" = "$fn;}; exit; }' dt_all.csv >> names.txt

#cd /exports/eddie/scratch/s1772751/Prepared_Data/break_file
#ls * | parallel gzip
#cut -d, -f150,346,493,641,789,937,1087,1238,1388 --complement dt_all.csv > dt_all_new.csv
#Rscript ./graphing_features.R "outfile_new_887.csv"
#Rscript ./Ensembl_Distance2Gene_full_combine_data_array_v5.R
#Rscript ./cpg_Distance2Gene_Full_Dataset.R

cd /exports/eddie/scratch/s1772751/Prepared_Data/sep_files_/files
F=outfile_new_1527.csv
awk -v my_var=$F -F, '{getline f1 <my_var ;print f1,$1}' OFS=, chr_only_.csv >> chr_$F



#awk '{a[FNR]=a[FNR]?a[FNR]", "$0:$0}END{for(i=1;i<=FNR;i++)print a[i]}' outfile_new_1527.csv chr_only_.csv >>test2.csv
#awk '{s=$0;getline < "outfile_new_1527.csv";print s,$0}' chr_only_.csv >> test.csv


#awk 'FNR==NR{a[FNR]=$2;next};{$NF=a[FNR]};1' outfile_new_1527.csv chr_only_.csv >> test.csv

cd /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts
Rscript ./graph_features_norm.R /exports/eddie/scratch/s1772751/Prepared_Data/sep_files_/files/chr_$F

cd /exports/eddie/scratch/s1772751/Prepared_Data/sep_files_/files
rm chr_$F
#Rscript ./Ensembl_Distance2Gene_full_combine_data_array_80.R
#Rscript ./Ensembl_Distance2Gene_full_combine_data_array_100.R
#Rscript ./Ensembl_Distance2Gene_full_combine_data_array_120.R
#Rscript ./Ensembl_Distance2Gene_full_combine_data_array_140.R
#Rscript ./Ensembl_Distance2Gene_full_combine_data_array_160.R

#cd /exports/eddie/scratch/s1772751/Prepared_Data/sep_files_/
#tar -xvzf Prepared_data_1.tar.gz


#cd /exports/eddie/scratch/s1772751/Prepared_data_1
#@find . -type f -name "outfile*.csv" -execdir zip '{}.zip' '{}' \;
#rm *.csv

#cd /exports/eddie/scratch/s1772751/Prepared_data_4
#find . -type f -name "*.csv" -execdir zip '{}.zip' '{}' \;
#rm *.csv

#cd /exports/eddie/scratch/s1772751/Prepared_data_5
#find . -type f -name "*.csv" -execdir zip '{}.zip' '{}' \;
#rm *.csv

#cd /exports/eddie/scratch/s1772751/Prepared_data_6
#find . -type f -name "*.csv" -execdir zip '{}.zip' '{}' \;
#rm *.csv

#cd /exports/eddie/scratch/s1772751/Prepared_data_7
#find . -type f -name "*.csv" -execdir zip '{}.zip' '{}' \;
#rm *.csv

#cd /exports/eddie/scratch/s1772751/Prepared_data_8
#find . -type f -name "*.csv" -execdir zip '{}.zip' '{}' \;
#rm *.csv

#cd /exports/eddie/scratch/s1772751/Prepared_data_9
#find . -type f -name "*.csv" -execdir zip '{}.zip' '{}' \;
#rm *.csv

#cd /exports/eddie/scratch/s1772751/Prepared_data_10
#find . -type f -name "*.csv" -execdir zip '{}.zip' '{}' \;
#rm *.csv




#tar -czf Prepared_data_2.tar.gz --remove-files Prepared_data_2
#tar -czf Prepared_data_3.tar.gz --remove-files Prepared_data_3
#tar -czf Prepared_data_4.tar.gz --remove-files Prepared_data_4
#tar -czf Prepared_data_5.tar.gz --remove-files Prepared_data_5
#tar -czf Prepared_data_6.tar.gz --remove-files Prepared_data_6
#tar -czf Prepared_data_7.tar.gz --remove-files Prepared_data_7
#tar -czf Prepared_data_8.tar.gz --remove-files Prepared_data_8
#tar -czf Prepared_data_9.tar.gz --remove-files Prepared_data_9
#tar -czf Prepared_data_10.tar.gz --remove-files Prepared_data_10
