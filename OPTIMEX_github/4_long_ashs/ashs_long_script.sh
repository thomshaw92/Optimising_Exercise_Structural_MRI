#!/bin/bash
#this is the ashs longitudinal script for OPTIMEX
#data should be processed using antsLongitudinalCorticalThickness beforehand. 
#Processing will be completed for participants with 2 time points and then 3 if they have them.
#
#Thomas Shaw 30/05/18 

subjName=$1
source ~/.bashrc
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=4
export NSLOTS=4
module load singularity/2.5.1
#ASHS, copy, untar, all commented.
ants_singularity="singularity exec --bind $TMPDIR:/TMPDIR --pwd /TMPDIR/${subjName} /30days/$USER/ants_fsl_robex_20180524.simg"
ashs_singularity="singularity exec --bind $TMPDIR:/TMPDIR --pwd /TMPDIR/${subjName} /30days/$USER/ashs_20180706.simg"
#everything necessary should be in 4_long, and then cp and chmod to TMPDIR (needs the whole folder with the warps etc)
chmod -R 777 /RDS/Q0535/optimex/data/derivatives/3_alct/
mkdir $TMPDIR/$subjName
cp -r /RDS/Q0535/optimex/data/derivatives/3_alct/$subjName/${subjName}lct_3_timepoints.tar.gz $TMPDIR/$subjName
cp -r /RDS/Q0535/optimex/data/derivatives/3_alct/$subjName/${subjName}lct_2_timepoints.tar.gz $TMPDIR/$subjName
#unpack
cd $TMPDIR/$subjName
tar -zxvf ${subjName}lct_3_timepoints.tar.gz
tar -zxvf ${subjName}lct_2_timepoints.tar.gz
chmod -R 744 $TMPDIR/$subjName
mv $TMPDIR/${subjName}/${subjName}/${subjName}lct_3_timepointsSingleSubjectTemplate $TMPDIR/${subjName}/

# maybe
#if [[ -e $TMPDIR/$subjName/${subjName}lct_3_timepointsSingleSubjectTemplate/T_template0.nii.gz ]] ; then

##########3 TIMEPOINTS##############
$ashs_singularity /ashs-1.0.0/bin/ashs_main.sh -I $subjName -a /ashs_atlas_upennpmc_20170810 -g ${subjName}lct_3_timepointsSingleSubjectTemplate/T_template0.nii.gz -f ${subjName}lct_3_timepointsSingleSubjectTemplate/T_template1.nii.gz -w ${subjName}_ashs_long_three_timepoints

#warp segmentations back to subject space. 
#TP1 
$ants_singularity antsApplyTransforms -n NearestNeighbor -d 3 -i ${subjName}_ashs_long_three_timepoints/final/${subjName}_left_lfseg_corr_nogray.nii.gz -o ${subjName}_ashs_long_three_timepoints/final/${subjName}_left_lfseg_corr_nogray_WarpedToSubjectSpace01.nii.gz -t ${subjName}lct_3_timepoints/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/${subjName}_ses-01_T1w_N4corrected_norm_preprocTemplateToSubject1GenericAffine.mat -t ${subjName}lct_3_timepoints/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/${subjName}_ses-01_T1w_N4corrected_norm_preprocTemplateToSubject0Warp.nii.gz -r ${subjName}lct_3_timepointsSingleSubjectTemplate/T_template0.nii.gz

$ants_singularity antsApplyTransforms -n NearestNeighbor -d 3 -i ${subjName}_ashs_long_three_timepoints/final/${subjName}_right_lfseg_corr_nogray.nii.gz -o ${subjName}_ashs_long_three_timepoints/final/${subjName}_right_lfseg_corr_nogray_WarpedToSubjectSpace01.nii.gz -t ${subjName}lct_3_timepoints/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/${subjName}_ses-01_T1w_N4corrected_norm_preprocTemplateToSubject1GenericAffine.mat -t ${subjName}lct_3_timepoints/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/${subjName}_ses-01_T1w_N4corrected_norm_preprocTemplateToSubject0Warp.nii.gz -r ${subjName}lct_3_timepointsSingleSubjectTemplate/T_template0.nii.gz

#TP06
$ants_singularity antsApplyTransforms -n NearestNeighbor -d 3 -i ${subjName}_ashs_long_three_timepoints/final/${subjName}_left_lfseg_corr_nogray.nii.gz -o ${subjName}_ashs_long_three_timepoints/final/${subjName}_left_lfseg_corr_nogray_WarpedToSubjectSpace06.nii.gz -t ${subjName}lct_3_timepoints/${subjName}_ses-06_T1w_N4corrected_norm_preproc_1/${subjName}_ses-06_T1w_N4corrected_norm_preprocTemplateToSubject1GenericAffine.mat -t ${subjName}lct_3_timepoints/${subjName}_ses-06_T1w_N4corrected_norm_preproc_1/${subjName}_ses-06_T1w_N4corrected_norm_preprocTemplateToSubject0Warp.nii.gz -r ${subjName}lct_3_timepointsSingleSubjectTemplate/T_template0.nii.gz

$ants_singularity antsApplyTransforms -n NearestNeighbor -d 3 -i ${subjName}_ashs_long_three_timepoints/final/${subjName}_right_lfseg_corr_nogray.nii.gz -o ${subjName}_ashs_long_three_timepoints/final/${subjName}_right_lfseg_corr_nogray_WarpedToSubjectSpace06.nii.gz -t ${subjName}lct_3_timepoints/${subjName}_ses-06_T1w_N4corrected_norm_preproc_1/${subjName}_ses-06_T1w_N4corrected_norm_preprocTemplateToSubject1GenericAffine.mat -t ${subjName}lct_3_timepoints/${subjName}_ses-06_T1w_N4corrected_norm_preproc_1/${subjName}_ses-06_T1w_N4corrected_norm_preprocTemplateToSubject0Warp.nii.gz -r ${subjName}lct_3_timepointsSingleSubjectTemplate/T_template0.nii.gz

#TP12
$ants_singularity antsApplyTransforms -n NearestNeighbor -d 3 -i ${subjName}_ashs_long_three_timepoints/final/${subjName}_left_lfseg_corr_nogray.nii.gz -o ${subjName}_ashs_long_three_timepoints/final/${subjName}_left_lfseg_corr_nogray_WarpedToSubjectSpace12.nii.gz -t ${subjName}lct_3_timepoints/${subjName}_ses-12_T1w_N4corrected_norm_preproc_2/${subjName}_ses-12_T1w_N4corrected_norm_preprocTemplateToSubject1GenericAffine.mat -t ${subjName}lct_3_timepoints/${subjName}_ses-12_T1w_N4corrected_norm_preproc_2/${subjName}_ses-12_T1w_N4corrected_norm_preprocTemplateToSubject0Warp.nii.gz -r ${subjName}lct_3_timepointsSingleSubjectTemplate/T_template0.nii.gz

$ants_singularity antsApplyTransforms -n NearestNeighbor -d 3 -i ${subjName}_ashs_long_three_timepoints/final/${subjName}_right_lfseg_corr_nogray.nii.gz -o ${subjName}_ashs_long_three_timepoints/final/${subjName}_right_lfseg_corr_nogray_WarpedToSubjectSpace12.nii.gz -t ${subjName}lct_3_timepoints/${subjName}_ses-12_T1w_N4corrected_norm_preproc_2/${subjName}_ses-12_T1w_N4corrected_norm_preprocTemplateToSubject1GenericAffine.mat -t ${subjName}lct_3_timepoints/${subjName}_ses-12_T1w_N4corrected_norm_preproc_2/${subjName}_ses-12_T1w_N4corrected_norm_preprocTemplateToSubject0Warp.nii.gz -r ${subjName}lct_3_timepointsSingleSubjectTemplate/T_template0.nii.gz

#copy the TSE to TMPDIR for ease 
cp $TMPDIR/$subjName/${subjName}lct_3_timepoints/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz $TMPDIR/$subjName/${subjName}_ashs_long_three_timepoints/final/
cp $TMPDIR/$subjName/${subjName}lct_3_timepoints/${subjName}_ses-06_T1w_N4corrected_norm_preproc_1/${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz $TMPDIR/$subjName/${subjName}_ashs_long_three_timepoints/final/
cp $TMPDIR/$subjName/${subjName}lct_3_timepoints/${subjName}_ses-12_T1w_N4corrected_norm_preproc_2/${subjName}_ses-12_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz $TMPDIR/$subjName/${subjName}_ashs_long_three_timepoints/final/
#do the same for the normalised ones just in case###
cp $TMPDIR/$subjName/${subjName}lct_3_timepoints/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preprocRigidToSSTWarped.nii.gz $TMPDIR/$subjName/${subjName}_ashs_long_three_timepoints/final/${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz
cp $TMPDIR/$subjName/${subjName}lct_3_timepoints/${subjName}_ses-06_T1w_N4corrected_norm_preproc_1/${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preprocRigidToSSTWarped.nii.gz $TMPDIR/$subjName/${subjName}_ashs_long_three_timepoints/final/${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz
cp $TMPDIR/$subjName/${subjName}lct_3_timepoints/${subjName}_ses-12_T1w_N4corrected_norm_preproc_2/${subjName}_ses-12_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preprocRigidToSSTWarped.nii.gz $TMPDIR/$subjName/${subjName}_ashs_long_three_timepoints/final/${subjName}_ses-12_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz

#get the values
$ashs_singularity /ashs-1.0.0/ext/Linux/bin/c3d ${subjName}_ashs_long_three_timepoints/final/${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz ${subjName}_ashs_long_three_timepoints/final/${subjName}_left_lfseg_corr_nogray_WarpedToSubjectSpace01.nii.gz -lstat >> $TMPDIR/$subjName/${subjName}_ashs_long_three_timepoints/final/${subjName}_left_nogray_vols_01.txt
$ashs_singularity /ashs-1.0.0/ext/Linux/bin/c3d ${subjName}_ashs_long_three_timepoints/final/${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz ${subjName}_ashs_long_three_timepoints/final/${subjName}_right_lfseg_corr_nogray_WarpedToSubjectSpace01.nii.gz -lstat >> $TMPDIR/$subjName/${subjName}_ashs_long_three_timepoints/final/${subjName}_right_nogray_vols_01.txt

$ashs_singularity /ashs-1.0.0/ext/Linux/bin/c3d ${subjName}_ashs_long_three_timepoints/final/${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz ${subjName}_ashs_long_three_timepoints/final/${subjName}_left_lfseg_corr_nogray_WarpedToSubjectSpace06.nii.gz -lstat >> $TMPDIR/$subjName/${subjName}_ashs_long_three_timepoints/final/${subjName}_left_nogray_vols_06.txt
$ashs_singularity /ashs-1.0.0/ext/Linux/bin/c3d ${subjName}_ashs_long_three_timepoints/final/${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz ${subjName}_ashs_long_three_timepoints/final/${subjName}_right_lfseg_corr_nogray_WarpedToSubjectSpace06.nii.gz -lstat >> $TMPDIR/$subjName/${subjName}_ashs_long_three_timepoints/final/${subjName}_right_nogray_vols_06.txt

$ashs_singularity /ashs-1.0.0/ext/Linux/bin/c3d ${subjName}_ashs_long_three_timepoints/final/${subjName}_ses-12_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz ${subjName}_ashs_long_three_timepoints/final/${subjName}_left_lfseg_corr_nogray_WarpedToSubjectSpace12.nii.gz -lstat >> $TMPDIR/$subjName/${subjName}_ashs_long_three_timepoints/final/${subjName}_left_nogray_vols_12.txt
$ashs_singularity /ashs-1.0.0/ext/Linux/bin/c3d ${subjName}_ashs_long_three_timepoints/final/${subjName}_ses-12_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz ${subjName}_ashs_long_three_timepoints/final/${subjName}_right_lfseg_corr_nogray_WarpedToSubjectSpace12.nii.gz -lstat >> $TMPDIR/$subjName/${subjName}_ashs_long_three_timepoints/final/${subjName}_right_nogray_vols_12.txt

#copy it out
rsync -r -c -v $TMPDIR/${subjName}/${subjName}_ashs_long_three_timepoints /RDS/Q0535/optimex/data/derivatives/4_long_ashs/${subjName}/


mv $TMPDIR/${subjName}/${subjName}/${subjName}lct_2_timepointsSingleSubjectTemplate $TMPDIR/${subjName}/

##########2 TIMEPOINTS##############
$ashs_singularity /ashs-1.0.0/bin/ashs_main.sh -I $subjName -a /ashs_atlas_upennpmc_20170810 -g ${subjName}lct_2_timepointsSingleSubjectTemplate/T_template0.nii.gz -f ${subjName}lct_2_timepointsSingleSubjectTemplate/T_template1.nii.gz -w ${subjName}_ashs_long_two_timepoints

#warp segmentations back to subject space. 
#TP1 
$ants_singularity antsApplyTransforms -n NearestNeighbor -d 3 -i ${subjName}_ashs_long_two_timepoints/final/${subjName}_left_lfseg_corr_nogray.nii.gz -o ${subjName}_ashs_long_two_timepoints/final/${subjName}_left_lfseg_corr_nogray_WarpedToSubjectSpace01.nii.gz -t ${subjName}lct_2_timepoints/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/${subjName}_ses-01_T1w_N4corrected_norm_preprocTemplateToSubject1GenericAffine.mat -t ${subjName}lct_2_timepoints/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/${subjName}_ses-01_T1w_N4corrected_norm_preprocTemplateToSubject0Warp.nii.gz -r ${subjName}lct_2_timepointsSingleSubjectTemplate/T_template0.nii.gz

$ants_singularity antsApplyTransforms -n NearestNeighbor -d 3 -i ${subjName}_ashs_long_two_timepoints/final/${subjName}_right_lfseg_corr_nogray.nii.gz -o ${subjName}_ashs_long_two_timepoints/final/${subjName}_right_lfseg_corr_nogray_WarpedToSubjectSpace01.nii.gz -t ${subjName}lct_2_timepoints/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/${subjName}_ses-01_T1w_N4corrected_norm_preprocTemplateToSubject1GenericAffine.mat -t ${subjName}lct_2_timepoints/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/${subjName}_ses-01_T1w_N4corrected_norm_preprocTemplateToSubject0Warp.nii.gz -r ${subjName}lct_2_timepointsSingleSubjectTemplate/T_template0.nii.gz

#TP06
$ants_singularity antsApplyTransforms -n NearestNeighbor -d 3 -i ${subjName}_ashs_long_two_timepoints/final/${subjName}_left_lfseg_corr_nogray.nii.gz -o ${subjName}_ashs_long_two_timepoints/final/${subjName}_left_lfseg_corr_nogray_WarpedToSubjectSpace06.nii.gz -t ${subjName}lct_2_timepoints/${subjName}_ses-06_T1w_N4corrected_norm_preproc_1/${subjName}_ses-06_T1w_N4corrected_norm_preprocTemplateToSubject1GenericAffine.mat -t ${subjName}lct_2_timepoints/${subjName}_ses-06_T1w_N4corrected_norm_preproc_1/${subjName}_ses-06_T1w_N4corrected_norm_preprocTemplateToSubject0Warp.nii.gz -r ${subjName}lct_2_timepointsSingleSubjectTemplate/T_template0.nii.gz

$ants_singularity antsApplyTransforms -n NearestNeighbor -d 3 -i ${subjName}_ashs_long_two_timepoints/final/${subjName}_right_lfseg_corr_nogray.nii.gz -o ${subjName}_ashs_long_two_timepoints/final/${subjName}_right_lfseg_corr_nogray_WarpedToSubjectSpace06.nii.gz -t ${subjName}lct_2_timepoints/${subjName}_ses-06_T1w_N4corrected_norm_preproc_1/${subjName}_ses-06_T1w_N4corrected_norm_preprocTemplateToSubject1GenericAffine.mat -t ${subjName}lct_2_timepoints/${subjName}_ses-06_T1w_N4corrected_norm_preproc_1/${subjName}_ses-06_T1w_N4corrected_norm_preprocTemplateToSubject0Warp.nii.gz -r ${subjName}lct_2_timepointsSingleSubjectTemplate/T_template0.nii.gz

#copy the TSE to TMPDIR for ease 
cp $TMPDIR/$subjName/${subjName}lct_2_timepoints/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz $TMPDIR/$subjName/${subjName}_ashs_long_two_timepoints/final/
cp $TMPDIR/$subjName/${subjName}lct_2_timepoints/${subjName}_ses-06_T1w_N4corrected_norm_preproc_1/${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz $TMPDIR/$subjName/${subjName}_ashs_long_two_timepoints/final/

#do the same for the normalised ones just in case###
cp $TMPDIR/$subjName/${subjName}lct_2_timepoints/${subjName}_ses-01_T1w_N4corrected_norm_preproc_0/${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preprocRigidToSSTWarped.nii.gz $TMPDIR/$subjName/${subjName}_ashs_long_two_timepoints/final/${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz
cp $TMPDIR/$subjName/${subjName}lct_2_timepoints/${subjName}_ses-06_T1w_N4corrected_norm_preproc_1/${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preprocRigidToSSTWarped.nii.gz $TMPDIR/$subjName/${subjName}_ashs_long_two_timepoints/final/${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz

#get the values

$ashs_singularity /ashs-1.0.0/ext/Linux/bin/c3d ${subjName}_ashs_long_two_timepoints/final/${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz ${subjName}_ashs_long_two_timepoints/final/${subjName}_left_lfseg_corr_nogray_WarpedToSubjectSpace01.nii.gz -lstat >> $TMPDIR/$subjName/${subjName}_ashs_long_two_timepoints/final/${subjName}_left_nogray_vols_01.txt
$ashs_singularity /ashs-1.0.0/ext/Linux/bin/c3d ${subjName}_ashs_long_two_timepoints/final/${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz ${subjName}_ashs_long_two_timepoints/final/${subjName}_right_lfseg_corr_nogray_WarpedToSubjectSpace01.nii.gz -lstat >> $TMPDIR/$subjName/${subjName}_ashs_long_two_timepoints/final/${subjName}_right_nogray_vols_01.txt

$ashs_singularity /ashs-1.0.0/ext/Linux/bin/c3d ${subjName}_ashs_long_two_timepoints/final/${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz ${subjName}_ashs_long_two_timepoints/final/${subjName}_left_lfseg_corr_nogray_WarpedToSubjectSpace06.nii.gz -lstat >> $TMPDIR/$subjName/${subjName}_ashs_long_two_timepoints/final/${subjName}_left_nogray_vols_06.txt

$ashs_singularity /ashs-1.0.0/ext/Linux/bin/c3d ${subjName}_ashs_long_two_timepoints/final/${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preprocRigidToSSTWarped.nii.gz ${subjName}_ashs_long_two_timepoints/final/${subjName}_right_lfseg_corr_nogray_WarpedToSubjectSpace06.nii.gz -lstat >> $TMPDIR/$subjName/${subjName}_ashs_long_two_timepoints/final/${subjName}_right_nogray_vols_06.txt

rsync -r -v $TMPDIR/${subjName}/${subjName}_ashs_long_two_timepoints /RDS/Q0535/optimex/data/derivatives/4_long_ashs/${subjName}/

