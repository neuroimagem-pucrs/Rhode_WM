#! /bin/sh


### In this script we will read the dicom files and convert them to NII. In the process we will also create the 
### subject folders as well as putting th nii files in the correct location. 
### Note, this script assumes that the subject folder exists, and inside it there is a "dicom" folder in it with the 
### dicom files in it
### 
### Author: Alexandre Franco
### Dez 18, 2014

### SOMENTE EDITAR ESTA PARTE PARA CADA SUJEITO@@@@@


set study = RWM   # Rhode Working Memory
set subj = 023
set visit = visit1 
# Runs
set anat = 003
set GNG = 004
set SAT = 007
set Nback = 009
set rst = 008



###########################@@@@@@@@@@@@@@@@@@@@
  
# get out of script folder
cd ..

# go inside subject folder
cd ${study}${subj}
cd ${visit}

# convert dicom images to nii
set subj_folder = `pwd`

if (0) then
dcm2nii -c -g -o ${subj_folder} dicom/*
#exit
endif 


##########################################################
# T1 - Anatomical 
set image = ANAT
set number = ${anat}
mkdir ${image}
cd ${image}
mv ../2*s${number}*.nii.gz ${study}${subj}.${image}.nii.gz
cd $subj_folder


##########################################################
# Go-no-go
set image = GNG
set number = ${GNG}
mkdir ${image}
cd ${image}
mv ../2*s${number}*.nii.gz ${study}${subj}.${image}.nii.gz
cd $subj_folder



##########################################################
# MSTR
set image = SAT
set number = ${SAT}
mkdir ${image}
cd ${image}
mv ../2*s${number}*.nii.gz ${study}${subj}.${image}.nii.gz
cd $subj_folder




##########################################################
# N-back
set image = Nback
set number = ${Nback}
mkdir ${image}
cd ${image}
mv ../2*s${number}*.nii.gz ${study}${subj}.${image}.nii.gz
cd $subj_folder




##########################################################
# Resting state
set image = RST
set number = ${rst}
mkdir ${image}
cd ${image}
mv ../2*s${number}*.nii.gz ${study}${subj}.${image}.nii.gz
cd $subj_folder




# remove the rest of the junk that comes from dcm2nii
rm -v *nii.gz

# Now we can compact the dicom folder
tar -zcvf dicom.tar.gz dicom

# Now we can delete the original dicom folder
rm -rfv dicom/


cd $subj_folder






exit


