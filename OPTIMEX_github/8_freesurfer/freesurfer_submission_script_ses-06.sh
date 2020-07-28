#!/bin/bash
github_dir=~/scripts/Optimising_Exercise_Structural_MRI/OPTIMEX_github/
for subjName in `cat ${github_dir}/subjnames_06_only.csv` ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/Optimising_Exercise_Structural_MRI/OPTIMEX_github/8_freesurfer/freesurfer_pbs_script_ses-06.pbs
done