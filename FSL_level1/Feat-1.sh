#!/bin/sh

#  locate the template file

echo Locate template file
templateFile="/home/bcheung/socialContext_MVPA/level-1/template/sub-40_run-1_MVPA.fsf"

#  allow access to read and write the template
chmod 777 $templateFile

echo
echo

#  loop through each subject

#  set subIDs as a sequence of 01 02 03 ... 46
for subNum in {01..42}
do
  echo Start with sub $subNum
  #  create a folder for each subject under ~/traitNetwork_MVPA/level-1/model
  mkdir /home/bcheung/socialContext_MVPA/level-1/model/sub-"$subNum"
  #  create a folder called design under each subject folder
  mkdir /home/bcheung/socialContext_MVPA/level-1/model/sub-"$subNum"/design
  #  set output directory for the .fsf file
  outputDir="/home/bcheung/socialContext_MVPA/level-1/model/sub-"$subNum"/design"
  echo

  # loop through each run within each subject
  for runNum in {1..4}
  do
    echo Start with run $runNum
    echo
    echo "delete existing file"
    #  locate the existing file
    previousFile="/home/bcheung/socialContext_MVPA/level-1/model/sub-"$subNum"_run-"$runNum"_MVPA.feat"

    #  delete the file
    rm -r $previousFile
    echo "delete""$previousFile"

    echo "modify the design file"

    #  replace the string in the template file with new subject number and run number to generate a new design file for each run
    #  find the file name for bold data for this specific run
    oldBold="sub-40_task-friend_run-1_space-MNI152NLin2009cAsym_desc-preproc_bold"
    newBold=$(find /home/bcheung/socialContext_BIDS/derivatives/fmriprep/sub-"$subNum"/func/ -type f -name "*run-"$runNum"_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz" -exec basename {} .nii.gz ';')
    sed -e 's:'$oldBold':'$newBold':g' -e 's:sub-40:sub-'$subNum':g' -e 's:run-1:run-'$runNum':g' -e 's:/Users/BerniceCheung/Desktop:/home/bcheung:g'  <"$templateFile"> "$outputDir"/sub-"$subNum"_run-"$runNum"_MVPA.fsf

    echo
    echo "run FEAT level 1"

    #  feed the design file to FEAT to run level-1 process
    feat "$outputDir"/sub-"$subNum"_run-"$runNum"_MVPA.fsf
  done

done
