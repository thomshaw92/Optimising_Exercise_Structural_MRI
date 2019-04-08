#!/bin/bash
for subjName in `cat ~/scripts/OPTIMEX/subjnames_all_06.csv` ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/OPTIMEX/7_ashs/ashs_pbs_script_ses-06.pbs
done
