#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -N ROC_results
#$ -o /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts/jobs/
#$ -e /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts/jobs/                 
#$ -l h_rt=02:00:00 
#$ -l h_vmem=64G
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
 
cd /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts/analysis/
#gzip dataset_downsampled_cleaned.csv

#cut -d "," -f1,1528,1529,1545 combined_reduced_dataset.csv > com_reduced.csv
#cut -d "," -f1,1528,1529,1545 dataset_downsampled.csv  > dat_reduced.csv


#awk 'BEGIN{FS=","} { if(($1528 == "chr1") && ($1529 == 14677)) { print } }' test_full_dataset_v2.csv > hello1.csv
#gunzip -c /exports/eddie/scratch/s1772751/Prepared_Data/dt_all.gz > dt_all.csv
#'BEGIN{FS=","} { for(fn=1;fn<=NF;fn++) {print fn" = "$fn;}; exit; }' dt_all.csv >> names.txt

#ls * | parallel gzip

#Rscript ./results_check_two_results_test.R
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.9_rebalanced_outfile_new.csv.gz trials/gbmfit_rebalanced_caveman_0.9_down_sampled.RDS down_0.9
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.9_rebalanced_outfile_new.csv.gz trials/gbmfit_rebalanced_caveman_0.9_up_sampled.RDS up_0.9
##Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.1_rebalanced_outfile_new.csv.gz trials/gbmfit_rebalanced_caveman_0.1_none_sampled.RDS none_0.1
##Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.9_rebalanced_outfile_new.csv.gz trials/gbmfit_rebalanced_caveman_0.9_none_sampled.RDS none_0.9
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.9_rebalanced_outfile_new.csv.gz trials/gbmfit_rebalanced_caveman_0.9_rose_sampled.RDS rose_0.9
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.9_rebalanced_outfile_new.csv.gz trials/gbmfit_rebalanced_caveman_0.9_smote_sampled.RDS smote_0.9

#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_1.csv.gz trials/regLogistic_tunegrid_down_0_10_no_data_transform.RDS regLogistic_no_data_transform
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_1.csv.gz trials/regLogistic_tunegrid_down_0_10_no_hcf.RDS regLogistic_no_hcf
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_1.csv.gz trials/regLogistic_tunegrid_down_0_10_no_nzv.RDS regLogistic_no_nzv
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_1.csv.gz trials/regLogistic_tunegrid_down_0_10_no_scale_no_center.RDS regLogistic_no_scale_and_centre
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_1.csv.gz 0_10/regLogistic_tunelength_down_0_10.RDS regLogistic_base_case


#Rscript ./results_extract.R
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_1.csv.gz trials/gbmfit_tunelength_down_0_10_no_data_transform.RDS gbm_no_data_transform
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_1.csv.gz trials/gbmfit_tunelength_down_0_10_no_hcf.RDS gbm_no_hcf
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_1.csv.gz trials/gbmfit_tunelength_down_0_10_no_nzv.RDS gbm_no_nzv
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_1.csv.gz trials/gbmfit_tunelength_down_0_10_no_scale_no_center.RDS gbm_no_scale_and_centre
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_ALL_0.1_outfile.csv.gz  diff_datasets/gbmfit_tunelength_down_ALL_0_1.RDS all_0.1
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_ALL_0.5_outfile.csv.gz  diff_datasets/gbmfit_tunelength_down_ALL_0_5.RDS all_0.5
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_ALL_0.9_outfile.csv.gz  diff_datasets/gbmfit_tunelength_down_ALL_0_9.RDS all_0.9
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CaVEMaN_0.5_outfile.csv.gz  diff_datasets/gbmfit_tunelength_down_CaVEMaN_0_5.RDS caveman_0.5
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CaVEMaN_0.9_outfile.csv.gz  diff_datasets/gbmfit_tunelength_down_CaVEMaN_0_9.RDS caveman_0.9
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVIAR_0.1_outfile.csv.gz  diff_datasets/gbmfit_tunelength_down_CAVIAR_0_1.RDS caviar_0.1
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVIAR_0.5_outfile.csv.gz  diff_datasets/gbmfit_tunelength_down_CAVIAR_0_5.RDS caviar_0.5
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVIAR_0.9_outfile.csv.gz  diff_datasets/gbmfit_tunelength_down_CAVIAR_0_9.RDS caviar_0.9
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_DAPG_0.1_outfile.csv.gz  diff_datasets/gbmfit_tunelength_down_DAPG_0_1.RDS dapg_0.1
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.1_rebalanced_outfile_new.csv.gz trials/gbmfit_tunelength_caveman_original_dist_0.5_weighted.RDS weighted_0.5
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.1_rebalanced_outfile_new.csv.gz trials/gbmfit_tunelength_caveman_original_dist_0.55_weighted.RDS weighted_0.55
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.1_rebalanced_outfile_new.csv.gz trials/gbmfit_tunelength_caveman_original_dist_0.6_weighted.RDS weighted_0.6
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.1_rebalanced_outfile_new.csv.gz trials/gbmfit_tunelength_caveman_original_dist_0.7_weighted.RDS weighted_0.7
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.1_rebalanced_outfile_new.csv.gz trials/gbmfit_tunelength_caveman_original_dist_0.8_weighted.RDS weighted_0.8
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.1_rebalanced_outfile_new.csv.gz trials/gbmfit_tunelength_caveman_original_dist_0.9_weighted.RDS weighted_0.9
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CAVEMAN_0.1_rebalanced_outfile_new.csv.gz trials/gbmfit_tunelength_caveman_original_dist_0.95_weighted.RDS weighted_0.95
#Rscript ./results_extract_single_conf_mat.R dataset_downsampled_cleaned_caret_5sf_CaVEMaN_0.1_outfile.csv.gz diff_datasets/gbmfit_tunelength_down_CaVEMaN_0_1.RDS caveman_0.1
#Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/bagFDAGCV_tunelength_down_0_05.RDS 0.05_bagFDAGCV
Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/bag_tunelength_down_0_05.RDS 0.05_bag
Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/evtree_tunelength_down_0_05.RDS 0.05_evtree
Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/glm_tunelength_down_0_05.RDS 0.05_glm
Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/knn_tunelength_down_0_05.RDS 0.05_knn
Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/kknn_tunelength_down_0_05.RDS 0.05_kknn
Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/lda_tunelength_down_0_05.RDS 0.05_lda
Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/lda2_tunelength_down_0_05.RDS 0.05_lda2
Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/LogitBoost_tunelength_down_0_05.RDS 0.05_LogitBoost
Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/naivebayes_tunelength_down_0_05.RDS 0.05_naivebayes
Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/nodeHarvest_tunelength_down_0_05.RDS 0.05_nodeHarvest
Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/ranger_tunelength_down_0_05.RDS 0.05_ranger
Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/regLogistic_tunelength_down_0_05.RDS 0.05_regLogistic
Rscript ./results_extract_single_conf_mat_rebalanced.R dataset_downsampled_cleaned_caret_5sf_0_015neg_0_5pos_0_05.csv.gz 0_05/xgbTree_tunelength_down_0_05.RDS 0.05_xgbTree
