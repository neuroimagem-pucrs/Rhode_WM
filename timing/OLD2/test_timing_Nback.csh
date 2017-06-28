#! /bin/csh

#  Here we will test the timing of the acerta kits
# Evaluate the experimental design

set con = Nback
set timing = 143


# testing WITH baseline
3dDeconvolve -nodata ${timing} 2.0	\
	-polort 2 \
	-concat '1D: 0 ' \
	-x1D_stop \
	-local_times \
    -num_stimts 6    \
	-stim_times 1 NBACK_Figuras0back.1D 'BLOCK(2.0,1)'     \
	-stim_times 2 NBACK_Figuras1back.1D 'BLOCK(2.0,1)'     \
	-stim_times 3 NBACK_Letras0back.1D 'BLOCK(2.0,1)'	     \
	-stim_times 4 NBACK_Letras1back.1D 'BLOCK(2.0,1)'	     \
	-stim_times 5 NBACK_avisos.1D 'BLOCK(5.0,1)'		      \
	-stim_times 6 NBACK_Baseline.1D 'BLOCK(10.0,1)'	      \
	-stim_label 1 Figuras0back	\
	-stim_label 2 Figuras1back	\
	-stim_label 3 Letras0back  	\
	-stim_label 4 Letras1back 	\
	-stim_label 5 avisos 	\
	-stim_label 6 Baseline 	\
    -jobs 4                \
    -x1D stdout.${con}.Wbaseline 


1d_tool.py -show_cormat_warnings -infile stdout.${con}.Wbaseline.xmat.1D


3dDeconvolve -nodata ${timing} 2.0	\
	-polort 2 \
	-concat '1D: 0 ' \
	-x1D_stop \
	-local_times \
    -num_stimts 5    \
	-stim_times 1 NBACK_Figuras0back.1D 'BLOCK(2.0,1)'     \
	-stim_times 2 NBACK_Figuras1back.1D 'BLOCK(2.0,1)'     \
	-stim_times 3 NBACK_Letras0back.1D 'BLOCK(2.0,1)'	     \
	-stim_times 4 NBACK_Letras1back.1D 'BLOCK(2.0,1)'	     \
	-stim_times 5 NBACK_avisos.1D 'BLOCK(5.0,1)'		      \
	-stim_label 1 Figuras0back	\
	-stim_label 2 Figuras1back	\
	-stim_label 3 Letras0back  	\
	-stim_label 4 Letras1back 	\
	-stim_label 5 avisos 	\
    -jobs 4                \
    -x1D stdout.${con}.WObaseline 
    
 1d_tool.py -show_cormat_warnings -infile stdout.${con}.WObaseline.xmat.1D   

