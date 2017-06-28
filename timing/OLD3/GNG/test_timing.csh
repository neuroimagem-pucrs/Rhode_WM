#! /bin/csh

#  Here we will test the timing of the acerta kits
# Evaluate the experimental design


3dDeconvolve -nodata 280 2.0 					                        \
-concat '1D: 0' \
-polort 2 \
-x1D_stop \
    -num_stimts 6                                                       \
    -stim_times 1 GoRight.txt  'BLOCK(0.5,1)'              \
    -stim_label 1 GoRight                                                  \
    -stim_times 2 GoLeft.txt 'BLOCK(0.5,1)'            \
    -stim_label 2 GoLeft                                                \
    -stim_times 3 GoRightUp.txt  'BLOCK(0.5,1)'            \
    -stim_label 3 GoRightUp                                                \
    -stim_times 4 GoLeftUp.txt   'BLOCK(0.5,1)'             \
    -stim_label 4 GoLeftUp                                                  \
    -stim_times 5 NoGo.txt   'BLOCK(0.5,1)'             \
    -stim_label 5 NoGo                                                  \
    -stim_times 6 Baseline.txt 'BLOCK(30,1)'             \
    -stim_label 6 Baseline                                                  \
    -jobs 3                                                             \
    -x1D stdout
    
    #: | 1dplot -stdin -one -thick  


#3dDeconvolve \

