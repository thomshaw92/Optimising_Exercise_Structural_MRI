#!/bin/bash
for subjName in sub-1194JS sub-1198GS sub-1215AH sub-1128LW sub-1143DG sub-1135CD sub-1101ML sub-1110MD ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/OPTIMEX/3_ANTSLCT/antsLCT_pbs_script_3TP.pbs
done
