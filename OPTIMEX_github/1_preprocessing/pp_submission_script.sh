#!/bin/bash
github_dir=~/scripts/Optimising_Exercise_Structural_MRI/OPTIMEX_github/
for subjName in `cat ${github_dir}/subjnames_all.csv` ; do 
	qsub -v SUBJNAME=$subjName ${github_dir}/1_preprocessing/pp_pbs_script.pbs
done
