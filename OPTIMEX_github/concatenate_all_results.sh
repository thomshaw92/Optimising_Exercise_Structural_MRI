#!/bin/bash
github_dir=~/scripts/Optimising_Exercise_Structural_MRI/OPTIMEX_github
proc_lashis_dir="/30days/uqtshaw/optimex/derivatives/LASHiS"
results_dir="/30days/uqtshaw/optimex/results"
mkdir ${results_dir}
#ses-01 only
for subjName in `cat ${github_dir}/subjnames_01_only.csv` ; do
    mkdir ${results_dir}/${subjName}
    if [[ -e ${proc_lashis_dir}/${subjName}/${subjName}/final/${subjName}_left_corr_nogray_volumes.txt && -e ${proc_lashis_dir}/${subjName}/${subjName}/final/${subjName}_right_corr_nogray_volumes.txt ]] ; then
        cp ${proc_lashis_dir}/${subjName}/${subjName}/final/${subjName}*_corr_nogray_volumes.txt ${results_dir}/${subjName}/
        cat ${results_dir}/${subjName}/${subjName}*left*.txt>>${proc_lashis_dir}/hippocampus_volumes.csv
        cat ${results_dir}/${subjName}/${subjName}*right*.txt>>${proc_lashis_dir}/hippocampus_volumes.csv
        cd ${proc_lashis_dir}
        tar -cvzf ${subjName}.tar.gz ${subjname} &
    fi
done
#ses-02 only
for x in `cat ${github_dir}/subjnames_06_only.csv` ; do
    mkdir ${results_dir}/${subjName}
    if [[ -e ${proc_lashis_dir}/${subjName}/LASHiS/${subjName}_ses-01_T1w_N4corrected_norm_preprocleftSSTLabelsWarpedToTimePoint0.txt ]] ; then
        cp ${proc_lashis_dir}/${subjName}/LASHiS/*txt ${results_dir}/${subjName}/
        paste -d' ' ${results_dir}/${subjName}/${subjName}*ses-01*left*.txt ${results_dir}/${subjName}/${subjName}*ses-02*left*.txt > ${results_dir}/${subjName}/${subjName}_left_2-sessions.txt
        paste -d' ' ${results_dir}/${subjName}/${subjName}*ses-01*right*.txt ${results_dir}/${subjName}/${subjName}*ses-02*right*.txt > ${results_dir}/${subjName}/${subjName}_right_2-sessions.txt
        cat ${results_dir}/${subjName}/${subjName}_left_2-sessions.txt>>${proc_lashis_dir}/hippocampus_volumes.csv
        cat ${results_dir}/${subjName}/${subjName}_right_2-sessions.txt>>${proc_lashis_dir}/hippocampus_volumes.csv
        cd ${proc_lashis_dir}
        tar -cvzf ${subjName}.tar.gz ${subjname} &
    fi
done
#ses-03 only
for x in `cat ${github_dir}/subjnames_12_only.csv` ; do
done
date
