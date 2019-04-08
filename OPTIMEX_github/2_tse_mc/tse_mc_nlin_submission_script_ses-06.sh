#!/bin/bash
for subjName in sub-1194JS sub-1198GS sub-1215AH sub-1135CD sub-1128LW ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/OPTIMEX/2_tse_mc/tse_mc_nlin_pbs_script_ses-06.pbs
done
