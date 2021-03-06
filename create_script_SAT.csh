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
 
 
set subjs = (019 020 021 022 023)

set template = HaskinsPeds_NL_template1.0+tlrc

set script_folder = `pwd`
set run = SAT
set study = RWM
set visit = visit2


# Get out of the SCRIPTS folder
cd ..

set base_folder = `pwd`

foreach subj (${subjs})


cd ${base_folder}
cd ${study}${subj}
cd ${visit}



# Included  
# -init_xform AUTO_CENTER 
# for subject 002, to improve segmentation
# increased -shrink_fac_bot_lim from 0.8 to 1.2 	

afni_proc.py \
	-subj_id ${study}${subj}                        \
	-script proc.${study}${subj}.${run}.tcsh 		\
	-out_dir PROC.${run}							\
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
   		${script_folder}/timing/${run}/ISI0.5.1D.txt 	\
   		${script_folder}/timing/${run}/ISI2.1D.txt 		\
   		${script_folder}/timing/${run}/ISI5.1D.txt 		\
   		${script_folder}/timing/${run}/ISI8.1D.txt 		\
   		${script_folder}/timing/${run}/timer0.5.1D.txt 	\
   		${script_folder}/timing/${run}/timer2.1D.txt 	\
   		${script_folder}/timing/${run}/timer5.1D.txt 	\
   		${script_folder}/timing/${run}/timer8.1D.txt 	\
   	-regress_stim_labels ISI0.5 ISI2 ISI5 ISI8 timer0.5 timer2 timer5 timer8 \
   			-regress_basis_multi						\
		'BLOCK(0.5,1)' 'BLOCK(2.0,1)' 'BLOCK(5.0,1)' 'BLOCK(8.0,1)' 'BLOCK(1.0,1)' 'BLOCK(1.0,1)' 'BLOCK(1.0,1)' 'BLOCK(1.0,1)' \
			-regress_censor_outliers 0.15           \
		-regress_opts_3dD							\
		-num_glt 6 \
 	-gltsym 'SYM: +ISI2 -ISI0.5' 			\
	 	-glt_label 1 ISI2_vs_ISI0.5      	\
 	-gltsym 'SYM: +ISI5 -ISI0.5' 			\
	 	-glt_label 2 ISI5_vs_ISI0.5      	\
	-gltsym 'SYM: +ISI8 -ISI0.5' 			\
	 	-glt_label 3 ISI8_vs_ISI0.5      	\
 	-gltsym 'SYM: +timer2 -timer0.5' 			\
	 	-glt_label 4 timer2_vs_timer0.5      	\
 	-gltsym 'SYM: +timer5 -timer0.5' 			\
	 	-glt_label 5 timer5_vs_timer0.5      	\
	-gltsym 'SYM: +timer8 -timer0.5' 			\
	 	-glt_label 6 timer8_vs_timer0.5      	\
			-jobs 6										\
			-local_times 								\
        	-regress_est_blur_epits						\
	    	-regress_est_blur_errts						\
			-regress_apply_mot_types demean				\
			-regress_run_clustsim yes	\
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



