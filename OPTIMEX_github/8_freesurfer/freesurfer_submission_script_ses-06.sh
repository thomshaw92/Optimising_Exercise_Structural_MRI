#!/bin/bash
github_dir=~/scripts/Optimising_Exercise_Structural_MRI/OPTIMEX_github/
for subjName in  sub-1126HR sub-1132WG sub-1133ES sub-1137HW sub-1156ID sub-1209DG sub-1213IS ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/Optimising_Exercise_Structural_MRI/OPTIMEX_github/8_freesurfer/freesurfer_pbs_script_ses-06.pbs
done