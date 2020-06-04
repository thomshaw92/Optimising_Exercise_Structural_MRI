#!/bin/bash
#Thomas Shaw 5/4/18
#and still working on it 18/5/2020
#skull strip t1/tse, bias correct, normalise, interpolate, then nlinMoco, and denoise
subjName=$1
source ~/.bashrc
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=12
export NSLOTS=12
echo $TMPDIR
raw_data_dir=/30days/${USER}/optimex/bids
data_dir=/30days/$USER/optimex
for ss in ses-01 ses-02 ses-03 ses-04 ses-05; do
	if [[ -d ${raw_data_dir}/${subjName}/${ss} ]]; then
		rsync -rv $raw_data_dir/${subjName}/${ss}/anat $TMPDIR
		mkdir -p $TMPDIR/$subjName
		chmod 744 $TMPDIR -R
		mv $TMPDIR/anat/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-1_T2w.nii.gz $TMPDIR/$subjName
		mv $TMPDIR/anat/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-2_T2w.nii.gz $TMPDIR/$subjName
		mv $TMPDIR/anat/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-3_T2w.nii.gz $TMPDIR/$subjName
		mv $TMPDIR/anat/${subjName}_${ss}_acq-*_run-1_T1w.nii.gz $TMPDIR/$subjName/${subjName}_${ss}_acq-mp2rage-UNIDEN_run-1_T1w.nii.gz
		module load singularity/2.5.1
		singularity="singularity exec --bind $TMPDIR:/TMPDIR --pwd /TMPDIR/ $data_dir/ants_fsl_robex_20180524.simg"
		t1w=/TMPDIR/${subjName}/${subjName}_${ss}_acq-mp2rage-UNIDEN_run-1_T1w.nii.gz #this isn't used
		tse1=/TMPDIR/${subjName}/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-1_T2w.nii.gz
		tse2=/TMPDIR/${subjName}/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-2_T2w.nii.gz
		tse3=/TMPDIR/${subjName}/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-3_T2w.nii.gz
		simg_input_dir=/TMPDIR/${subjName}
		if [[ ! -e $TMPDIR/${subjName}/${subjName}_${ss}*T1w.nii.gz ]]; then
			echo "Missing T1w for ${subjName}_${ss}" >>${data_dir}/preprocessing_error_log.txt
		fi
		if [[ ! -e $TMPDIR/${subjName}/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-1_T2w.nii.gz ]]; then
			echo "Missing tse1 for ${subjName}_${ss}" >>${data_dir}/preprocessing_error_log.txt
		fi
		if [[ ! -e $TMPDIR/${subjName}/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-2_T2w.nii.gz ]]; then
			echo "Missing tse2 for ${subjName}_${ss}" >>${data_dir}/preprocessing_error_log.txt
		fi
		if [[ ! -e $TMPDIR/${subjName}/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-3_T2w.nii.gz ]]; then
			echo "Missing tse3 for ${subjName}_${ss}" >>${data_dir}/preprocessing_error_log.txt
		fi

		#make output dir
		mkdir -p $data_dir/${subjName}
		#initial check to see if files exist, if so, exit loop
		if [[ ! -e ${data_dir}/${subjName}/${subjName}_${ss}_T1w_N4corrected_norm_brain_preproc.nii.gz ]]; then

			#initial skull strip
			if [[ ! -e ${data_dir}/${subjName}/${subjName}_${ss}_T1w_brainmask.nii.gz ]]; then
				echo "running robex for ${subjName}_${ss} T1w"
				$singularity runROBEX.sh ${simg_input_dir}/${subjName}_${ss}_acq-mp2rage-UNIDEN_run-1_T1w.nii.gz ${simg_input_dir}/${subjName}_${ss}_T1w_brain_preproc.nii.gz ${simg_input_dir}/${subjName}_${ss}_T1w_brainmask.nii.gz
			fi

			#bias correct t1
			if [[ ! -e ${data_dir}/${subjName}/${subjName}_${ss}_T1w_N4corrected_norm_brain_preproc.nii.gz ]]; then

				echo "running N4 for T1w for ${subjName}_${ss} T1w"
				$singularity N4BiasFieldCorrection -d 3 -b [1x1x1,3] -c '[50x50x40x30,0.00000001]' -i ${simg_input_dir}/${subjName}_${ss}_acq-mp2rage-UNIDEN_run-1_T1w.nii.gz -x ${simg_input_dir}/${subjName}_${ss}_T1w_brainmask.nii.gz -r 1 -o ${simg_input_dir}/${subjName}_${ss}_T1w_N4corrected_preproc.nii.gz --verbose 1 -s 2

				echo "re-running N4 for T1w for ${subjName}_${ss} T1w after resampling mask to whole image"
				$singularity antsApplyTransforms -d 3 -i ${simg_input_dir}/${subjName}_${ss}_T1w_brainmask.nii.gz -r ${simg_input_dir}/${subjName}_${ss}_acq-mp2rage-UNIDEN_run-1_T1w.nii.gz -n LanczosWindowedSinc -o ${simg_input_dir}/${subjName}_${ss}_T1w_brainmask.nii.gz
				$singularity N4BiasFieldCorrection -d 3 -b [1x1x1,3] -c '[50x50x40x30,0.00000001]' -i ${simg_input_dir}/${subjName}_${ss}_acq-mp2rage-UNIDEN_run-1_T1w.nii.gz -x ${simg_input_dir}/${subjName}_${ss}_T1w_brainmask.nii.gz -r 1 -o ${simg_input_dir}/${subjName}_${ss}_T1w_N4corrected_preproc.nii.gz --verbose 1 -s 2

				#rescale t1
				t1bc=${simg_input_dir}/${subjName}_${ss}_T1w_N4corrected_preproc.nii.gz

				echo "running robex again with N4'd T1w and norm intensities for T1w for ${subjName}_${ss} T1w"
				$singularity ImageMath 3 ${simg_input_dir}/${subjName}_${ss}_T1w_N4corrected_norm_preproc.nii.gz RescaleImage ${simg_input_dir}/${subjName}_${ss}_T1w_N4corrected_preproc.nii.gz 0 1000
				#skull strip new Bias corrected T1
				$singularity runROBEX.sh ${simg_input_dir}/${subjName}_${ss}_T1w_N4corrected_norm_preproc.nii.gz ${simg_input_dir}/${subjName}_${ss}_T1w_N4corrected_norm_brain_preproc.nii.gz ${simg_input_dir}/${subjName}_${ss}_T1w_brainmask.nii.gz
			fi
			#remove things
			rm $TMPDIR/$subjName/${subjName}_${ss}_T1w_brain_preproc.nii.gz
			rm $TMPDIR/$subjName/${subjName}_${ss}_T1w_N4corrected_preproc.nii.gz
		fi
		#make another loop for nlin bit.
		if [[ ! -e ${data_dir}/${subjName}/${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]]; then
			######TSE#####
			#apply mask to tse - resample like tse - this is just for BC
			if [[ ! -e ${data_dir}/${subjName}/${subjName}_${ss}_T2w_run-1_brainmask.nii.gz ]]; then
				echo " running apply transforms from T1 to TSE for brainmask for ${subjName}_${ss}"
				$singularity antsApplyTransforms -d 3 -i ${simg_input_dir}/${subjName}_${ss}_T1w_brainmask.nii.gz -r $tse1 -n NearestNeighbor -o ${simg_input_dir}/${subjName}_${ss}_T2w_run-1_brainmask.nii.gz
				$singularity antsApplyTransforms -d 3 -i ${simg_input_dir}/${subjName}_${ss}_T1w_brainmask.nii.gz -r $tse2 -n NearestNeighbor -o ${simg_input_dir}/${subjName}_${ss}_T2w_run-2_brainmask.nii.gz
				$singularity antsApplyTransforms -d 3 -i ${simg_input_dir}/${subjName}_${ss}_T1w_brainmask.nii.gz -r $tse3 -n NearestNeighbor -o ${simg_input_dir}/${subjName}_${ss}_T2w_run-3_brainmask.nii.gz
			fi
			#Bias correction - use mask created -
			for x in "1" "2" "3"; do
				if [[ ! -e ${data_dir}/${subjName}/${subjName}_${ss}_T2w_run-${x}_brainmask.nii.gz ]]; then
					echo "running TSE ${x} N4"
					#N4
					$singularity N4BiasFieldCorrection -d 3 -b [1x1x1,3] -c '[50x50x40x30,0.00000001]' -i ${simg_input_dir}/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-${x}_T2w.nii.gz -x ${simg_input_dir}/${subjName}_${ss}_T2w_run-${x}_brainmask.nii.gz -r 1 -o ${simg_input_dir}/${subjName}_${ss}_T2w_run-${x}_N4corrected_preproc.nii.gz --verbose 1 -s 2
					if [[ ! -e $TMPDIR/$subjName/${subjName}_${ss}_T2w_run-${x}_N4corrected_preproc.nii.gz ]]; then
						echo "TSE run ${x} did not bias correct for ${subjName}_${ss}, trying without mask " >>${data_dir}/preprocessing_error_log.txt
						$singularity N4BiasFieldCorrection -d 3 -b [1x1x1,3] -c '[50x50x40x30,0.00000001]' -i ${simg_input_dir}/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-${x}_T2w.nii.gz -r 1 -o ${simg_input_dir}/${subjName}_${ss}_T2w_run-${x}_N4corrected_preproc.nii.gz --verbose 1 -s 2
					fi
					#normalise intensities of the BC'd tses
					$singularity ImageMath 3 ${simg_input_dir}/${subjName}_${ss}_T2w_run-${x}_N4corrected_norm_preproc.nii.gz RescaleImage ${simg_input_dir}/${subjName}_${ss}_T2w_run-${x}_N4corrected_preproc.nii.gz 0 1000

					#interpolation of TSEs -bring all into the same space while minimising interpolation write steps.
					echo "running interpolation"
					$singularity flirt -v -applyisoxfm 0.3 -interp sinc -sincwidth 8 -in ${simg_input_dir}/${subjName}_${ss}_T2w_run-${x}_N4corrected_norm_preproc.nii.gz -ref ${simg_input_dir}/${subjName}_${ss}_T2w_run-${x}_N4corrected_norm_preproc.nii.gz -out ${simg_input_dir}/${subjName}_${ss}_T2w_run-${x}_res-iso.3_N4corrected_norm_preproc.nii.gz

					#create new brainmask and brain images.
					echo "running ants apply transforms to create new brainmask of TSE ${x}"
					$singularity antsApplyTransforms -d 3 -i ${simg_input_dir}/${subjName}_${ss}_T1w_brainmask.nii.gz -r ${simg_input_dir}/${subjName}_${ss}_T2w_run-${x}_res-iso.3_N4corrected_norm_preproc.nii.gz -n NearestNeighbor -o ${simg_input_dir}/${subjName}_${ss}_T2w_run-${x}_brainmask.nii.gz
					rm $TMPDIR/$subjName/${subjName}_${ss}_T2w_run-${x}_N4corrected_norm_preproc.nii.gz
				fi
			done
			for x in "1" "2" "3"; do
				#mask the preprocessed TSE.
				echo "masking the pp'd TSE ${x}"
				$singularity ImageMath 3 ${simg_input_dir}/${subjName}_${ss}_T2w_run-${x}_res-iso.3_N4corrected_norm_brain_preproc.nii.gz m ${simg_input_dir}/${subjName}_${ss}_T2w_run-${x}_res-iso.3_N4corrected_norm_preproc.nii.gz ${simg_input_dir}/${subjName}_${ss}_T2w_run-${x}_brainmask.nii.gz
				if [[ ! -e $TMPDIR/$subjName/${subjName}_${ss}_T2w_run-${x}_res-iso.3_N4corrected_norm_brain_preproc.nii.gz ]]; then
					echo "${subjName}_${ss} TSE ${x} failed preprocessing" >>${data_dir}/preprocessing_error_log.txt
				fi
				# rm brainmasks and other crap
				rm $TMPDIR/$subjName/${subjName}_${ss}_T2w_run-${x}_brainmask.nii.gz
				rm $TMPDIR/$subjName/${subjName}_${ss}_T2w_run-${x}_N4corrected_norm_preproc.nii.gz
				rm $TMPDIR/$subjName/${subjName}_${ss}_T2w_run-${x}_N4corrected_preproc.nii.gz
			done
			if [[ ! -e $TMPDIR/$subjName/${subjName}_${ss}_T1w_N4corrected_norm_preproc.nii.gz ]]; then
				echo "${subjName}_${ss} T1w failed preprocessing" >>${data_dir}/preprocessing_error_log.txt
			fi
			#copy all the things to the data dir
			rsync -rcv $TMPDIR/${subjName} ${data_dir}/

			#Non Linear Motion Correction - Note that rigid isn't used because it causes problems with PBS and singularity - shouldn't be a problem as the data is already aligned.
			#Need to also copy the data to the main TMPDIR dir as there are some weird cd problems with the script.
			if [[ ! -e ${data_dir}/${subjName}/${subjName}_${ss}_T2w_nlinMoCo_res-iso.3_N4corrected_brain_template0.nii.gz ]]; then
				cd $TMPDIR/${subjName}
				echo $PWD
				cp $TMPDIR/${subjName}/${subjName}_${ss}_T2w_run-*_res-iso.3_N4corrected_norm_brain_preproc.nii.gz $TMPDIR
				if [[ ! -e $TMPDIR/${subjName}_${ss}_T2w_run-*_res-iso.3_N4corrected_norm_brain_preproc.nii.gz ]]; then
					cp ${data_dir}/${subjName}/${subjName}_${ss}_T2w_run-*_res-iso.3_N4corrected_norm_brain_preproc.nii.gz $TMPDIR
				fi
				${singularity} antsMultivariateTemplateConstruction.sh -d '3' -b '0' -i '2' -k '1' -t SyN -m '50x80x20' -s CC -t GR -n '0' -r '0' -g '0.2' -c '2' -j '12' -o ${subjName}_${ss}_T2w_nlinMoCo_res-iso.3_N4corrected_brain_ /TMPDIR/${subjName}_${ss}_T2w_run-1_res-iso.3_N4corrected_norm_brain_preproc.nii.gz /TMPDIR/${subjName}_${ss}_T2w_run-2_res-iso.3_N4corrected_norm_brain_preproc.nii.gz /TMPDIR/${subjName}_${ss}_T2w_run-3_res-iso.3_N4corrected_norm_brain_preproc.nii.gz

				if [[ ! -e $TMPDIR/${subjName}_${ss}_T2w_nlinMoCo_res-iso.3_N4corrected_brain_template0.nii.gz ]]; then
					echo "${subjName}_${ss} T2w failed NlinMoCo " >>${data_dir}/preprocessing_error_log.txt
				fi
				$singularity DenoiseImage -d 3 -n Rician -i /TMPDIR/${subjName}_${ss}_T2w_nlinMoCo_res-iso.3_N4corrected_brain_template0.nii.gz -o ${simg_input_dir}/${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz -v
				if [[ ! -e $TMPDIR/$subjName/${subjName}_${ss}_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]]; then
					echo "${subjName}_${ss} T2w failed denoising" >>${data_dir}/preprocessing_error_log.txt
				fi
			fi
			#Denoise the T1w scans (w/ and w/o skull)
			$singularity DenoiseImage -d 3 -n Rician -i ${simg_input_dir}/${subjName}_${ss}_T1w_N4corrected_norm_brain_preproc.nii.gz -o ${simg_input_dir}/${subjName}_${ss}_T1w_N4corrected_norm_denoised_brain_preproc.nii.gz -v
			$singularity DenoiseImage -d 3 -n Rician -i ${simg_input_dir}/${subjName}_${ss}_T1w_N4corrected_norm_preproc.nii.gz -o ${simg_input_dir}/${subjName}_${ss}_T1w_N4corrected_norm_denoised_preproc.nii.gz -v
			#move back out of TMPDIR... need to delete all the crap (from RDS - the raw files are still included, need to sort this)
			chmod -R 740 $TMPDIR/
			#mkdir /RDS/Q0535/data/$subjName
			rsync -rcv $TMPDIR/${subjName} ${data_dir}/
			rm ${data_dir}/$subjName/*tsehippoTraToLongaxis_run-*.nii.gz
			rm ${data_dir}/$subjName/*T1w.nii.gz
			echo "done PP for $subjName_${ss}"
		fi
	fi
done