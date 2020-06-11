module load singualarity
SUBJNAME=sub-1001DS
preprocessing_dir=/30days/uqtshaw/optimex/${SUBJNAME}
singularity exec /90days/uqtshaw/LASHiS.simg /LASHiS.sh \
-a /30days/uqtshaw/ashs_atlas_umcutrecht_7t_20170810/  \
-c '2' \
-n '0' \
-j '16' \
-o /30days/uqtshaw/optimex/derivatives/LASHiS/test \
${preprocessing_dir}/${SUBJNAME}_ses-01_T1w_N4corrected_norm_preproc.nii.gz ${preprocessing_dir}/${SUBJNAME}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz \
${preprocessing_dir}/${SUBJNAME}_ses-02_T1w_N4corrected_norm_preproc.nii.gz ${preprocessing_dir}/${SUBJNAME}_ses-02_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz