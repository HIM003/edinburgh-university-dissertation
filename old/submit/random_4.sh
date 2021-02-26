#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -N ensemble              
#$ -cwd                  
#$ -l h_rt=48:00:00 
#$ -l h_vmem=16G
#$ -pe mpi 96
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
Rscript ./Ensembl_Distance2Gene_full_combine_data.R



#cd /exports/eddie/scratch/s1772751/
#tar -xvzf Prepared_data_1.tar.gz


#cd /exports/eddie/scratch/s1772751/Prepared_data_1
#find . -type f -name "*.csv" -execdir zip '{}.zip' '{}' \;
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
