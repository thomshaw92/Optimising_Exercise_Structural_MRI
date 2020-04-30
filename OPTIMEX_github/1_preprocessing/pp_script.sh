#!/bin/bash
#Thomas Shaw 5/4/18 
#skull strip t1/tse, bias correct, normalise, interpolate, then prepare for nlin MC (different script)
#remove all tse_mean stuff - unnecesary
subjName=$1
source ~/.bashrc
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=4
export NSLOTS=4
echo $TMPDIR
raw_data_dir=/30days/${USER}/optimex/bids
data_dir=/30days/$USER/optimex
for ss in ses-01 ses-02 ses-03 ses-04 ; do
    if [[ -d ${raw_data_dir}/${subjName}/${ss} ]] ; then
	cp -r $raw_data_dir/${subjName}/${ss}/anat $TMPDIR
	chmod -R 740 $TMPDIR/anat
	mkdir -p $TMPDIR/derivatives/preprocessing/$subjName
	chmod -R 740 $TMPDIR/derivatives
	rsync -v $TMPDIR/anat/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-1_T2w.nii.gz $TMPDIR/derivatives/preprocessing/$subjName
	rsync -v $TMPDIR/anat/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-2_T2w.nii.gz $TMPDIR/derivatives/preprocessing/$subjName
	rsync -v $TMPDIR/anat/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-3_T2w.nii.gz $TMPDIR/derivatives/preprocessing/$subjName
	rsync -v $TMPDIR/anat/${subjName}_${ss}_acq-mp2ragewip900075iso7TUNIDEN_run-1_T1w.nii.gz $TMPDIR/derivatives/preprocessing/$subjName
	module load singularity/2.5.1
	singularity="singularity exec --bind $TMPDIR:/TMPDIR --pwd /TMPDIR/ $data_dir/ants_fsl_robex_20180524.simg"
	bidsdir=/TMPDIR
	t1w=$bidsdir/derivatives/preprocessing/$subjName/${subjName}_${ss}_acq-mp2ragewip900075iso7TUNIDEN_run-1_T1w.nii.gz
	tse1=$bidsdir/derivatives/preprocessing/$subjName/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-1_T2w.nii.gz
	tse2=$bidsdir/derivatives/preprocessing/$subjName/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-2_T2w.nii.gz
	tse3=$bidsdir/derivatives/preprocessing/$subjName/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-3_T2w.nii.gz
	deriv=$bidsdir/derivatives
	if [[ ! e ${t1w} ]] ; then
		echo "Missing T1w for ${subjName}_${ss}" >> ${data_dir}/preprocessing_error_log.txt
	fi
	if [[ ! e ${tse1} ]] ; then
                echo "Missing tse1 for ${subjName}_${ss}" >> ${data_dir}/preprocessing_error_log.txt
        fi
	if [[ ! e ${tse2} ]] ; then
                echo "Missing tse2 for ${subjName}_${ss}" >> ${data_dir}/preprocessing_error_log.txt
        fi
	if [[ ! e ${tse3} ]] ; then
                echo "Missing tse3 for ${subjName}_${ss}" >> ${data_dir}/preprocessing_error_log.txt
        fi

	mkdir -p $data_dir/derivatives/preprocessing/${subjName}

	#initial skull strip
	$singularity runROBEX.sh $t1w $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_brain_preproc.nii.gz $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_brainmask.nii.gz
	#bias correct t1
	$singularity N4BiasFieldCorrection -d 3 -b [1x1x1,3] -c '[50x50x40x30,0.00000001]' -i $t1w -x $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_brainmask.nii.gz -r 1 -o $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_N4corrected_preproc.nii.gz --verbose 1 -s 2
	if [[ ! -e $TMPDIR/derivatives/preprocessing/$subjName/${subjName}_${ss}_T1w_N4corrected_preproc.nii.gz ]] ; then
	    $singularity antsApplyTransforms -d 3 -i $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_brainmask.nii.gz -r ${t1w} -n LanczosWindowedSinc -o $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_brainmask.nii.gz
	    $singularity N4BiasFieldCorrection -d 3 -b [1x1x1,3] -c '[50x50x40x30,0.00000001]' -i $t1w -x $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_brainmask.nii.gz -r 1 -o $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_N4corrected_preproc.nii.gz --verbose 1 -s 2
	fi
	#rescale t1
	t1bc=$deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_N4corrected_preproc.nii.gz
	$singularity ImageMath 3 $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_N4corrected_norm_preproc.nii.gz RescaleImage $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_N4corrected_preproc.nii.gz 0 1000
	#skull strip new Bias corrected T1
	$singularity runROBEX.sh $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_N4corrected_norm_preproc.nii.gz $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_N4corrected_norm_brain_preproc.nii.gz $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_brainmask.nii.gz
	#remove things
#	rm $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_N4corrected_norm_preproc.nii.gz
	rm $TMPDIR/derivatives/preprocessing/$subjName/${subjName}_${ss}_T1w_brain_preproc.nii.gz
	rm $TMPDIR/derivatives/preprocessing/$subjName/${subjName}_${ss}_T1w_N4corrected_preproc.nii.gz
	rm $TMPDIR/derivatives/preprocessing/$subjName/${subjName}_${ss}_T1w_N4corrected_preproc.nii.gz

	######TSE#####
	#apply mask to tse - resample like tse - this is just for BC
	$singularity  antsApplyTransforms -d 3 -i $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_brainmask.nii.gz -r $tse1 -n NearestNeighbor -o $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-1_brainmask.nii.gz
	 $singularity  antsApplyTransforms -d 3 -i $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_brainmask.nii.gz -r $tse2 -n NearestNeighbor -o $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-2_brainmask.nii.gz
	 $singularity  antsApplyTransforms -d 3 -i $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_brainmask.nii.gz -r $tse3 -n NearestNeighbor -o $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-3_brainmask.nii.gz

	#Bias correction - use mask created - 
	for x in "1" "2" "3" ; do
	    
	    #N4
	    $singularity N4BiasFieldCorrection -d 3 -b [1x1x1,3] -c '[50x50x40x30,0.00000001]' -i $bidsdir/derivatives/preprocessing/$subjName/${subjName}_${ss}_acq-tsehippoTraToLongaxis_run-${x}_T2w.nii.gz -x $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_brainmask.nii.gz -r 1 -o $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_N4corrected_preproc.nii.gz --verbose 1 -s 2 
	    if [[ ! -e $TMPDIR/derivatives/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_N4corrected_preproc.nii.gz ]] ; then
		echo "TSE run ${x} did not bias correct for ${subjName}_${ss} " >> ${data_dir}/preprocessing_error_log.txt
            fi		
	    #normalise intensities of the BC'd tses
	    $singularity ImageMath 3 $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_N4corrected_norm_preproc.nii.gz RescaleImage $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_N4corrected_preproc.nii.gz 0 1000 

	    #interpolation of TSEs -bring all into the same space while minimising interpolation write steps.
	    $singularity flirt -v -applyisoxfm 0.3 -interp sinc -sincwidth 8 -in $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_N4corrected_norm_preproc.nii.gz -ref $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_N4corrected_norm_preproc.nii.gz -out $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_res-iso.3_N4corrected_norm_preproc.nii.gz

	    #create new brainmask and brain images. 
	$singularity  antsApplyTransforms -d 3 -i $deriv/preprocessing/$subjName/${subjName}_${ss}_T1w_brainmask.nii.gz -r $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_res-iso.3_N4corrected_norm_preproc.nii.gz -n NearestNeighbor -o $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_brainmask.nii.gz
	    rm $TMPDIR/derivatives/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_N4corrected_norm_preproc.nii.gz 
	
	done


	for x in "1" "2" "3" ; do
	    #mask the preprocessed TSE.
	    $singularity ImageMath 3 $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_res-iso.3_N4corrected_norm_brain_preproc.nii.gz m $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_res-iso.3_N4corrected_norm_preproc.nii.gz  $deriv/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_brainmask.nii.gz

	# rm brainmasks and other crap
		chmod -R 744 $TMPDIR/
		rm $TMPDIR/derivatives/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_brainmask.nii.gz
		rm $TMPDIR/derivatives/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_N4corrected_norm_preproc.nii.gz
		rm $TMPDIR/derivatives/preprocessing/$subjName/${subjName}_${ss}_T2w_run-${x}_N4corrected_preproc.nii.gz
	done

	#move back out of TMPDIR... need to delete all the crap (from RDS - the raw files are still included, need to sort this)
	cd $TMPDIR/derivatives/preprocessing/
	chmod -R 740 $TMPDIR/derivatives/preprocessing
	mkdir /RDS/Q0535/data/derivatives/preprocessing/$subjName
	rsync -c -v -r ./${subjName}/* ${data_dir}/derivatives/preprocessing/$subjName
	rm  ${data_dir}/derivatives/preprocessing/$subjName/*_N4corrected_preproc.nii.gz
	rm  ${data_dir}/derivatives/preprocessing/$subjName/*_tse.nii.gz
	rm  ${data_dir}/derivatives/preprocessing/$subjName/*T1w.nii.gz
	echo "done PP for $subjName_${ss}"
    fi
done
