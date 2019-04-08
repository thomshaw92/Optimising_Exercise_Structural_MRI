#!/bin/bash
for subjName in `cat /data/fasttemp/uqtshaw/optimising_exercise/scripts/subjnames_06_optimex.csv` ; do 
    sbatch --export=SUBJNAME=$subjName /data/fasttemp/uqtshaw/optimising_exercise/scripts/3_ANTSLCT/antsLCT_pbs_script_2TP_slurm.sh
done
