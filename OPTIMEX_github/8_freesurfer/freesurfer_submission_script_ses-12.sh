#!/bin/bash
for subjName in `cat /30days/$USER/subjnames_ses-12.csv` ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/OPTIMEX/8_freesurfer/freesurfer_pbs_script_ses-12.pbs
done
