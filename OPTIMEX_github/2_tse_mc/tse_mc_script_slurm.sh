#!/bin/bash
#nlin realignment/MC script. Needs to be without skull for nlin.
subjName=$1
mkdir ~/${1}_TMPDIR
TMPDIR=~/${1}_TMPDIR
for ss in "ses-06" "ses-12" ; do
singularity="singularity exec --bind $TMPDIR:/TMPDIR --pwd /TMPDIR/$subjName /data/fasttemp/uqtshaw/ants_fsl_robex_20180427.simg"
mkdir $TMPDIR/$subjName

#if [[ ! -e ${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preproc.nii.gz ]] ; then
    for x in 1 2 3 ; do
	raw_data_dir=/data/fasttemp/uqtshaw/optimising_exercise/data
	cp ${raw_data_dir}/derivatives/preprocessing/${subjName}/${subjName}_${ss}_T2w_run-${x}_res-iso.3_N4corrected_norm_brain_preproc.nii.gz $TMPDIR/$subjName ;
    done
    cd $TMPDIR/$subjName
    chmod +rwx $TMPDIR/$subjName/*
    #nlin TSE MC
    $singularity ls

    #nlin TSE MC
    $singularity antsMultivariateTemplateConstruction.sh -d '3' -b '0' -c '2' -j '4' -i '2' -k '1' -t SyN -m '50x80x20' -s CC -t GR -n '0' -r '0' -g '0.2' -o ${subjName}_${ss}_T2w_nlinMoCo_res-iso.3_N4corrected_brain_ ${subjName}_${ss}_T2w_run-*_res-iso.3_N4corrected_norm_brain_preproc.nii.gz

   mv $TMPDIR/${subjName}/${subjName}_${ss}_T2w_nlinMoCo_res-iso.3_N4corrected_brain_template0.nii.gz $TMPDIR/${subjName}/${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_brain_preproc.nii.gz

    $singularity DenoiseImage -d 3 -n Rician -i ${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_brain_preproc.nii.gz -o ${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz -v

    $singularity ~/scripts/niifti_normalise.sh -i ./${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz -o ./${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preproc.nii.gz

    #Check it exists
    if [[ ! -e $TMPDIR/${subjName}/${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preproc.nii.gz ]] ; then echo "ERROR $subjName $ss template not created" >> /30days/$USER/error_list.txt
    fi

    #Code here for linear and averaging pls.
    $singularity fslmerge -t ./${subjName}_${ss}_T2w_merged_res-iso.3_N4corrected_norm_brain_preproc.nii.gz ./${subjName}_${ss}_T2w_run-1_res-iso.3_N4corrected_norm_brain_preproc.nii.gz ./${subjName}_${ss}_T2w_run-2_res-iso.3_N4corrected_norm_brain_preproc.nii.gz ./${subjName}_${ss}_T2w_run-3_res-iso.3_N4corrected_norm_brain_preproc.nii.gz

    if [[ ! -e ./${subjName}_${ss}_T2w_merged_res-iso.3_N4corrected_norm_brain_preproc.nii.gz ]] ; then
	$singularity flirt -v -in ./${subjName}_${ss}_T2w_run-3_res-iso.3_N4corrected_norm_brain_preproc.nii.gz -ref ./${subjName}_${ss}_T2w_run-1_res-iso.3_N4corrected_norm_brain_preproc.nii.gz -applyxfm -usesqform -out ./${subjName}_${ss}_T2w_run-3_res-iso.3_N4corrected_norm_brain_preproc.nii.gz
	$singularity flirt -v -in ./${subjName}_${ss}_T2w_run-2_res-iso.3_N4corrected_norm_brain_preproc.nii.gz -ref ./${subjName}_${ss}_T2w_run-1_res-iso.3_N4corrected_norm_brain_preproc.nii.gz -applyxfm -usesqform -out ./${subjName}_${ss}_T2w_run-2_res-iso.3_N4corrected_norm_brain_preproc.nii.gz
	$singularity fslmerge -t ./${subjName}_${ss}_T2w_merged_res-iso.3_N4corrected_norm_brain_preproc.nii.gz ./${subjName}_${ss}_T2w_run-1_res-iso.3_N4corrected_norm_brain_preproc.nii.gz ./${subjName}_${ss}_T2w_run-2_res-iso.3_N4corrected_norm_brain_preproc.nii.gz ./${subjName}_${ss}_T2w_run-3_res-iso.3_N4corrected_norm_brain_preproc.nii.gz
    fi
    #mcflirt
    $singularity mcflirt -in ./${subjName}_${ss}_T2w_merged_res-iso.3_N4corrected_norm_brain_preproc.nii.gz -out ./${subjName}_${ss}_T2w_merged_mcflirted_res-iso.3_N4corrected_norm_brain_preproc.nii.gz -stages 4 -sinc_final -meanvol -report
    #tmean
    $singularity fslmaths ./${subjName}_${ss}_T2w_merged_mcflirted_res-iso.3_N4corrected_norm_brain_preproc.nii.gz -Tmean ./${subjName}_${ss}_T2w_LinMoCo_res-iso.3_N4corrected_norm_brain_preproc.nii.gz
    $singularity fslmaths ./${subjName}_${ss}_T2w_merged_res-iso.3_N4corrected_norm_brain_preproc.nii.gz -Tmean ./${subjName}_${ss}_T2w_Ave_res-iso.3_N4corrected_norm_brain_preproc.nii.gz
    #denoise and norm ave and lin
    $singularity DenoiseImage -d 3 -n Rician -i ${subjName}_${ss}_T2w_LinMoCo_res-iso.3_N4corrected_norm_brain_preproc.nii.gz -o ${subjName}_${ss}_T2w_LinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz -v
    $singularity DenoiseImage -d 3 -n Rician -i ${subjName}_${ss}_T2w_Ave_res-iso.3_N4corrected_norm_brain_preproc.nii.gz -o ${subjName}_${ss}_T2w_Ave_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz -v
    $singularity ~/scripts/niifti_normalise.sh -i ./${subjName}_${ss}_T2w_LinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz -o ./${subjName}_${ss}_T2w_LinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preproc.nii.gz
    $singularity ~/scripts/niifti_normalise.sh -i ./${subjName}_${ss}_T2w_Ave_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz -o ./${subjName}_${ss}_T2w_Ave_res-iso.3_N4corrected_denoised_norm_brain_preproc.nii.gz
    rm ./${subjName}_${ss}_T2w_merged_res-iso.3_N4corrected_norm_brain_preproc.nii.gz
    rm ./${subjName}_${ss}_T2w_merged_res-iso.3_N4corrected_norm_preproc.nii.gz
    rm ./${subjName}_${ss}_T2w_merged_mcflirted_res-iso.3_N4corrected_norm_brain_preproc.nii.gz
    rm ./${subjName}_${ss}_T2w_merged_mcflirted_res-iso.3_N4corrected_norm_preproc.nii.gz
    rm ./${subjName}_${ss}_T2w_merged_mcflirted_res-iso.3_N4corrected_norm_brain_preproc.nii.gz_mean_reg.nii.gz
    rm ./${subjName}_${ss}_T2w_merged_mcflirted_res-iso.3_N4corrected_norm_preproc.nii.gz_mean_reg.nii.gz
    rm ./${subjName}_${ss}_T2w_run-*_N4corrected_preproc.nii.gz

    cp ${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preproc.nii.gz ${raw_data_dir}/derivatives/preprocessing/$subjName
    cp ${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ${raw_data_dir}/derivatives/preprocessing/$subjName
    cp ${subjName}_${ss}_T2w_LinMoCo_res-iso.3_N4corrected_norm_brain_preproc.nii.gz ${raw_data_dir}/derivatives/preprocessing/$subjName
    cp ${subjName}_${ss}_T2w_LinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ${raw_data_dir}/derivatives/preprocessing/$subjName
    cp  ${subjName}_${ss}_T2w_Ave_res-iso.3_N4corrected_norm_brain_preproc.nii.gz ${raw_data_dir}/derivatives/preprocessing/$subjName
    cp ${subjName}_${ss}_T2w_Ave_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ${raw_data_dir}/derivatives/preprocessing/$subjName
mv $TMPDIR /data/fasttemp/uqtshaw/tomcat/data/derivatives/preprocessing/${subjName}_${ss}_tmpdir
rm -rf $TMPDIR
done


