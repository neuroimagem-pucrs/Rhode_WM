#!/bin/tcsh -xef

echo "rerunning the analysis with the correct timing of contrast"
echo "execution started: `date`"


# execute via : 
#   tcsh -xef proc.RWM020.Nback.tcsh |& tee output.proc.RWM020.Nback.tcsh

# =========================== auto block: setup ============================
# script setup

# take note of the AFNI version
afni -ver

# check that the current AFNI version is recent enough
afni_history -check_date 23 Sep 2016
if ( $status ) then
    echo "** this script requires newer AFNI binaries (than 23 Sep 2016)"
    echo "   (consider: @update.afni.binaries -defaults)"
    exit
endif

# the user may specify a single subject to run with
if ( $#argv > 0 ) then
    set subj = $argv[1]
    set visit = $argv[2]
else
	echo "to run preprocessing:"
	echo "tcsh proc.REDO.Nback.tcsh RWM### visit#"
	exit
endif


cd ../
cd ${subj}/${visit}


# assign output directory name
set output_dir = PROC.Nback


# set list of runs
set runs = (`count -digits 2 1 1`)

# create results and stimuli directories
#mkdir $output_dir
#mkdir $output_dir/stimuli

# copy stim files into stimulus directory
cp /media/DATA/ROHDE_WM/SCRIPTS/timing/Nback/N_0.1D  \
    /media/DATA/ROHDE_WM/SCRIPTS/timing/Nback/N_1.1D \
    /media/DATA/ROHDE_WM/SCRIPTS/timing/Nback/N_2.1D \
    /media/DATA/ROHDE_WM/SCRIPTS/timing/Nback/N_3.1D \
    /media/DATA/ROHDE_WM/SCRIPTS/timing/Nback/key.1D $output_dir/stimuli


# and make note of repetitions (TRs) per run
set tr_counts = ( 296 )

# -------------------------------------------------------
# enter the results directory (can begin processing data)
cd $output_dir


# ================================ Doing some cleaning up =================================
rm -v ideal*
rm -v errts*
rm -v stats*
rm -v fitts*
rm -v X.*
rm -v TSNR*
rm -v gmean.errts.unit.1D
rm -v out.cormat_warn*
rm -v out.gcor.1D
rm -v corr_brain*
rm -v blur*1D
rm -rfv files_ACF*
rm -rfv files_ClustSim*

# ================================ regress =================================

# compute de-meaned motion parameters (for use in regression)
#1d_tool.py -infile dfile_rall.1D -set_nruns 1                            \
#           -demean -write motion_demean.1D

# compute motion parameter derivatives (just to have)
#1d_tool.py -infile dfile_rall.1D -set_nruns 1                            \
#           -derivative -demean -write motion_deriv.1D

# note TRs that were not censored
set ktrs = `1d_tool.py -infile outcount_${subj}_censor.1D                \
                       -show_trs_uncensored encoded`

# ------------------------------
# run the regression analysis
3dDeconvolve -input pb05.$subj.r*.scale+tlrc.HEAD                        \
    -censor outcount_${subj}_censor.1D                                   \
    -polort 4                                                            \
    -num_stimts 11                                                       \
    -stim_times 1 stimuli/N_0.1D 'BLOCK(1.0,1)'                          \
    -stim_label 1 N_0                                                    \
    -stim_times 2 stimuli/N_1.1D 'BLOCK(1.0,1)'                          \
    -stim_label 2 N_1                                                    \
    -stim_times 3 stimuli/N_2.1D 'BLOCK(1.0,1)'                          \
    -stim_label 3 N_2                                                    \
    -stim_times 4 stimuli/N_3.1D 'BLOCK(1.0,1)'                          \
    -stim_label 4 N_3                                                    \
    -stim_times 5 stimuli/key.1D 'BLOCK(3.0,1)'                          \
    -stim_label 5 key                                                    \
    -stim_file 6 motion_demean.1D'[0]' -stim_base 6 -stim_label 6 roll   \
    -stim_file 7 motion_demean.1D'[1]' -stim_base 7 -stim_label 7 pitch  \
    -stim_file 8 motion_demean.1D'[2]' -stim_base 8 -stim_label 8 yaw    \
    -stim_file 9 motion_demean.1D'[3]' -stim_base 9 -stim_label 9 dS     \
    -stim_file 10 motion_demean.1D'[4]' -stim_base 10 -stim_label 10 dL  \
    -stim_file 11 motion_demean.1D'[5]' -stim_base 11 -stim_label 11 dP  \
    -num_glt 3                                                           \
    -gltsym 'SYM: +N_3 -N_0 '                                            \
    -glt_label 1 N_3_vs_N_0                                              \
    -gltsym 'SYM: +N_2 -N_0 '                                            \
    -glt_label 2 N_2_vs_N_0                                              \
    -gltsym 'SYM: +N_1 -N_0 '                                            \
    -glt_label 3 N_1_vs_N_0                                              \
    -jobs 6                                                              \
    -local_times                                                         \
    -fout -tout -x1D X.xmat.1D -xjpeg X.jpg                              \
    -x1D_uncensored X.nocensor.xmat.1D                                   \
    -fitts fitts.$subj                                                   \
    -errts errts.${subj}                                                 \
    -bucket stats.$subj


# if 3dDeconvolve fails, terminate the script
if ( $status != 0 ) then
    echo '---------------------------------------'
    echo '** 3dDeconvolve error, failing...'
    echo '   (consider the file 3dDeconvolve.err)'
    exit
endif


# display any large pairwise correlations from the X-matrix
1d_tool.py -show_cormat_warnings -infile X.xmat.1D |& tee out.cormat_warn.txt

# create an all_runs dataset to match the fitts, errts, etc.
#3dTcat -prefix all_runs.$subj pb05.$subj.r*.scale+tlrc.HEAD

# --------------------------------------------------
# create a temporal signal to noise ratio dataset 
#    signal: if 'scale' block, mean should be 100
#    noise : compute standard deviation of errts
3dTstat -mean -prefix rm.signal.all all_runs.$subj+tlrc"[$ktrs]"
3dTstat -stdev -prefix rm.noise.all errts.${subj}+tlrc"[$ktrs]"
3dcalc -a rm.signal.all+tlrc                                             \
       -b rm.noise.all+tlrc                                              \
       -c full_mask.$subj+tlrc                                           \
       -expr 'c*a/b' -prefix TSNR.$subj 


# ---------------------------------------------------
# compute and store GCOR (global correlation average)
# (sum of squares of global mean of unit errts)
3dTnorm -norm2 -prefix rm.errts.unit errts.${subj}+tlrc
3dmaskave -quiet -mask full_mask.$subj+tlrc rm.errts.unit+tlrc           \
          > gmean.errts.unit.1D
3dTstat -sos -prefix - gmean.errts.unit.1D\' > out.gcor.1D
echo "-- GCOR = `cat out.gcor.1D`"


# ---------------------------------------------------
# compute correlation volume
# (per voxel: average correlation across masked brain)
# (now just dot product with average unit time series)
3dcalc -a rm.errts.unit+tlrc -b gmean.errts.unit.1D -expr 'a*b' -prefix rm.DP
3dTstat -sum -prefix corr_brain rm.DP+tlrc

# create ideal files for fixed response stim types
1dcat X.nocensor.xmat.1D'[5]' > ideal_N_0.1D
1dcat X.nocensor.xmat.1D'[6]' > ideal_N_1.1D
1dcat X.nocensor.xmat.1D'[7]' > ideal_N_2.1D
1dcat X.nocensor.xmat.1D'[8]' > ideal_N_3.1D
1dcat X.nocensor.xmat.1D'[9]' > ideal_key.1D


# --------------------------------------------------------
# compute sum of non-baseline regressors from the X-matrix
# (use 1d_tool.py to get list of regressor colums)
set reg_cols = `1d_tool.py -infile X.nocensor.xmat.1D -show_indices_interest`
3dTstat -sum -prefix sum_ideal.1D X.nocensor.xmat.1D"[$reg_cols]"

# also, create a stimulus-only X-matrix, for easy review
1dcat X.nocensor.xmat.1D"[$reg_cols]" > X.stim.xmat.1D

# ============================ blur estimation =============================
# compute blur estimates
touch blur_est.$subj.1D   # start with empty file

# create directory for ACF curve files
mkdir files_ACF

# -- estimate blur for each run in epits --
touch blur.epits.1D

# restrict to uncensored TRs, per run
foreach run ( $runs )
    set trs = `1d_tool.py -infile X.xmat.1D -show_trs_uncensored encoded \
                          -show_trs_run $run`
    if ( $trs == "" ) continue
    3dFWHMx -detrend -mask full_mask.$subj+tlrc                          \
            -ACF files_ACF/out.3dFWHMx.ACF.epits.r$run.1D                \
            all_runs.$subj+tlrc"[$trs]" >> blur.epits.1D
end

# compute average FWHM blur (from every other row) and append
set blurs = ( `3dTstat -mean -prefix - blur.epits.1D'{0..$(2)}'\'` )
echo average epits FWHM blurs: $blurs
echo "$blurs   # epits FWHM blur estimates" >> blur_est.$subj.1D

# compute average ACF blur (from every other row) and append
set blurs = ( `3dTstat -mean -prefix - blur.epits.1D'{1..$(2)}'\'` )
echo average epits ACF blurs: $blurs
echo "$blurs   # epits ACF blur estimates" >> blur_est.$subj.1D

# -- estimate blur for each run in errts --
touch blur.errts.1D

# restrict to uncensored TRs, per run
foreach run ( $runs )
    set trs = `1d_tool.py -infile X.xmat.1D -show_trs_uncensored encoded \
                          -show_trs_run $run`
    if ( $trs == "" ) continue
    3dFWHMx -detrend -mask full_mask.$subj+tlrc                          \
            -ACF files_ACF/out.3dFWHMx.ACF.errts.r$run.1D                \
            errts.${subj}+tlrc"[$trs]" >> blur.errts.1D
end

# compute average FWHM blur (from every other row) and append
set blurs = ( `3dTstat -mean -prefix - blur.errts.1D'{0..$(2)}'\'` )
echo average errts FWHM blurs: $blurs
echo "$blurs   # errts FWHM blur estimates" >> blur_est.$subj.1D

# compute average ACF blur (from every other row) and append
set blurs = ( `3dTstat -mean -prefix - blur.errts.1D'{1..$(2)}'\'` )
echo average errts ACF blurs: $blurs
echo "$blurs   # errts ACF blur estimates" >> blur_est.$subj.1D


# add 3dClustSim results as attributes to any stats dset
mkdir files_ClustSim

# run Monte Carlo simulations using method 'ACF'
set params = ( `grep ACF blur_est.$subj.1D | tail -n 1` )
3dClustSim -both -mask full_mask.$subj+tlrc -acf $params[1-3]            \
           -cmd 3dClustSim.ACF.cmd -prefix files_ClustSim/ClustSim.ACF

# run 3drefit to attach 3dClustSim results to stats
set cmd = ( `cat 3dClustSim.ACF.cmd` )
$cmd stats.$subj+tlrc

# ================== auto block: generate review scripts ===================

# generate a review script for the unprocessed EPI data
gen_epi_review.py -script @epi_review.$subj \
    -dsets pb00.$subj.r*.tcat+orig.HEAD

# generate scripts to review single subject results
# (try with defaults, but do not allow bad exit status)
gen_ss_review_scripts.py -out_limit 0.15 -exit0

# ========================== auto block: finalize ==========================

# remove temporary files
\rm -fr rm.* awpy

# if the basic subject review script is here, run it
# (want this to be the last text output)
if ( -e @ss_review_basic ) ./@ss_review_basic |& tee out.ss_review.$subj.txt

# return to parent directory
cd ..

echo "execution finished: `date`"




# ==========================================================================
# script generated by the command:
#
# afni_proc.py -subj_id RWM020 -script proc.RWM020.Nback.tcsh -out_dir        \
#     PROC.Nback -dsets Nback/RWM020.Nback.nii.gz -copy_anat                  \
#     ANAT/RWM020.ANAT.nii.gz -do_block despike align tlrc                    \
#     -tcat_remove_first_trs 3 -tshift_opts_ts -tpattern alt+z                \
#     -volreg_align_to first -volreg_align_e2a -align_opts_aea -giant_move    \
#     -volreg_tlrc_warp -tlrc_base HaskinsPeds_NL_template1.0+tlrc            \
#     -tlrc_NL_warp -blur_filter -1blur_fwhm -blur_size 6 -regress_stim_times \
#     /media/DATA/ROHDE_WM/SCRIPTS/timing/Nback/N_0.1D                        \
#     /media/DATA/ROHDE_WM/SCRIPTS/timing/Nback/N_1.1D                        \
#     /media/DATA/ROHDE_WM/SCRIPTS/timing/Nback/N_2.1D                        \
#     /media/DATA/ROHDE_WM/SCRIPTS/timing/Nback/N_3.1D                        \
#     /media/DATA/ROHDE_WM/SCRIPTS/timing/Nback/key.1D -regress_stim_labels   \
#     N_0 N_1 N_2 N_3 key -regress_basis_multi 'BLOCK(1.0,1)' 'BLOCK(1.0,1)'  \
#     'BLOCK(1.0,1)' 'BLOCK(1.0,1)' 'BLOCK(3.0,1)' -regress_censor_outliers   \
#     0.15 -regress_opts_3dD -num_glt 3 -gltsym 'SYM: +N_3 -N_0 ' -glt_label  \
#     1 N_3_vs_N_0 -gltsym 'SYM: +N_2 -N_0 ' -glt_label 2 N_2_vs_N_0 -gltsym  \
#     'SYM: +N_1 -N_0 ' -glt_label 3 N_1_vs_N_0 -jobs 6 -local_times          \
#     -regress_est_blur_epits -regress_est_blur_errts                         \
#     -regress_apply_mot_types demean -regress_run_clustsim yes -execute
