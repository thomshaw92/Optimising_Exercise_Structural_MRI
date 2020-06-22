#!/bin/bash
github_dir=~/scripts/Optimising_Exercise_Structural_MRI/OPTIMEX_github/

for subjName in `cat ${github_dir}/subjnames_01_only.csv` ; do
       qsub -v SUBJNAME=$subjName ${github_dir}/9_LASHiS/OPTIMEX_ASHS_pbs_script_1_ses.pbs
 done
for subjName in `cat ${github_dir}/subjnames_06_only.csv` ; do
        qsub -v SUBJNAME=$subjName ${github_dir}/9_LASHiS/OPTIMEX_LASHiS_pbs_script_2_ses.pbs
done
for subjName in `cat ${github_dir}/subjnames_12_only.csv` ; do
      qsub -v SUBJNAME=$subjName ${github_dir}/9_LASHiS/OPTIMEX_LASHiS_pbs_script_3_ses.pbs
done
for subjName in `cat ${github_dir}/subjnames_24_only.csv` ; do 
	qsub -v SUBJNAME=$subjName ${github_dir}/9_LASHiS/OPTIMX_LASHiS_pbs_script_5_ses.pbs
done