#!/bin/bash
#ashs_xs_data_extractionscript. Should be done local if it takes too long.
#Thomas Shaw 30/05/18 

for subjName in `cat /30days/uqtshaw/subjnames_ses-01.csv` ; do
    data_dir=/RDS/Q0535/optimex/data/derivatives/2_ashs_xs/
    #get the values
    for x in ses-01 ses-06 ses-12 ; do
	for side in left right ; do
	    echo -e '0\t0\t0\t0\t0\t0\t0\t0\t0\t0'>>$data_dir/${subjName}_${x}_ashs_xs/final/${subjName}_${side}_corr_usegray_volumes.txt_new.txt 
        #because the last line is deleted
        #re-arrange
	    awk '{for (i=1; i<=NF; i++) a[i,NR]=$i; max=(max<NF?NF:max)} END {for (i=1; i<=max; i++) {for (j=1; j<+NR; j++) printf "%s%s", a[i,j], (j==NR?RS:FS) }}' $data_dir/${subjName}_${x}_ashs_xs/final/${subjName}_${side}_corr_usegray_volumes.txt_new.txt >> $data_dir/${subjName}_${x}_ashs_xs/final/${subjName}_${side}_corr_usegray_volumes2.csv
	#cut lines
	    cut -d ' ' -f 1-44 --complement  $data_dir/${subjName}_${x}_ashs_xs/final/${subjName}_${side}_corr_usegray_volumes2.csv >> $data_dir/${subjName}_${x}_ashs_xs/final/${subjName}_${side}_corr_usegray_volumes_cut.csv 
	done
	icv=`cat $data_dir/${subjName}_${x}_ashs_xs/final/${subjName}_icv.txt`	
	right_vols=`cat $data_dir/${subjName}_${x}_ashs_xs/final/${subjName}_right_corr_usegray_volumes_cut.csv`
	left_vols=`cat $data_dir/${subjName}_${x}_ashs_xs/final/${subjName}_left_corr_usegray_volumes_cut.csv`	
	echo -e "${subjName}_${x}"'\t'"${icv}"'\t'"${right_vols}"'\t'"${left_vols}">>$data_dir/ASHS_xs_volumes.csv
    done
done
