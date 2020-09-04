#!/bin/bash
github_dir=~/scripts/Optimising_Exercise_Structural_MRI/OPTIMEX_github/

for subjName in `cat ${github_dir}/subjnames_all.csv` ; do
        qsub -v SUBJNAME=$subjName ${github_dir}/4_ACT/antsCT_pbs_script.pbs
done