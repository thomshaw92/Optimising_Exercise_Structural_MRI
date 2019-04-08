#!/bin/bash
#SBATCH --job-name=optimex-tse_nlin
#SBATCH -N 1
#nodes 
#SBATCH -n 1             
#Number of Tasks :2
#SBATCH -c 16 
# 4 CPU allocation per Task
#SBATCH --partition=all
# Name of the Slurm partition used
#SBATCH --mem=31000
#SBATCH -o slurm.%N.%j.out 
#SBATCH -e slurm.%N.%j.error  
/data/fasttemp/uqtshaw/optimising_exercise/scripts/2_tse_mc/tse_mc_script_slurm.sh $SUBJNAME
