#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -N ensemble              
#$ -cwd                  
#$ -l h_rt=48:00:00 
#$ -l h_vmem=64G
#$ -pe sharedmem 16
#  These options are:
#  job name: -N
#  use the current working directory: -cwd
#  runtime limit of 5 minutes: -l h_rt
#  memory limit of 1 Gbyte: -l h_vmem

# Initialise the environment modules
. /etc/profile.d/modules.sh
 
# Load R
module load igmm/apps/R/3.6.1
 
# Run the program
Rscript ./Ensembl_Distance2Gene_full_v2.R
