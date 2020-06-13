#!/bin/bash
github_dir=~/scripts/Optimising_Exercise_Structural_MRI/OPTIMEX_github
proc_lashis_dir="/30days/uqtshaw/optimex/derivatives/LASHiS"
results_dir="/30days/uqtshaw/optimex/results"
mkdir ${results_dir}
rm ${results_dir}/hippocampus_volumes.csv
#ses-01 only
for subjName in `cat ${github_dir}/subjnames_01_only.csv` ; do
    mkdir ${results_dir}/${subjName}
    if [[ -e ${proc_lashis_dir}/${subjName}/${subjName}/final/${subjName}_left_corr_nogray_volumes.txt && -e ${proc_lashis_dir}/${subjName}/${subjName}/final/${subjName}_right_corr_nogray_volumes.txt ]] ; then
        cp ${proc_lashis_dir}/${subjName}/${subjName}/final/${subjName}*_corr_nogray_volumes.txt ${results_dir}/${subjName}/
        cat ${results_dir}/${subjName}/${subjName}*left*.txt>>${results_dir}/hippocampus_volumes.csv
        cat ${results_dir}/${subjName}/${subjName}*right*.txt>>${results_dir}/hippocampus_volumes.csv
        cd ${proc_lashis_dir}
        echo "tar -cvzf ${subjName}.tar.gz ./${subjname} "
    fi
done
#ses-02 only
for subjName in `cat ${github_dir}/subjnames_06_only.csv` ; do
    mkdir ${results_dir}/${subjName}
    if [[ -e ${proc_lashis_dir}/${subjName}/LASHiS/${subjName}_ses-01_T1w_N4corrected_norm_preprocleftSSTLabelsWarpedToTimePoint0_stats.txt ]] ; then
        cp ${proc_lashis_dir}/${subjName}/LASHiS/*txt ${results_dir}/${subjName}/
        paste -d' ' ${results_dir}/${subjName}/${subjName}*ses-01*left*.txt ${results_dir}/${subjName}/${subjName}*ses-02*left*.txt > ${results_dir}/${subjName}/${subjName}_left_2-sessions.txt
        paste -d' ' ${results_dir}/${subjName}/${subjName}*ses-01*right*.txt ${results_dir}/${subjName}/${subjName}*ses-02*right*.txt > ${results_dir}/${subjName}/${subjName}_right_2-sessions.txt
        cat ${results_dir}/${subjName}/${subjName}_left_2-sessions.txt>>${results_dir}/hippocampus_volumes.csv
        cat ${results_dir}/${subjName}/${subjName}_right_2-sessions.txt>>${results_dir}/hippocampus_volumes.csv
        cd ${proc_lashis_dir}
        echo "tar -cvzf ${subjName}.tar.gz ./${subjname} "
    fi
done
#ses-03 only
for subjName in `cat ${github_dir}/subjnames_12_only.csv` ; do
    mkdir ${results_dir}/${subjName}
    if [[ -e ${proc_lashis_dir}/${subjName}/LASHiS/${subjName}_ses-01_T1w_N4corrected_norm_preprocleftSSTLabelsWarpedToTimePoint0_stats.txt ]] ; then
        
        cp ${proc_lashis_dir}/${subjName}/LASHiS/*txt ${results_dir}/${subjName}/
        
        paste -d' ' ${results_dir}/${subjName}/${subjName}*ses-01*left*.txt \
        ${results_dir}/${subjName}/${subjName}*ses-02*left*.txt \
        ${results_dir}/${subjName}/${subjName}*ses-03*left*.txt \
        > ${results_dir}/${subjName}/${subjName}_left_3-sessions.txt
        
        paste -d' ' ${results_dir}/${subjName}/${subjName}*ses-01*right*.txt \
        ${results_dir}/${subjName}/${subjName}*ses-02*right*.txt \
        ${results_dir}/${subjName}/${subjName}*ses-03*right*.txt \
        > ${results_dir}/${subjName}/${subjName}_right_3-sessions.txt
        
        
        cat ${results_dir}/${subjName}/${subjName}_left_3-sessions.txt>>${results_dir}/hippocampus_volumes.csv
        cat ${results_dir}/${subjName}/${subjName}_right_3-sessions.txt>>${results_dir}/hippocampus_volumes.csv
        cd ${proc_lashis_dir}
        echo "tar -cvzf ${subjName}.tar.gz ./${subjname} "
    fi
done
#ses-05 only
for subjName in `cat ${github_dir}/subjnames_24_only.csv` ; do
    mkdir ${results_dir}/${subjName}
    if [[ -e ${proc_lashis_dir}/${subjName}/LASHiS/${subjName}_ses-01_T1w_N4corrected_norm_preprocleftSSTLabelsWarpedToTimePoint0_stats.txt ]] ; then
        
        cp ${proc_lashis_dir}/${subjName}/LASHiS/*txt ${results_dir}/${subjName}/
        
        paste -d' ' ${results_dir}/${subjName}/${subjName}*ses-01*left*.txt \
        ${results_dir}/${subjName}/${subjName}*ses-02*left*.txt \
        ${results_dir}/${subjName}/${subjName}*ses-03*left*.txt \
        ${results_dir}/${subjName}/${subjName}*ses-04*left*.txt \
        ${results_dir}/${subjName}/${subjName}*ses-05*left*.txt \
        > ${results_dir}/${subjName}/${subjName}_left_3-sessions.txt
        
        paste -d' ' ${results_dir}/${subjName}/${subjName}*ses-01*right*.txt \
        ${results_dir}/${subjName}/${subjName}*ses-02*right*.txt \
        ${results_dir}/${subjName}/${subjName}*ses-03*right*.txt \
        ${results_dir}/${subjName}/${subjName}*ses-04*right*.txt \
        ${results_dir}/${subjName}/${subjName}*ses-05*right*.txt \
        > ${results_dir}/${subjName}/${subjName}_right_3-sessions.txt
        
        
        cat ${results_dir}/${subjName}/${subjName}_left_3-sessions.txt>>${results_dir}/hippocampus_volumes.csv
        cat ${results_dir}/${subjName}/${subjName}_right_3-sessions.txt>>${results_dir}/hippocampus_volumes.csv
        cd ${proc_lashis_dir}
        echo "tar -cvzf ${subjName}.tar.gz ./${subjname} "
    fi
done
date
