#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -N ensemble              
#$ -cwd                  
#$ -l h_rt=12:00:00 
#$ -l h_vmem=8G
#$ -pe sharedmem 16
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
Rscript ./Ensembl_Distance2Gene_full_local.R
