#! /bin/csh


# This is the script to create preprocessing scripts for the 
# frases nonsense paradigm

# 18/03/2015 - Retirei a opção -giant_move

# 21/08/2015 - Retirei este comando 
# Segmentação estava ruim 
#	-align_opts_aea -skullstrip_opts 		\
#		-shrink_fac_bot_lim 0.8 		\
#		-no_pushout				\
 #       -mask_segment_anat yes				\

 # 25/08/1981 - retirei isto aqui:
# 	-anat_uniform_method unifize                                 	\
 
 
#set subjs = (019 020 021 022 023)
set subjs = $1

set template = ~/ROHDE_WM/DATA/ROHDE_WM/SCRIPTS/HaskinsPeds_NL_template1.0+tlrc

set script_folder = `pwd`
set run = GNG
set study = RWM
#set visit = visit2
set visit = $2


# Get out of the SCRIPTS folder
cd ..

set base_folder = `pwd`

foreach subj (${subjs})


cd ${base_folder}
cd ${study}${subj}
cd ${visit}

afni_proc.py \
	-subj_id ${study}${subj}                        \
	-script proc.${study}${subj}.${run}.tcsh 		\
	-out_dir PROC.${run} 							\
	-dsets ${run}/${study}${subj}.${run}.nii.gz	    \
	-copy_anat ANAT/${study}${subj}.ANAT.nii.gz		\
 	-do_block despike align tlrc  			\
	-tcat_remove_first_trs 3                        \
	-tshift_opts_ts -tpattern alt+z			\
	-volreg_align_to first				\
	-volreg_align_e2a				\
	-volreg_tlrc_warp				\
	-tlrc_base ${template} 				\
	-tlrc_NL_warp						\
	-blur_filter -1blur_fwhm			\
	-blur_size 6 					\
   	-regress_stim_times 							\
   		${script_folder}/timing/GNG/GoLeft.1D 		\
		${script_folder}/timing/GNG/GoLeftUp.1D		\
   		${script_folder}/timing/GNG/GoRight.1D		\
		${script_folder}/timing/GNG/GoRightUp.1D	\
		${script_folder}/timing/GNG/NoGo.1D			\
		-regress_stim_labels GoLeft GoLeftUp GoRight GoRightUp NoGo \
		-regress_basis 'GAM'						\
			-regress_censor_outliers 0.15              		\
		-regress_opts_3dD									\
			-num_glt 3 					\
 			-gltsym 'SYM: +NoGo -0.5*GoLeftUp -0.5*GoRightUp' 			\
	 		-glt_label 1 NoGo_vs_OddBall      						\
	 		-gltsym 'SYM: +NoGo -0.5*GoLeft -0.5*GoRight' 			\
	 		-glt_label 2 NoGo_vs_Go      						\
			-gltsym 'SYM: +0.5*GoLeftUp +0.5*GoRightUp -0.5*GoLeft -0.5*GoRight' 			\
	 		-glt_label 3 OddBall_vs_Go      						\
				-jobs 6										\
			-local_times 									\
        	-regress_est_blur_epits							\
	    	-regress_est_blur_errts							\
			-regress_apply_mot_types demean					\
			-regress_run_clustsim yes     					\
			-execute

end

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
		-no_use_edge								\
	-tlrc_base MNI_caez_N27+tlrc					\
        -mask_segment_anat yes						\
	-blur_filter -1blur_fwhm						\
	-blur_size 6 									\
   	-regress_stim_times 							\
   		${script_folder}/timing/GNG_leftgreen.1D 	\
		${script_folder}/timing/GNG_rightgreen.1D	\
		${script_folder}/timing/GNG_circlegreen.1D	\
		${script_folder}/timing/GNG_baseline.1D	\
		-regress_stim_labels LeftGreen  RightGreen CircleGreen Baseline \
		-regress_basis_multi						\
		'BLOCK(1.5,1)' 'BLOCK(1.5,1)' 'BLOCK(1.5,1)' 'BLOCK(30.0,1)' \
		-regress_opts_3dD							\
			-gltsym 'SYM: +LeftGreen -Baseline'		\
 			-glt_label 1 LeftGreen_vs_Baseline		\
			-gltsym 'SYM: +RightGreen -Baseline'	\
 			-glt_label 2 RightGreen_vs_Baseline		\
			-gltsym 'SYM: +CircleGreen -Baseline'		\
 			-glt_label 3 CircleGreen_vs_Baseline		\
		-jobs 6										\
		-local_times 								\
        -regress_est_blur_epits						\
	    -regress_est_blur_errts						\
		-regress_apply_mot_types demean				\
		-regress_run_clustsim yes

exit



