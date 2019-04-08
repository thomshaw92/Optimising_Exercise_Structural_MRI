#!/bin/bash
#this is the ashs script for optimex. No need for lin and Ave ASHS - just non lin
#Thomas Shaw 11/4/18 
#run ashs after checking inputs exist
subjName=$1
source ~/.bashrc
module load singularity/2.5.1
ashs_singularity="singularity exec --bind $TMPDIR:/TMPDIR/ --pwd /TMPDIR/ /30days/$USER/ashs_20180427.simg"
singularity="singularity exec --bind $TMPDIR:/TMPDIR --pwd /TMPDIR/ /30days/uqtshaw/ants_fsl_robex_20180427.simg"
ss="ses-06"
cp -r /RDS/Q0535/optimex/data/derivatives/preprocessing/${subjName}/${subjName}_${ss}_T1w_N4corrected_norm_brain_preproc.nii.gz $TMPDIR 
cp -r /RDS/Q0535/optimex/data/derivatives/preprocessing/${subjName}/${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz $TMPDIR
cd $TMPDIR
chmod -R 740 $TMPDIR/

t1wpp=$TMPDIR/${subjName}_${ss}_T1w_N4corrected_norm_brain_preproc.nii.gz

t2NLIN=$TMPDIR/${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preproc.nii.gz

$singularity ~/scripts/niifti_normalise.sh -i /TMPDIR/${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz -o /TMPDIR/${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preproc.nii.gz


if [[ ! -e $t2NLIN ]] ; then echo "$subjName ${ss} t2 NON LINEAR not found exiting">>/RDS/Q0535/optimex/data/derivatives/ashsErrorLog.txt 
    exit 1
fi
if [[ ! -e $t1wpp ]] ; then echo "$subjName ${ss} t1w not found exiting">>/RDS/Q0535/optimex/data/derivatives/ashsErrorLog.txt 
    exit 1
fi
chmod -R 777 $TMPDIR/

$ashs_singularity /ashs-1.0.0/bin/ashs_main.sh -I $subjName -a /ashs_atlas_upennpmc_20170810 -g ${subjName}_${ss}_T1w_N4corrected_norm_brain_preproc.nii.gz -f ${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_norm_brain_preproc.nii.gz -w ${subjName}_${ss}_ashs_xs

chmod -R 777 $TMPDIR 
rm -r $TMPDIR/${subjName}_${ss}_ashs_xs/multiatlas
rm -r $TMPDIR/${subjName}_${ss}_ashs_xs/flirt_t2_to_t1
rm -r $TMPDIR/${subjName}_${ss}_ashs_xs/dump
rm -r $TMPDIR/${subjName}_${ss}_ashs_xs/bootstrap
rm -r $TMPDIR/${subjName}_${ss}_ashs_xs/ants_t1_to_temp
rm -r $TMPDIR/${subjName}_${ss}_ashs_xs/affine_t1_to_template
rm $TMPDIR/${subjName}_${ss}_ashs_xs/mprage*
rm $TMPDIR/${subjName}_${ss}_ashs_xs/tse*
rsync -v -c -r $TMPDIR/${subjName}_${ss}_ashs_xs /RDS/Q0535/optimex/data/derivatives/2_ashs_xs/
