#!/bin/bash
for subjName in `cat /30days/uqtshaw/mnd_and_healthycontrol_subjnames.csv` ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/7Tea/1_preprocessing/pp_pbs_script.pbs
done
