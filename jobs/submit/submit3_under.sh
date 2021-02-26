#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -N imp          
#$ -o /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts/jobs/
#$ -e /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts/jobs/                 
#$ -l h_rt=08:00:00 
#$ -l h_vmem=64G
#$ -pe sharedmem 1
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
 
cd /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts/analysis/
#gunzip dataset_downsampled_cleaned.csv.gz
#gzip dataset_downsampled.csv

#cut -d "," -f1,1528,1529,1545 combined_reduced_dataset.csv > com_reduced.csv
#cut -d "," -f1,1528,1529,1545 dataset_downsampled.csv  > dat_reduced.csv


#awk 'BEGIN{FS=","} { if(($1528 == "chr1") && ($1529 == 14677)) { print } }' test_full_dataset_v2.csv > hello1.csv
#gunzip -c /exports/eddie/scratch/s1772751/Prepared_Data/dt_all.gz > dt_all.csv
#'BEGIN{FS=","} { for(fn=1;fn<=NF;fn++) {print fn" = "$fn;}; exit; }' dt_all.csv >> names.txt

#ls * | parallel gzip

#Rscript ./graphing_features.R "outfile_new_887.csv"
#Rscript ./results_varImp.R "0_05" "glm_tunelength_down_0_05.RDS" "glm_0.05"
#Rscript ./results_varImp.R "0_10" "glm_tunelength_down_0_10.RDS" "glm_0.10"
#Rscript ./results_varImp.R "0_25" "glm_tunelength_down_0_25.RDS" "glm_0.25"
#Rscript ./results_varImp.R "1_00" "glm_tunelength_down_1_00.RDS" "glm_1.00"
#Rscript ./results_varImp.R "0_05" "adabag_tunelength_down_0_05.RDS" "adabag_0.05"
#Rscript ./results_varImp.R "0_05" "xgbTree_tunelength_down_0_05.RDS" "xgbTree_0.05"
#Rscript ./results_varImp.R "0_05" "bagFDAGCV_tunelength_down_0_05.RDS" "bagFDAGCV_0.05"
#Rscript ./results_varImp.R "0_10" "bagFDAGCV_tunelength_down_0_10.RDS" "bagFDAGCV_0.10"
#Rscript ./results_varImp.R "0_25" "bagFDAGCV_tunelength_down_0_25.RDS" "bagFDAGCV_0.25"
#Rscript ./results_varImp.R "0_05" "gbmfit_tunelength_down_0_05.RDS" "gbm_0.05"
#Rscript ./results_varImp.R "0_10" "gbmfit_tunelength_down_0_10.RDS" "gbm_0.10"
#Rscript ./results_varImp.R "0_25" "gbmfit_tunelength_down_0_25.RDS" "gbm_0.25"
#Rscript ./results_varImp.R "1_00" "gbmfit_tunelength_down_1_00.RDS" "gbm_1.00"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.1_down_sampled.RDS" "gbm_caveman_down_0.10"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.1_none_sampled.RDS" "gbm_caveman_none_0.10"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.1_rose_sampled.RDS" "gbm_caveman_rose_0.10"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.1_smote_sampled.RDS" "gbm_caveman_smote_0.10"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.1_up_sampled.RDS" "gbm_caveman_up_0.10"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.5_down_sampled.RDS" "gbm_caveman_down_0.5"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.5_none_sampled.RDS" "gbm_caveman_none_0.5"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.5_rose_sampled.RDS" "gbm_caveman_rose_0.5"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.5_smote_sampled.RDS" "gbm_caveman_smote_0.5"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.5_up_sampled.RDS" "gbm_caveman_up_0.5"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.9_down_sampled.RDS" "gbm_caveman_down_0.9"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.9_none_sampled.RDS" "gbm_caveman_none_0.9"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.9_rose_sampled.RDS" "gbm_caveman_rose_0.9"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.9_smote_sampled.RDS" "gbm_caveman_smote_0.9"
Rscript ./results_varImp.R "trials" "gbmfit_rebalanced_caveman_0.9_up_sampled.RDS" "gbm_caveman_up_0.9"
Rscript ./results_varImp.R "trials" "gbmfit_tunelength_caveman_original_dist_0.5_weighted.RDS" "gbm_weighted_0.5"
Rscript ./results_varImp.R "trials" "gbmfit_tunelength_caveman_original_dist_0.55_weighted.RDS" "gbm_weighted_0.55"
Rscript ./results_varImp.R "trials" "gbmfit_tunelength_caveman_original_dist_0.6_weighted.RDS" "gbm_weighted_0.6"
Rscript ./results_varImp.R "trials" "gbmfit_tunelength_caveman_original_dist_0.7_weighted.RDS" "gbm_weighted_0.7"
Rscript ./results_varImp.R "trials" "gbmfit_tunelength_caveman_original_dist_0.8_weighted.RDS" "gbm_weighted_0.8"
Rscript ./results_varImp.R "trials" "gbmfit_tunelength_caveman_original_dist_0.9_weighted.RDS" "gbm_weighted_0.9"
Rscript ./results_varImp.R "trials" "gbmfit_tunelength_caveman_original_dist_0.95_weighted.RDS" "gbm_weighted_0.95"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_ALL_0_1.RDS" "gbm_diff_all_0.1"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_ALL_0_5.RDS" "gbm_diff_all_0.5"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_ALL_0_9.RDS" "gbm_diff_all_0.9"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_CaVEMaN_0_1.RDS" "gbm_diff_caveman_0.1"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_CaVEMaN_0_5.RDS" "gbm_diff_caveman_0.5"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_CaVEMaN_0_9.RDS" "gbm_diff_caveman_0.9"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_CAVIAR_0_1.RDS" "gbm_diff_caviar_0.1"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_CAVIAR_0_5.RDS" "gbm_diff_caviar_0.5"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_CAVIAR_0_9.RDS" "gbm_diff_caviar_0.9"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_DAPG_0_1.RDS" "gbm_diff_dapg_0.1"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_DAPG_0_5.RDS" "gbm_diff_dapg_0.5"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_DAPG_0_9.RDS" "gbm_diff_dapg_0.9"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_SuRE_0.01.RDS" "gbm_diff_sure_0.01"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_SuRE_1e-04.RDS" "gbm_diff_sure_1e-04"
Rscript ./results_varImp.R "diff_datasets" "gbmfit_tunelength_down_SuRE_1e-06.RDS" "gbm_diff_sure_1e-06"




