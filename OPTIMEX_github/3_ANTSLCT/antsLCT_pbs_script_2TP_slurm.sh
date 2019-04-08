#!/bin/bash
#SBATCH --job-name=2_ALCT
#SBATCH -N 1
#SBATCH -n 1             
#Number of Tasks :2
#SBATCH -c 8 
#SBATCH --partition=all,long,wks
#SBATCH --mem=16000
#SBATCH -o slurm.%N.%j.out 
#SBATCH -e slurm.%N.%j.error  

/data/fasttemp/uqtshaw/optimising_exercise/scripts/3_ANTSLCT/antsLCT_script_2TP_slurm.sh $SUBJNAME

