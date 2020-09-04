#!/bin/bash
#Thomas Shaw 4/9/2020
#ants cortical thickness for ICV calc. should include something for adding up volumes? 
subjName=$1
source ~/.bashrc
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=12
export NSLOTS=12
echo $TMPDIR
raw_data_dir=/30days/${USER}/optimex/bids
data_dir=/30days/$USER/optimex
mkdir ${data_dir}/${subjName}_ACT
for ss in ses-01 ; do
    if [[ -d ${raw_data_dir}/${subjName}/${ss} ]]; then
        rsync -rv $raw_data_dir/${subjName}/${ss}/anat $TMPDIR
        mkdir -p $TMPDIR/$subjName
        chmod 744 $TMPDIR -R
        mv $TMPDIR/anat/${subjName}_${ss}_acq-*_run-1_T1w.nii.gz $TMPDIR/$subjName/${subjName}_${ss}_acq-mp2rage-UNIDEN_run-1_T1w.nii.gz
        module load singularity/2.5.1
        singularity="singularity exec --bind $TMPDIR:/TMPDIR --pwd /TMPDIR/ $data_dir/ants_fsl_robex_20180524.simg"
        t1w=/TMPDIR/${subjName}/${subjName}_${ss}_acq-mp2rage-UNIDEN_run-1_T1w.nii.gz #this isn't used
        simg_input_dir=/TMPDIR/${subjName}
        if [[ ! -e $TMPDIR/${subjName}/${subjName}_${ss}*T1w.nii.gz ]]; then
            echo "Missing T1w for ${subjName}_${ss}" >>${data_dir}/preprocessing_error_log.txt
        fi
        cp -r /30days/uqtshaw/cai63_asym_2017_nlin_TempAndPriors $TMPDIR/

        #make output dir
        mkdir -p $data_dir/${subjName}
        #initial check to see if files exist, if so, exit loop
        #run antsCT        
        echo "running ANTSCT for ${subjName}_${ss} T1w"
       
        cd $TMPDIR/$subjName
        $singularity antsCorticalThickness.sh -d 3 \
        -a ${simg_input_dir}/${subjName}_${ss}_acq-mp2rage-UNIDEN_run-1_T1w.nii.gz \
        -e /TMPDIR/cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin.nii.gz \
        -m /TMPDIR/cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin_ProbabilityMask.nii.gz \
        -p /TMPDIR/cai63_asym_2017_nlin_TempAndPriors/prior%d.nii.gz \
        -f /TMPDIR/cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin_BrainExtractionMask.nii.gz \
        -t /TMPDIR/cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin_Extracted_Brain.nii.gz \
        -o ${subjName}act
        #move back out of TMPDIR... need to delete all the crap (from RDS - the raw files are still included, need to sort this)
        chmod -R 740 $TMPDIR/
        #mkdir /RDS/Q0535/data/$subjName
        rsync -rcv $TMPDIR/${subjName} ${data_dir}/${subjName}_ACT
        rm ${data_dir}/$subjName/*T1w.nii.gz
        echo "done ACT for $subjName_${ss}"
        
    fi
done