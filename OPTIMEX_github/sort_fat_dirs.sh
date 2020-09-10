
#!/bin/bash
#simple script to sort directories.
#assumes all the files are the same organisation
#requires dicomsort from bidsCoin
#base dir is the level of all the PA folders ()

base_dir="/blah/blah/DICOM/"
out_dir="/outdir"
if [[ ! -e ${out_dir} ]] ; then mkdir -p ${out_dir} ; fi
cd $base_dir
for x in PA* ; do
    cd ${base_dir}/${x}/ST*/
    #sort the DICOMS out of their directories and into one large directory
    count=1
    for dicom in SE*/IM* ; do
        mv ${dicom} ${base_dir}/${x}/${dicom: -8}${count}.IMA
        ((count++))
    done
    cd ${base_dir}/${x}
    #rm the empty directories
    rm -rf ${base_dir}/${x}/ST*
    #rm any other crap that will annoy dicomsort
    rm *gz *tar *zip *pdf
    #use dicomsort to sort them into series directories
    dicomsort ./ -r -e .dcm
    #remove any leftover IMAs that may be repeats (be careful)
    ls *IMA >> ${x}_leftover_imas.txt
    mkdir leftovers
    if [[ -e *IMA ]] ; then mv *IMA leftovers ; fi

    ##Not sure if every ptp has this but PTP 1 did - change 004-haste_localizer_abdo_pelv_COMPOSED_-83 ${SERIESNAME} to a regex of the name of the series you want to copy
    #Beta code

    SERIESNAME="haste_localizer_abdo_pelv_COMPOSED_-83"


    subjName=`ls -d *STUDY* | awk '{print $5}'`
    mkdir ${out_dir}/sub-${subjName}
    mv *$SERIESNAME* ${out_dir}/sub-${subjName}/
    rm -r ${base_dir}/${x}

    #probably not needed but if you have run bidsmapper previous to this it should work.
    #cd ${out_dir}
    #run bidscoiner on that directory
    #bidscoiner  ${base_dir} ./bids_dir -p ${x} -f
    #tar the source data and move it to RDM
    #tar cvzf ${base_dir}/${x}.tar.gz ${base_dir}/${x} && rm -rf ${base_dir}/${x} &
done

