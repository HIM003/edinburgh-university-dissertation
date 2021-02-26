#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -N ensemble
#$ -cwd
#$ -l h_rt=01:00:00
#$ -l h_vmem=32G
#$ -pe sharedmem 1
#$ -P roslin_prendergast_cores

#job.sh $1.$SGE_TASK_ID

. /etc/profile.d/modules.sh
module load igmm/apps/R/3.6.1

cd /exports/eddie/scratch/s1772751/Prepared_Data/sep_files_

F=`sed -n ${SGE_TASK_ID}p < filetoprocess_new.txt`
awk -v my_var=$F -F, '{getline f1 <my_var ;print f1,$1}' OFS=, chr_only_.csv >> chr_$F
#awk -F, '{getline f1 <"outfile_new_999.csv" ;print f1,$1}' OFS=, chr_only.csv >> tester.csv

cd /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts
Rscript ./graph_features.R chr_$F

echo chr_$F


#F=`sed -n ${SGE_TASK_ID}p < filetoprocess.txt`
#cd /exports/csce/eddie/inf/groups/mamode_prendergast/Scripts
#Rscript ./graphing_features.R $F
#cut -d "," -f1545,$SGE_TASK_ID test_full_dataset_v2.csv > sep_files/outfile_new_$SGE_TASK_ID.csv

cd /exports/eddie/scratch/s1772751/Prepared_Data/sep_files_
rm chr_$F
