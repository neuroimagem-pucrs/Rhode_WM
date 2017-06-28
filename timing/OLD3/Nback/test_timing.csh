#! /bin/csh

#  Here we will test the timing of the acerta kits
# Evaluate the experimental design


3dDeconvolve -nodata 291 2.0 					                        \
-concat '1D: 0' \
-polort 2 \
-x1D_stop \
    -num_stimts 6                                                       \
    -stim_times 1 N_0.txt  'BLOCK(1,1)'              \
    -stim_label 1 N_0                                                  \
    -stim_times 2 N_1.txt 'BLOCK(1,1)'            \
    -stim_label 2 N_1                                                \
    -stim_times 3 N_2.txt  'BLOCK(1,1)'            \
    -stim_label 3 N_2                                                \
    -stim_times 4 N_3.txt   'BLOCK(1,1)'             \
    -stim_label 4 N_3                                                 \
    -stim_times 5 key.txt   'BLOCK(1,1)'             \
    -stim_label 5 key                                                  \
    -stim_times 6 baseline.txt 'BLOCK(10,1)'             \
    -stim_label 6 baseline                                                  \
    -jobs 6                                                             \
    -x1D stdout
    
    #: | 1dplot -stdin -one -thick  


#3dDeconvolve \

