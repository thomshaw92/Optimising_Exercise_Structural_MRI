#!/bin/bash
#Concatenate the LASHiS results to a results directory,
#add them to hippocampus_volumes.txt
#Then archive the directories, sending them to move_dir.
#also include ASHS results for 2/3/5 time points for comparison in ASHS_volumes.txt
#this assumes the LASHiS output from LASHiSV1.0

github_dir=~/scripts/Optimising_Exercise_Structural_MRI/OPTIMEX_github
proc_lashis_dir="/30days/uqtshaw/optimex/derivatives/LASHiS"
results_dir="/30days/uqtshaw/optimex/results"
move_dir="/30days/uqtshaw/optimex_lashis_tar"

mkdir ${results_dir}
rm ${results_dir}/hippocampus_volumes.csv
rm ${results_dir}/missing_data_LASHiS.txt
rm ${results_dir}/ASHS_hippocampus_volumes.csv
#ses-01 only
for subjName in `cat ${github_dir}/subjnames_01_only.csv` ; do
    mkdir ${results_dir}/${subjName}
    if [[ -e ${proc_lashis_dir}/${subjName}/${subjName}/final/${subjName}_left_corr_nogray_volumes.txt && -e ${proc_lashis_dir}/${subjName}/${subjName}/final/${subjName}_right_corr_nogray_volumes.txt ]] ; then
        cp ${proc_lashis_dir}/${subjName}/${subjName}/final/${subjName}*_corr_nogray_volumes.txt ${results_dir}/${subjName}/
        cd ${proc_lashis_dir}
        tar -cvzf ${move_dir}/${subjName}.tar.gz ./${subjName} && rm -rf ./${subjName}
    else
        echo "${subjName} missing 1 only" >> ${results_dir}/missing_data_LASHiS.txt
    fi
    cat ${results_dir}/${subjName}/${subjName}*left*.txt>>${results_dir}/hippocampus_volumes.csv
    cat ${results_dir}/${subjName}/${subjName}*right*.txt>>${results_dir}/hippocampus_volumes.csv
done
#ses-02 only
for subjName in `cat ${github_dir}/subjnames_06_only.csv` ; do
    mkdir ${results_dir}/${subjName}
    if [[ -e ${proc_lashis_dir}/${subjName}/LASHiS/${subjName}_ses-01_T1w_N4corrected_norm_preprocleftSSTLabelsWarpedToTimePoint0_stats.txt ]] ; then
        cp ${proc_lashis_dir}/${subjName}/LASHiS/*txt ${results_dir}/${subjName}/
        
        #ashs_results
        cp ${proc_lashis_dir}/${subjName}/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/*/final/${subjName}_ses-01_T1w_N4corrected_norm_preproc_*_corr_nogray_volumes.txt ${results_dir}/${subjName}/
        cp ${proc_lashis_dir}/${subjName}/${subjName}_ses-02_T1w_N4corrected_norm_preproc_1/*/final/${subjName}_ses-02_T1w_N4corrected_norm_preproc_*_corr_nogray_volumes.txt ${results_dir}/${subjName}/
        #move the directories
        cd ${proc_lashis_dir}
        tar -cvzf ${move_dir}/${subjName}.tar.gz ./${subjName} && rm -rf ./${subjName}
    else
        echo "${subjName} missing 02 only" >> ${results_dir}/missing_data_LASHiS.txt
    fi
    
    paste -d' ' ${results_dir}/${subjName}/${subjName}*ses-01*left*.txt \
    ${results_dir}/${subjName}/${subjName}*ses-02*left*.txt \
    > ${results_dir}/${subjName}/${subjName}_left_2-sessions.txt
    
    paste -d' ' ${results_dir}/${subjName}/${subjName}*ses-01*right*.txt \
    ${results_dir}/${subjName}/${subjName}*ses-02*right*.txt \
    > ${results_dir}/${subjName}/${subjName}_right_2-sessions.txt
    
    paste -d' ' ${results_dir}/${subjName}/${subjName}_ses-01_T1w_N4corrected_norm_preproc_left_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-02_T1w_N4corrected_norm_preproc_left_corr_nogray_volumes.txt  \
    > ${results_dir}/${subjName}/${subjName}_ASHS_left_2-sessions.txt
    
    paste -d' ' ${results_dir}/${subjName}/${subjName}_ses-01_T1w_N4corrected_norm_preproc_right_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-02_T1w_N4corrected_norm_preproc_right_corr_nogray_volumes.txt  \
    > ${results_dir}/${subjName}/${subjName}_ASHS_right_2-sessions.txt
    
    cat ${results_dir}/${subjName}/${subjName}_left_2-sessions.txt>>${results_dir}/hippocampus_volumes.csv
    cat ${results_dir}/${subjName}/${subjName}_right_2-sessions.txt>>${results_dir}/hippocampus_volumes.csv
    cat ${results_dir}/${subjName}/${subjName}_ASHS_left_2-sessions.txt >> ${results_dir}/ASHS_hippocampus_volumes.csv
    cat ${results_dir}/${subjName}/${subjName}_ASHS_right_2-sessions.txt >> ${results_dir}/ASHS_hippocampus_volumes.csv
    
done
#ses-03 only
for subjName in `cat ${github_dir}/subjnames_12_only.csv` ; do
    mkdir ${results_dir}/${subjName}
    if [[ -e ${proc_lashis_dir}/${subjName}/LASHiS/${subjName}_ses-01_T1w_N4corrected_norm_preprocleftSSTLabelsWarpedToTimePoint0_stats.txt ]] ; then
        
        cp ${proc_lashis_dir}/${subjName}/LASHiS/*txt ${results_dir}/${subjName}/
        #ashs_results
        cp ${proc_lashis_dir}/${subjName}/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/*/final/${subjName}_ses-01_T1w_N4corrected_norm_preproc_*_corr_nogray_volumes.txt ${results_dir}/${subjName}/
        cp ${proc_lashis_dir}/${subjName}/${subjName}_ses-02_T1w_N4corrected_norm_preproc_1/*/final/${subjName}_ses-02_T1w_N4corrected_norm_preproc_*_corr_nogray_volumes.txt ${results_dir}/${subjName}/
        cp ${proc_lashis_dir}/${subjName}/${subjName}_ses-03_T1w_N4corrected_norm_preproc_2/*/final/${subjName}_ses-03_T1w_N4corrected_norm_preproc_*_corr_nogray_volumes.txt ${results_dir}/${subjName}/
        
        #move the directories
        cd ${proc_lashis_dir}
        tar -cvzf ${move_dir}/${subjName}.tar.gz ./${subjName} && rm -rf ./${subjName}
    else
        echo "${subjName} missing 03 only" >> ${results_dir}/missing_data_LASHiS.txt
    fi
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
    
    paste -d' ' ${results_dir}/${subjName}/${subjName}_ses-01_T1w_N4corrected_norm_preproc_left_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-02_T1w_N4corrected_norm_preproc_left_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-03_T1w_N4corrected_norm_preproc_left_corr_nogray_volumes.txt  \
    > ${results_dir}/${subjName}/${subjName}_ASHS_left_3-sessions.txt
    
    paste -d' ' ${results_dir}/${subjName}/${subjName}_ses-01_T1w_N4corrected_norm_preproc_right_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-02_T1w_N4corrected_norm_preproc_right_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-03_T1w_N4corrected_norm_preproc_right_corr_nogray_volumes.txt  \
    > ${results_dir}/${subjName}/${subjName}_ASHS_right_3-sessions.txt
    
    cat ${results_dir}/${subjName}/${subjName}_ASHS_left_3-sessions.txt >> ${results_dir}/ASHS_hippocampus_volumes.csv
    cat ${results_dir}/${subjName}/${subjName}_ASHS_right_3-sessions.txt >> ${results_dir}/ASHS_hippocampus_volumes.csv
    
done
#ses-05 only
for subjName in `cat ${github_dir}/subjnames_24_only.csv` ; do
    mkdir ${results_dir}/${subjName}
    if [[ -e ${proc_lashis_dir}/${subjName}/LASHiS/${subjName}_ses-01_T1w_N4corrected_norm_preprocleftSSTLabelsWarpedToTimePoint0_stats.txt ]] ; then
        
        cp ${proc_lashis_dir}/${subjName}/LASHiS/*txt ${results_dir}/${subjName}/
        
        #ashs_results
        cp ${proc_lashis_dir}/${subjName}/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/*/final/${subjName}_ses-01_T1w_N4corrected_norm_preproc_*_corr_nogray_volumes.txt ${results_dir}/${subjName}/
        cp ${proc_lashis_dir}/${subjName}/${subjName}_ses-02_T1w_N4corrected_norm_preproc_1/*/final/${subjName}_ses-02_T1w_N4corrected_norm_preproc_*_corr_nogray_volumes.txt ${results_dir}/${subjName}/
        cp ${proc_lashis_dir}/${subjName}/${subjName}_ses-03_T1w_N4corrected_norm_preproc_2/*/final/${subjName}_ses-03_T1w_N4corrected_norm_preproc_*_corr_nogray_volumes.txt ${results_dir}/${subjName}/
        cp ${proc_lashis_dir}/${subjName}/${subjName}_ses-04_T1w_N4corrected_norm_preproc_3/*/final/${subjName}_ses-04_T1w_N4corrected_norm_preproc_*_corr_nogray_volumes.txt ${results_dir}/${subjName}/
        cp ${proc_lashis_dir}/${subjName}/${subjName}_ses-05_T1w_N4corrected_norm_preproc_4/*/final/${subjName}_ses-05_T1w_N4corrected_norm_preproc_*_corr_nogray_volumes.txt ${results_dir}/${subjName}/
        
        #move the directories
        cd ${proc_lashis_dir}
        tar -cvzf ${move_dir}/${subjName}.tar.gz ./${subjName} && rm -rf ./${subjName}
    else
        echo "${subjName} missing 05 only" >> ${results_dir}/missing_data_LASHiS.txt
    fi
    
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
    
    paste -d' ' ${results_dir}/${subjName}/${subjName}_ses-01_T1w_N4corrected_norm_preproc_left_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-02_T1w_N4corrected_norm_preproc_left_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-03_T1w_N4corrected_norm_preproc_left_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-04_T1w_N4corrected_norm_preproc_left_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-05_T1w_N4corrected_norm_preproc_left_corr_nogray_volumes.txt  \
    > ${results_dir}/${subjName}/${subjName}_ASHS_left_5-sessions.txt
    
    paste -d' ' ${results_dir}/${subjName}/${subjName}_ses-01_T1w_N4corrected_norm_preproc_right_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-02_T1w_N4corrected_norm_preproc_right_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-03_T1w_N4corrected_norm_preproc_right_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-04_T1w_N4corrected_norm_preproc_right_corr_nogray_volumes.txt  \
    ${results_dir}/${subjName}/${subjName}_ses-05_T1w_N4corrected_norm_preproc_right_corr_nogray_volumes.txt  \
    > ${results_dir}/${subjName}/${subjName}_ASHS_right_5-sessions.txt
    
    cat ${results_dir}/${subjName}/${subjName}_ASHS_left_5-sessions.txt >> ${results_dir}/ASHS_hippocampus_volumes.csv
    cat ${results_dir}/${subjName}/${subjName}_ASHS_right_5-sessions.txt >> ${results_dir}/ASHS_hippocampus_volumes.csv
done
date