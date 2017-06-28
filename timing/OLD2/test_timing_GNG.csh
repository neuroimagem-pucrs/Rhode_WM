#! /bin/csh

#  Here we will test the timing of the acerta kits
# Evaluate the experimental design

set con = GNG
set timing = 188


# testing WITH baseline
3dDeconvolve -nodata ${timing} 2.0 					                        \
	-polort 3 \
	-concat '1D: 0 ' \
	-x1D_stop \
	-local_times \
    -num_stimts 4    \
	-stim_times 1 GNG_leftgreen.1D 'BLOCK(1.5,1)'	\
	-stim_times 2 GNG_rightgreen.1D 'BLOCK(1.5,1)' \
	-stim_times 3 GNG_circlegreen.1D 'BLOCK(1.5,1)' \
	-stim_times 4 GNG_baseline.1D	'BLOCK(30.0,1)' \
	-stim_label 1 LeftGreen  \
	-stim_label 2 RightGreen  \
	-stim_label 3 CircleGreen \
	-stim_label 4 Baseline \
    -jobs 4                \
    -x1D stdout.${con}.Wbaseline 


1d_tool.py -show_cormat_warnings -infile stdout.${con}.Wbaseline.xmat.1D



3dDeconvolve -nodata ${timing} 2.0 					                        \
	-polort 3 \
	-concat '1D: 0 ' \
	-x1D_stop \
	-local_times \
    -num_stimts 3    \
   	-stim_times 1 GNG_leftgreen.1D 'BLOCK(1.5,1)'	\
	-stim_times 2 GNG_rightgreen.1D 'BLOCK(1.5,1)' \
	-stim_times 3 GNG_circlegreen.1D 'BLOCK(1.5,1)' \
	-stim_label 1 LeftGreen  \
	-stim_label 2 RightGreen  \
	-stim_label 3 CircleGreen \
    -jobs 4                \
    -x1D stdout.${con}.WObaseline 

1d_tool.py -show_cormat_warnings -infile stdout.${con}.WObaseline.xmat.1D


