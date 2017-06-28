#! /bin/csh

#  Here we will test the timing of the acerta kits
# Evaluate the experimental design

set con = MSTR


# testing WITH baseline
3dDeconvolve -nodata 183 2.0 					                        \
	-polort 3 \
	-concat '1D: 0 ' \
	-x1D_stop \
	-local_times \
    -num_stimts 5    \
	-stim_times 1 MSTR_LeftGreen.1D 'BLOCK(1.5,1)'      \
	-stim_times 2 MSTR_LeftRed.1D 'BLOCK(1.5,1)'        \
	-stim_times 3 MSTR_RightGreen.1D 'BLOCK(1.5,1)'     \
	-stim_times 4 MSTR_RightRed.1D 'BLOCK(1.5,1)'       \
	-stim_times 5 MSTR_baseline.1D 'BLOCK(30.0,1)'       \
	-stim_label 1 LeftGreen 	\
	-stim_label 2 LeftRed 		\
	-stim_label 3 RightGreen 	\
	-stim_label 4 RightRed 	\
	-stim_label 5 Baseline 	\
    -jobs 4                \
    -x1D stdout.${con}.Wbaseline 

1d_tool.py -show_cormat_warnings -infile stdout.${con}.Wbaseline.xmat.1D
    


3dDeconvolve -nodata 183 2.0 					                        \
	-polort 3 \
	-concat '1D: 0 ' \
	-x1D_stop \
	-local_times \
    -num_stimts 4    \
	-stim_times 1 MSTR_LeftGreen.1D 'BLOCK(1.5,1)'      \
	-stim_times 2 MSTR_LeftRed.1D 'BLOCK(1.5,1)'        \
	-stim_times 3 MSTR_RightGreen.1D 'BLOCK(1.5,1)'     \
	-stim_times 4 MSTR_RightRed.1D 'BLOCK(1.5,1)'       \
	-stim_label 1 LeftGreen 	\
	-stim_label 2 LeftRed 		\
	-stim_label 3 RightGreen 	\
	-stim_label 4 RightRed 	\
    -jobs 4                \
    -x1D stdout.${con}.WObaseline 
    
 1d_tool.py -show_cormat_warnings -infile stdout.${con}.WObaseline.xmat.1D   

