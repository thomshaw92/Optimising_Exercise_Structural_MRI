#!/bin/bash
for subjName in sub-1135CD ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/OPTIMEX/1_preprocessing/pp_pbs_script_ses-06.pbs
done
