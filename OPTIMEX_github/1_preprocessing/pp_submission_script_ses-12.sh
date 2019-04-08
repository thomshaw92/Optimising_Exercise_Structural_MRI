#!/bin/bash
for subjName in sub-1049AO sub-1027RO  ; do
#sub-1100LJ sub-1102RC sub-1047JM  sub-1054MR sub-1069BG sub-1072JM ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/OPTIMEX/1_preprocessing/pp_pbs_script_ses-12.pbs
done
