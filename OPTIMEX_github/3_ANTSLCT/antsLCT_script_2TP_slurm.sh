#!/bin/bash
#Ants LCT script. Need to update LCT script to remove N4 in SST creation. #done 24/05
subjName=$1
singularity="singularity exec --bind /data:/data/ --pwd /data/fasttemp/uqtshaw/optimising_exercise/data/derivatives/preprocessing/${subjName} /data/fasttemp/uqtshaw/tomcat/data/ants_fsl_robex_20180524.simg"
mkdir -p /data/fasttemp/uqtshaw/optimising_exercise/data/derivatives/3_alct/$subjName
#ANTS LCT 3TP
$singularity antsLongitudinalCorticalThickness_noN4.sh -d 3 -e /data/fasttemp/uqtshaw/cai_63_template/cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin.nii.gz -m /data/fasttemp/uqtshaw/cai_63_template/cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin_ProbabilityMask.nii.gz -p /data/fasttemp/uqtshaw/cai_63_template/cai63_asym_2017_nlin_TempAndPriors/prior%d.nii.gz -f /data/fasttemp/uqtshaw/cai_63_template/cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin_BrainExtractionMask.nii.gz -t /data/fasttemp/uqtshaw/cai_63_template/cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin_Extracted_Brain.nii.gz -o /data/fasttemp/uqtshaw/optimising_exercise/data/derivatives/3_alct/$subjName/${subjName}lct_2_timepoints -k '2' -c '2' -j '16' -r '1' -q '0' -n '1' -b '1' \
	${subjName}_ses-01_T1w_N4corrected_norm_preproc.nii.gz ${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz \
	${subjName}_ses-06_T1w_N4corrected_norm_preproc.nii.gz ${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz 

