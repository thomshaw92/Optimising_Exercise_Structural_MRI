#!/bin/bash
#Thomas Shaw 24/9/18
#Freesurfer script for HPC - only for TP1 for ETIV measurement.
subjName=sub-1001DS
source ~/.bashrc
module load singularity
ss="ses-01"
singularity="singularity exec --bind $TMPDIR:/TMPDIR --pwd /TMPDIR/ /30days/$USER/ants_fsl_robex_20180524.simg"
#rsync -r -v /3/data/bids/${subjName}/$ss/anat/${subjName}_${ss}*T1w.nii.gz $TMPDIR/${subjName}_${ss}_T1w.nii.gz
#rsync -r -v /RDS/Q0535/optimex/data/derivatives/preprocessing/$subjName/${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preproc.nii.gz $TMPDIR/
cd $TMPDIR
chmod -R 740 $TMPDIR/
cp /30days/uqtshaw/optimex/bids/${subjName}/ses-01/anat/${subjName}_${ss}*run-1_T1w.nii.gz $TMPDIR/${subjName}_t1w.nii.gz
t1w=/30days/uqtshaw/optimex/bids/${subjName}/ses-01/anat/${subjName}*${ss}_T1w.nii.gz
#T2=$TMPDIR/${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preproc.nii.gz
module load freesurfer/6.1dev
source $FREESURFER_HOME/SetUpFreeSurfer.sh
SUBJECTS_DIR=$TMPDIR
recon-all -autorecon1 -cm -s $subjName -i $TMPDIR/${subjName}_t1w.nii.gz
mri_convert $SUBJECTS_DIR/${subjName}/mri/brainmask.mgz $SUBJECTS_DIR/${subjName}/mri/brainmask_nii.nii.gz
$singularity runROBEX.sh /TMPDIR/${subjName}/mri/brainmask_nii.nii.gz /TMPDIR/${subjName}/mri/brain_robex.nii.gz /TMPDIR/${subjName}/mri/brainmask_robex.nii.gz
mri_convert $SUBJECTS_DIR/${subjName}/mri/brain_robex.nii.gz $SUBJECTS_DIR/${subjName}/mri/brainmask.mgz
recon-all -autorecon2 -autorecon3 -cm -s $subjName
#segmentHA_T2.sh $subjName $T2 T1T2 USE_T1 [$SUBJECTS_DIR]

chmod -R 777 $TMPDIR
rsync -v -r $TMPDIR/$subjName /90days/${USER}/optimex/freesurfer/