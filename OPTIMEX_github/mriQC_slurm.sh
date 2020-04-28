#!/bin/bash
#SBATCH --nodes=1
# OpenMP requires a single node
#SBATCH --ntasks=1
# Run a single serial task
#SBATCH --cpus-per-task=4
#SBATCH --mem=8gb
#SBATCH -e error_%A_%a.log			# Standard error
#SBATCH -o output_%A_%a.log			# Standard output
#SBATCH --job-name=mriqc			# Descriptive job name
#SBATCH --partition=wks,tesla      

SUBJECT=$1

singularity run --cleanenv --bind /30days/uqtshaw/optimex/optimex_bids/:/data --bind /30days/uqtshaw/optimex/output_dir:/out /30days/uqtshaw/optimex/mriqc_0.15.1.simg /data /out participant --participant_label $SUBJECT --n_procs 4 --mem_gb 8 --modalities T1w
