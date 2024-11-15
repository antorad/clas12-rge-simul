#!/bin/bash

#SBATCH --account=clas12
#SBATCH --partition=production
#SBATCH --job-name=gemc-rec
#SBATCH --output=./out/%x.%j.array%a.out
#SBATCH --error=./err/%x.%j.array%a.err
#SBATCH --time=02:30:00
#SBATCH --mem=2G

#--output=./out/%x.%j.array%a.out
#--error=./err/%x.%j.array%a.err

# Parse the first input argument (e.g., -gsr)
# And shift to remove the first argument so the rest can be used normally

echo "This is JOB ${SLURM_ARRAY_JOB_ID} task ${SLURM_ARRAY_TASK_ID}"
echo "Its name is ${SLURM_JOB_NAME} and its ID is ${SLURM_JOB_ID}"

###########################################################################
###########################      FUNCTIONS      ###########################
###########################################################################
AZ_assignation(){
    # Function to assignate A and Z according to the target specified
    type="sol"
    if [[ "$1" == "D" || "$1" == "D2" ]]
    then
	echo "Using Deuterium"
	A=2
	Z=1
	type="liq"
	vertex="-6.0*cm, 1.0*cm, reset"
    elif [[ "$1" == "C" ]]
    then
	echo "Using Carbon"
	A=12
	Z=6
	vertex="-1.0*cm, 0.74*mm, reset"
    elif [[ "$1" == "Al" ]]
    then
	echo "Using Aluminum"
	A=27
	Z=13
	vertex="-1.0*cm, 0.6*mm, reset"
    elif [[ "$1" == "Cu" ]]
    then
	echo "Using Copper"
	A=63
	Z=29
	vertex="-1.0*cm, 0.18*mm, reset"
    elif [[ "$1" == "Sn" ]]
    then
	echo "Using Tin"
	A=120
	Z=50
	vertex="-1.0*cm, 0.15*mm, reset"
    elif [[ "$1" == "Pb" ]]
    then
	echo "Using Lead"
	A=208
	Z=82
	vertex="-1.0*cm, 0.07*mm, reset"
    else
	echo "No target input!"
	exit 1
    fi
    echo "A=${A} and Z=${Z}"    
}

###########################################################################
###########################     DIRECTORIES     ###########################
###########################################################################
main_dir=${1} #main directory (where this file is located)
LEPTO_dir=${2} #LEPTO exe directory
execution_dir=${3} #directory where all neceesary files are copied to and run
lepto2dat_dir=${4} #lepto to dat directory
dat2tuple_dir=${5} #lepto to tuple directory
out_dir_lepto=${6} #output directory for lepto files
out_dir_recon=${7} # output directory for hipo and root files output from recon

###########################################################################
###########################      VARIABLES      ###########################
###########################################################################
Nevents=${8}
torus=${9}
solenoid=${10}
target=${11}
beam_energy=${12}

###########################################################################
###########################       PREAMBLE      ###########################
###########################################################################
#JOB id for directory and output name puposes
id=${target}_${SLURM_ARRAY_JOB_ID}${SLURM_ARRAY_TASK_ID}

# Create folder in volatile to not interfere with other lepto executions
temp_dir=${execution_dir}/${id}
mkdir ${temp_dir}
cd ${temp_dir}

# If GEMC is not loaded, load clas12 modules
echo "Running GEMC"
if [ -z "${GEMC_DATA_DIR}" ]
then
    module use /scigroup/cvmfs/hallb/clas12/sw/modulefiles
    module load clas12/dev
    module load clas12/gemc/dev
fi

###########################################################################
###########################       LEPTO         ###########################
###########################################################################

echo "Running LEPTO"

lepto_out=lepto_out_${id}

# Copy lepto executable to temp folder
cp ${LEPTO_dir}/lepto.exe ${temp_dir}/lepto_${id}.exe
echo "Copying LEPTO to temp dir"

# Assign the targets A and Z numbers
AZ_assignation ${target}
echo "${Nevents} ${A} ${Z}" > lepto_input.txt
echo "Target assignation done!"

# EXECUTE LEPTO
./lepto_${id}.exe < lepto_input.txt > ${lepto_out}.txt
echo "LEPTO execution done"

# Transform lepto's output to dat files
cp ${lepto2dat_dir}/lepto2dat.pl ${temp_dir}/
perl lepto2dat.pl 0 < ${lepto_out}.txt > ${lepto_out}.dat
echo "lepto2dat done"

# Transform's dat files into ROOT NTuples
echo "dat2tuple start"
cp ${dat2tuple_dir}/bin/dat2tuple ${temp_dir}/
./dat2tuple ${lepto_out}.dat ${lepto_out}_ntuple.root
echo "Finished LEPTO"

###########################################################################
###########################       GEMC          ###########################
###########################################################################

gemc_out=gemc_out_${id}_${target}_s${solenoid}_t${torus}
gcard_name=/u/scigroup/cvmfs/hallb/clas12/sw/noarch/clas12-config/dev/gemc/dev/rge_spring2024_LD2-${target}-${type}

# Copy the utils dir into execution dir 
cp -r ${rec_utils_dir}/* ${temp_dir}/
cd ${temp_dir}

# Transform lepto's output to LUND format
LUND_lepto_out=LUND_${lepto_out}
perl leptoLUND.pl 0 ${beam_energy} < ${lepto_out}.txt > ${LUND_lepto_out}.dat

#./targets.pl config.dat (Not working for some reason)

# Change some variables in the gcard
#sed -i "s/TORUS_VALUE/${torus}/g" ${gcard_name}.gcard
#sed -i "s/SOLENOID_VALUE/${solenoid}/g" ${gcard_name}.gcard

# EXECUTE GEMC 5
gemc ${gcard_name}.gcard -INPUT_GEN_FILE="LUND, ${LUND_lepto_out}.dat" -OUTPUT="hipo, ${gemc_out}.hipo" -USE_GUI="0" -RANDOMIZE_LUND_VZ=${vertex}
echo "GEMC execution finished"

###########################################################################
######################       RECONSTRUCTION          ######################
###########################################################################

# EXECUTE RECONSTRUCTION
yaml_name=/u/scigroup/cvmfs/hallb/clas12/sw/noarch/clas12-config/dev/coatjava/10.1.1/${gcard_name}.yaml
recon-util -y ${yaml_name}.yaml -i ${gemc_out}.hipo -o ${gemc_out}_rec.hipo
echo "Reconstruction done"

###########################################################################
######################       MOVE TO FINAL DIR       ######################
###########################################################################

# Move output to its folder
mv ${lepto_out}.txt ${lepto_out}.dat ${lepto_out}_ntuple.root ${LUND_lepto_out}.dat ${out_dir_lepto}/
mv ${gemc_out}_rec.hipo ${out_dir_recon}/

# Remove folder
rm -rf ${temp_dir}
echo "Done!"