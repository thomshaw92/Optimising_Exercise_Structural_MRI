#!/bin/bash

#just for provenance, this is how i did ICV after making the ants cortical thickness measurements

#binarize the things
for x in sub-1* ; do fslmaths ${x} -bin ${x}_bin.nii.gz ; done

#ImageMath to get the total label stats
for x in *bin.nii* ; do ImageMath 3 ${x}LabelStats_bin.txt LabelStats ${x}*bin.nii.gz ; done

#concatenate the output from ImageMath
for x in *txt ; do echo `echo ${x:0:10}` ` cat ${x} | awk -F, NR==2{print } ` >> ICVs.csv; done