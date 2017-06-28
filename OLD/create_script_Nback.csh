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
	-dsets ${run}/${study}${subj}.${run}.nii.gz	\
	-copy_anat ANAT/${study}${subj}.ANAT.nii.gz		\
 	-do_block despike align tlrc  					\
	-tcat_remove_first_trs 3                        \
	-tshift_opts_ts -tpattern alt+z					\
	-volreg_align_to first							\
	-volreg_align_e2a								\
	-align_opts_aea -giant_move 					\
	-skullstrip_opts 								\
		-shrink_fac_bot_lim 0.8 					\
		-no_pushout									\
	-volreg_tlrc_warp								\
	-tlrc_base MNI_caez_N27+tlrc					\
        -mask_segment_anat yes						\
	-blur_filter -1blur_fwhm						\
	-blur_size 6 									\
   	-regress_stim_times 							\
   	${script_folder}/timing/NBACK_Figuras0back.1D 	\
	${script_folder}/timing/NBACK_Figuras1back.1D 	\
	${script_folder}/timing/NBACK_Letras0back.1D 	\
	${script_folder}/timing/NBACK_Letras1back.1D 	\
	${script_folder}/timing/NBACK_avisos.1D 		\
	${script_folder}/timing/NBACK_Baseline.1D 		\
   	-regress_stim_labels Figuras0back Figuras1back Letras0back Letras1back avisos Baseline \
	-regress_basis_multi						\
'BLOCK(2.0,1)' 'BLOCK(2.0,1)' 'BLOCK(2.0,1)' 'BLOCK(2.0,1)'	'BLOCK(5.0,1)'	'BLOCK(10.0,1)'	\
		-regress_censor_outliers 0.15              \
		-regress_opts_3dD							\
			-gltsym 'SYM: +Figuras0back -Baseline'		\
 			-glt_label 1 Figuras0back_vs_Baseline		\
			-gltsym 'SYM: +Figuras1back -Baseline'		\
 			-glt_label 2 Figuras1back_vs_Baseline		\
			-gltsym 'SYM: +Letras0back -Baseline'		\
 			-glt_label 3 Letras0back_vs_Baseline		\
			-gltsym 'SYM: +Letras1back -Baseline'		\
 			-glt_label 4 Letras1back_vs_Baseline		\
			-gltsym 'SYM: +0.5*Figuras1back +0.5*Letras1back -0.5*Figuras0back -0.5*Letras0back' \
 			-glt_label 5 1back_vs_0back				\
		-jobs 6										\
		-local_times 								\
        -regress_est_blur_epits						\
	    -regress_est_blur_errts						\
		-regress_apply_mot_types demean				\
		-regress_run_clustsim yes


exit
#### old script


afni_proc.py \
	-subj_id ${study}${subj}                        \
	-script proc.${study}${subj}.${run}.tcsh 		\
	-out_dir PROC.${run} 							\
	-dsets ${run}/${study}${subj}.${run}.nii.gz	\
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
   	${script_folder}/timing/NBACK_Figuras0back.1D 	\
	${script_folder}/timing/NBACK_Figuras1back.1D 	\
	${script_folder}/timing/NBACK_Letras0back.1D 	\
	${script_folder}/timing/NBACK_Letras1back.1D 	\
	${script_folder}/timing/NBACK_avisos.1D 		\
	${script_folder}/timing/NBACK_Baseline.1D 		\
   	-regress_stim_labels Figuras0back Figuras1back Letras0back Letras1back avisos Baseline \
	-regress_basis_multi						\
'BLOCK(2.0,1)' 'BLOCK(2.0,1)' 'BLOCK(2.0,1)' 'BLOCK(2.0,1)'	'BLOCK(5.0,1)'	'BLOCK(10.0,1)'	\
		-regress_opts_3dD							\
			-gltsym 'SYM: +Figuras0back -Baseline'		\
 			-glt_label 1 Figuras0back_vs_Baseline		\
			-gltsym 'SYM: +Figuras1back -Baseline'		\
 			-glt_label 2 Figuras1back_vs_Baseline		\
			-gltsym 'SYM: +Letras0back -Baseline'	\
 			-glt_label 3 Letras0back_vs_Baseline		\
			-gltsym 'SYM: +Letras1back -Baseline'		\
 			-glt_label 4 Letras1back_vs_Baseline		\
		-jobs 6										\
		-local_times 								\
        -regress_est_blur_epits						\
	    -regress_est_blur_errts						\
		-regress_apply_mot_types demean				\
		-regress_run_clustsim yes

exit



