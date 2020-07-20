#!/bin/bash
github_dir=~/scripts/Optimising_Exercise_Structural_MRI/OPTIMEX_github/
for subjName in `cat ${github_dir}/subjnames_all.csv` ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/Optimising_Exercise_Structural_MRI/OPTIMEX_github/8_freesurfer/freesurfer_pbs_script_ses-01.pbs
done