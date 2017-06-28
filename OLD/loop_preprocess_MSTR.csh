#! /bin/csh

# In this script we will loop through the subjects 
# and process the Historinhas pardigme Version 2


set script_loc = `pwd`
set study = RWM
#set subjs = ( 003 004 005)
set subjs = ( 004)


set run = MSTR

set visit = visit1


foreach subj (${subjs})
	cd ${script_loc}
	
	# Now get into the subjects folder
	cd ..
	cd ${study}${subj}
	cd ${visit}
	
	# run the script to create the preprocessing script
	csh ${script_loc}/create_script_${run}.csh ${subj} ${script_loc} ${run} ${study}

	
	# Now actually preprocess the subject
	tcsh -xef proc.${study}${subj}.${run}.tcsh |& tee output.proc.${study}${subj}.${run}.tcsh
	
end



