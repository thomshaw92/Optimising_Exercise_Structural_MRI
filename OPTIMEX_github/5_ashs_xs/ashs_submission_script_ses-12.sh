#!/bin/bash
for subjName in `cat ~/scripts/OPTIMEX/subjnames_all_12.csv` ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/OPTIMEX/7_ashs/ashs_pbs_script_ses-12.pbs
done
