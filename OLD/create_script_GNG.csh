#! /bin/csh


# This is the script to create preprocessing scripts for the 
# frases nonsense paradigm


set subj = $1
set script_folder = $2
set run = $3
set study = $4


# Get out of the SCRIPTS folder
#cd ..
#cd ${study}${subj}


afni_proc.py \
	-subj_id ${study}${subj}                        \
	-script proc.${study}${subj}.${run}.tcsh 		\
	-out_dir PROC.${run} 							\
	-dsets ${run}/${study}${subj}.${run}.nii.gz	    \
	-copy_anat ANAT/${study}${subj}.ANAT.nii.gz		\
 	-do_block despike align tlrc  					\
	-tcat_remove_first_trs 3                        \
	-tshift_opts_ts -tpattern alt+z					\
	-volreg_align_to first							\
	-volreg_align_e2a								\
	-align_opts_aea -giant_move 					\
	-volreg_tlrc_warp								\
	-align_opts_aea -skullstrip_opts 				\
		-shrink_fac_bot_lim 0.8 					\
		-no_pushout									\
	-tlrc_base MNI_caez_N27+tlrc					\
        -mask_segment_anat yes						\
	-blur_filter -1blur_fwhm						\
	-blur_size 6 									\
   	-regress_stim_times 							\
   		${script_folder}/timing/GNG_leftgreen.1D 	\
		${script_folder}/timing/GNG_rightgreen.1D	\
		${script_folder}/timing/GNG_circlegreen.1D	\
		-regress_stim_labels LeftGreen  RightGreen CircleGreen \
		-regress_basis_multi						\
		'BLOCK(1.5,1)' 'BLOCK(1.5,1)' 'BLOCK(1.5,1)' \
		-regress_opts_3dD							\
			-gltsym 'SYM: +0.5*LeftGreen +0.5*RightGreen  -1.0*CircleGreen '		\
 			-glt_label 1 Cong_vs_InCong				\
			-jobs 6										\
			-local_times 								\
			-regress_censor_outliers 0.15              \
        	-regress_est_blur_epits						\
	    	-regress_est_blur_errts						\
			-regress_apply_mot_types demean				\
			-regress_run_clustsim yes



exit

# 22/11/2014
# old script below. I removed the baseline condition

afni_proc.py \
	-subj_id ${study}${subj}                        \
	-script proc.${study}${subj}.${run}.tcsh 		\
	-out_dir PROC.${run} 							\
	-dsets ${run}/${study}${subj}.${run}.nii.gz	    \
	-copy_anat ANAT/${study}${subj}.ANAT.nii.gz		\
 	-do_block despike align tlrc  					\
	-tcat_remove_first_trs 3                        \
	-tshift_opts_ts -tpattern alt+z					\
	-volreg_align_to first							\
	-volreg_align_e2a								\
	-align_opts_aea -giant_move 					\
	-volreg_tlrc_warp								\
	-align_opts_aea -skullstrip_opts 				\
		-shrink_fac_bot_lim 0.8 					\
		-no_pushout									\
	-tlrc_base MNI_caez_N27+tlrc					\
        -mask_segment_anat yes						\
	-blur_filter -1blur_fwhm						\
	-blur_size 6 									\
   	-regress_stim_times 							\
   		${script_folder}/timing/GNG_leftgreen.1D 	\
		${script_folder}/timing/GNG_rightgreen.1D	\
		${script_folder}/timing/GNG_circlegreen.1D	\
		-regress_stim_labels LeftGreen RightGreen CircleGreen  \
		-regress_basis_multi						\
		'BLOCK(1.5,1)' 'BLOCK(1.5,1)' 'BLOCK(1.5,1)'  \
		-regress_opts_3dD							\
		-jobs 6										\
		-local_times 								\
        -regress_est_blur_epits						\
	    -regress_est_blur_errts						\
		-regress_apply_mot_types demean				\
		-regress_run_clustsim yes

exit



