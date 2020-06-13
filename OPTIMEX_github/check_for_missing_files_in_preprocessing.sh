#!/bin/bash
github_dir=~/scripts/Optimising_Exercise_Structural_MRI/OPTIMEX_github
preprocessing_dir="/RDS/Q0535/data/derivatives/preprocessing"

#ses-01 only

for x in `cat ${github_dir}/subjnames_01_only.csv` ; do 
	if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]] ;  then
		echo ${x} from ses-01_only missing ses-01 T2 nlinmoco
	fi
	if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-01_T1w_N4corrected_norm_brain_preproc.nii.gz ]] ; then
                echo ${x} from ses-01_only missing ses-01 T1 preproc
        fi
done 

#ses-02 only

for x in `cat ${github_dir}/subjnames_06_only.csv` ; do
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]] ;  then
                echo ${x} from ses-06_only missing ses-01 T2 nlinmoco
        fi
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-01_T1w_N4corrected_norm_brain_preproc.nii.gz ]] ; then
                echo ${x} from ses-06_only missing ses-01 T1 preproc
        fi
	if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-02_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]] ;  then
                echo ${x} from ses-06_only missing ses-02 T2 nlinmoco
        fi
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-02_T1w_N4corrected_norm_brain_preproc.nii.gz ]] ; then
                echo ${x} from ses-06_only missing ses-02 T1 preproc
        fi

done


#ses-03 only


for x in `cat ${github_dir}/subjnames_12_only.csv` ; do
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]] ;  then
                echo ${x} from ses-12_only missing ses-01 T2 nlinmoco
        fi
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-01_T1w_N4corrected_norm_brain_preproc.nii.gz ]] ; then
                echo ${x} from ses-12_only missing ses-01 T1 preproc
        fi
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-02_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]] ;  then
                echo ${x} from ses-12_only missing ses-02 T2 nlinmoco
        fi
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-02_T1w_N4corrected_norm_brain_preproc.nii.gz ]] ; then
                echo ${x} from ses-12_only missing ses-02 T1 preproc
        fi
	if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-03_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]] ;  then
                echo ${x} from ses-12_only missing ses-03 T2 nlinmoco
        fi
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-03_T1w_N4corrected_norm_brain_preproc.nii.gz ]] ; then
                echo ${x} from ses-12_only missing ses-03 T1 preproc
        fi
done


#ses-05 only

for x in `cat ${github_dir}/subjnames_24_only.csv` ; do
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]] ;  then
                echo ${x} from ses-24_only missing ses-01 T2 nlinmoco
        fi
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-01_T1w_N4corrected_norm_brain_preproc.nii.gz ]] ; then
                echo ${x} from ses-24_only missing ses-01 T1 preproc
        fi
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-02_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]] ;  then
                echo ${x} from ses-24_only missing ses-02 T2 nlinmoco
        fi
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-02_T1w_N4corrected_norm_brain_preproc.nii.gz ]] ; then
                echo ${x} from ses-24_only missing ses-02 T1 preproc
        fi
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-03_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]] ;  then
                echo ${x} from ses-24_only missing ses-03 T2 nlinmoco
        fi
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-03_T1w_N4corrected_norm_brain_preproc.nii.gz ]] ; then
                echo ${x} from ses-24_only missing ses-03 T1 preproc
        fi
	if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-04_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]] ;  then
                echo ${x} from ses-24_only missing ses-04 T2 nlinmoco
        fi
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-04_T1w_N4corrected_norm_brain_preproc.nii.gz ]] ; then
                echo ${x} from ses-24_only missing ses-04 T1 preproc
        fi
	if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-05_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]] ;  then
                echo ${x} from ses-24_only missing ses-05 T2 nlinmoco
        fi
        if [[ ! -e ${preprocessing_dir}/${x}/${x}_ses-05_T1w_N4corrected_norm_brain_preproc.nii.gz ]] ; then
                echo ${x} from ses-24_only missing ses-05 T1 preproc
        fi
done
date
