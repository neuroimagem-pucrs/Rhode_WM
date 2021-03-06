#! /bin/csh

# In this script we will loop through the subjects 


set script_loc = `pwd`
set study = RWM
set subjs = ( 002 )

set run = Nback

set visit = visit1


foreach subj (${subjs})
	cd ${script_loc}
	
	# Now get into the subjects folder
	cd ..
	cd ${study}${subj}
	cd ${visit}
	
	# run the script to create the preprocessing script
	csh ${script_loc}/create_script_${run}.csh_002 ${subj} ${script_loc} ${run} ${study}

	
	
	# Now actually preprocess the subject
	tcsh -xef proc.${study}${subj}.${run}.tcsh |& tee output.proc.${study}${subj}.${run}.tcsh
	
end



