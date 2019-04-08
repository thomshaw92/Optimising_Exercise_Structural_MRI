#!/bin/bash
#Thomas Shaw 24/9/18 
#Freesurfer script for HPC
subjName=$1
source ~/.bashrc
module load singularity/2.5.1
ss="ses-06"
singularity="singularity exec --bind $TMPDIR:/TMPDIR --pwd /TMPDIR/ /30days/$USER/ants_fsl_robex_20180427.simg"
rsync -r -v /RDS/Q0535/optimex/data/${subjName}/$ss/anat/${subjName}_${ss}_T1w.nii.gz $TMPDIR 
rsync -r -v /RDS/Q0535/optimex/data/derivatives/preprocessing/$subjName/${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preproc.nii.gz $TMPDIR/
cd $TMPDIR
chmod -R 740 $TMPDIR/
t1w=$TMPDIR/${subjName}_${ss}_T1w.nii.gz
T2=$TMPDIR/${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preproc.nii.gz
module load freesurfer/6.1dev
source $FREESURFER_HOME/SetUpFreeSurfer.sh
SUBJECTS_DIR=$TMPDIR/
recon-all -autorecon1 -cm -s $subjName -i $t1w
mri_convert $SUBJECTS_DIR/${subjName}/mri/brainmask.mgz $SUBJECTS_DIR/${subjName}/mri/brainmask_nii.nii.gz
$singularity runROBEX.sh ${subjName}_${ss}_T1w.nii.gz ${subjName}_${ss}_T1w_brain_preproc.nii.gz ${subjName}_${ss}_T1w_brainmask.nii.gz
$singularity flirt -searchrx -180 180 -searchry -180 180 -searchrz -180 -180 -in ${subjName}_${ss}_T1w_brain_preproc.nii.gz -ref $subjName/mri/brainmask_nii.nii.gz -out ${subjName}_t1_brainmask_robex.nii.gz
mri_convert $TMPDIR/${subjName}_t1_brainmask_robex.nii.gz $SUBJECTS_DIR/${subjName}/mri/brainmask.mgz
recon-all -autorecon2 -autorecon3 -cm -s $subjName -T2 $T2 -T2pial -no-isrunning
segmentHA_T2.sh $subjName $T2 T1T2 USE_T1 [$SUBJECTS_DIR]

chmod -R 777 $TMPDIR 
rsync -v -c -r $TMPDIR/$subjName /RDS/Q0535/optimex/data/derivatives/5_freesurfer/
