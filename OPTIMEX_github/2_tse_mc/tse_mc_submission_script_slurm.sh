#!/bin/bash
for subjName in `cat /data/fasttemp/uqtshaw/optimising_exercise/scripts/subjnames_06_optimex.csv` ; do 
    sbatch --export=SUBJNAME=$subjName /data/fasttemp/uqtshaw/optimising_exercise/scripts/2_tse_mc/tse_mc_pbs_script_slurm.sh
done
