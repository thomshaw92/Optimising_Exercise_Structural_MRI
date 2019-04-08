#!/bin/bash
for subjName in sub-1049AO sub-1027RO sub-1100LJ sub-1102RC sub-1047JM  sub-1054MR sub-1069BG sub-1072JM sub-1101ML sub-1110MD ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/OPTIMEX/2_tse_mc/tse_mc_nlin_pbs_script_ses-12.pbs
done
