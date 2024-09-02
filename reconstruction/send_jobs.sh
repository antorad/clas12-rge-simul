#!/bin/bash
# WARNING! : Do not move this script from this folder!

################################################################################################
########################           Checking variables          #################################
################################################################################################
input_directories_check(){
    # checking execution directories
    if [[ ! -d ${LEPTO_dir} || ! -d ${lepto2dat_dir} || ! -d ${dat2tuple_dir} || ! -d ${rec_utils_dir} ]]
    then
	echo "One of the necessary input directories does not exist."
	exit 1
    fi
}

output_directories_check(){
    # checking execution directories
    if [[ ! -d ${execution_dir} || ! -d ${out_dir_recon} || ! -d ${out_dir_lepto} ]]
    then
    echo "One of the output directories does not exist. Creating it."
    mkdir -p ${execution_dir}
    mkdir -p ${out_dir_recon}
    mkdir -p ${out_dir_lepto}
    fi
}

executables_check(){
    # checking executables existence
    if [[ ! -f ${dat2tuple_dir}/bin/dat2tuple || ! -f ${LEPTO_dir}/lepto.exe ]]
    then
	echo "One of the necessary executables does not exist."
	exit 1
    fi
}
errout_check(){
    # checking execution directories
    if [[ ! -d ${main_dir}/reconstruction/err || ! -d ${main_dir}/reconstruction/out ]]
    then
	echo "Making log out directories!"
	mkdir -p ${main_dir}/reconstruction/err
	mkdir -p ${main_dir}/reconstruction/out
    fi
}

################################################################################################
############################# Hermes-like script hehe ##########################################
################################################################################################

Njobs=100 
Njobsmax=10 #For Test:1; Max Tested: 10

################################################################################################
########################               Directories              ################################
################################################################################################

cd ..
main_dir=$(pwd)
LEPTO_dir=${main_dir}/thrown/Lepto64/bin ## CHECK THIS DIRECTORY!
execution_dir=/volatile/clas12/antorad
lepto2dat_dir=${main_dir}/thrown/lepto2dat
dat2tuple_dir=${main_dir}/thrown/dat2tuple
rec_utils_dir=${main_dir}/reconstruction/utils

out_dir_lepto=/volatile/clas12/antorad/lepto_files/gemc_test
out_dir_recon=/volatile/clas12/antorad/hipo_files/gemc_test


################################################################################################
########################               Simul Specs             #################################
################################################################################################
# Use    : Sets the number of events per job (#electrons)
# Values : This is the sweet spot between quantity and performance (500 default)
Nevents=500

# Use    : Sets the scaling of the magnetic fields (-1: full imbending; 1: full outbending)
# Values : From -1 to 1
torus=-1
solenoid=-1

# Use    : Determine ID, vertex, and set the u/d ratio in LEPTO
# Values : D2, C, Al, Cu, Sn, Pb
target=C

# Use    : Determine the beam energy to set in leptoLUND.pl
# Values : Check the beam energy on the lepto executable!
beam_energy=10.5473

################################################################################################
########################                SHOWTIME               #################################
################################################################################################
input_directories_check
executables_check
output_directories_check
errout_check

cd ${main_dir}/reconstruction
sbatch --array=1-${Njobs}%${Njobsmax} run_full_simulation.sh \
${main_dir} ${LEPTO_dir} ${execution_dir} ${lepto2dat_dir} ${dat2tuple_dir} ${rec_utils_dir} \
${out_dir_lepto} ${out_dir_recon} \
${Nevents} ${torus} ${solenoid} ${target} ${beam_energy}