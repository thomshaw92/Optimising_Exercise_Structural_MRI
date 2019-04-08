#!/bin/bash
for subjName in `cat  ~/scripts/OPTIMEX/subjnames_all_06.csv` ; do
	qsub -v SUBJNAME=$subjName ~/scripts/OPTIMEX/4_long_ashs/ashs_long_pbs_script.pbs
done
