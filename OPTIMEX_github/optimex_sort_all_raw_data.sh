#!/bin/bash
#untar entire directory
#requires dicomsort from bidsCoin 

base_dir="/30days/uqtshaw/optimex/raw_redos/final_checks"
optimex_dir="/30days/uqtshaw/optimex/"
cd $base_dir
for x in sub-* ; do
    cd ${base_dir}/${x}
    for ses in ses-* ; do
	cd  ${base_dir}/${x}/${ses}
	for tarfile in * ; do
	    if [ "${tarfile: -3}" == "tar" ] ; then
		tar xvf ${tarfile}
		rm ${tarfile}
	    elif
		[ "${tarfile: -6}" == "tar.gz" ] ; then
		tar xvzf ${tarfile}
		rm ${tarfile}
	    elif
		[ "${tarfile: -3}" == "zip" ] ; then
		unzip ${tarfile}
		rm ${tarfile}
	    else
		echo "${tarfile} is wrong"
		exit 1
		
	    fi
	done
	
	#sort the DICOMS out of bespoke directories and into one large directory
	mv */*/* ./
	#rm the empty directories
	rm -R -- */
	#rm any other crap
	rm *gz *tar *zip *pdf
	#use dicomsort to sort them into series directories
	dicomsort ./ -r -e .dcm
	#remove any leftover IMAs that may be repeats
	rm -f *IMA
	
    done #finish session loop
    cd ${optimex_dir}
    #run bidscoiner on that directory
    bidscoiner  ${base_dir} ./optimex_bids -p ${x} -f
    #tar the source data and move it to RDM
    tar cvzf ${base_dir}/${x}.tar.gz ${base_dir}/${x} && rm -rf ${base_dir}/${x} &
    
done
