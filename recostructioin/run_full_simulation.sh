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

echo "This is JOB ${SLURM_ARRAY_JOB_ID} task ${SLURM_ARRAY_TASK_ID}"
echo "Its name is ${SLURM_JOB_NAME} and its ID is ${SLURM_JOB_ID}"

###########################################################################
###########################      FUNCTIONS      ###########################
###########################################################################
AZ_assignation(){
    # Function to assignate A and Z according to the target specified
    if [[ "$1" == "D" || "$1" == "D2" ]]
    then
	echo "Using Deuterium"
	A=2
	Z=1
    elif [[ "$1" == "C" ]]
    then
	echo "Using Carbon"
	A=12
	Z=6
    elif [[ "$1" == "Al" ]]
    then
	echo "Using Aluminum"
	A=27
	Z=13
    elif [[ "$1" == "Cu" ]]
    then
	echo "Using Copper"
	A=63
	Z=29
    elif [[ "$1" == "Sn" ]]
    then
	echo "Using Tin"
	A=120
	Z=50
    elif [[ "$1" == "Pb" ]]
    then
	echo "Using Lead"
	A=208
	Z=82
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
rec_utils_dir=${6} #utils directory (with target files, gcards, yaml, etc)
out_dir_lepto=${7} #output directory for lepto files
out_dir_recon=${8} # output directory for hipo and root files output from recon

###########################################################################
###########################      VARIABLES      ###########################
###########################################################################
Nevents=${9}
torus=${10}
solenoid=${11}
target=${12}
beam_energy=${13}

###########################################################################
###########################       PREAMBLE      ###########################
###########################################################################
#JOB id for directory and output name puposes
id=${target}_${SLURM_ARRAY_JOB_ID}${SLURM_ARRAY_TASK_ID}

# Create folder in volatile to not interfere with other lepto executions
temp_dir=${execution_dir}/${id}
mkdir ${temp_dir}
cd ${temp_dir}

###########################################################################
###########################       LEPTO         ###########################
###########################################################################

echo "Running LEPTO"
# Prereqs setting
if [ -z "${CERN}" ]
then
    source ~/software/env_scripts/set_all.sh
fi

lepto_out=lepto_out_${id}

# Setting the vertex
cp ${rec_utils_dir}/vertex.py .
z_vertex=$(python vertex.py ${target})
echo "Vertex is Z = ${z_vertex}(cm)"

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
perl lepto2dat.pl ${z_vertex} < ${lepto_out}.txt > ${lepto_out}.dat
echo "lepto2dat done"

# Transform's dat files into ROOT NTuples
echo "dat2tuple start"
cp ${dat2tuple_dir}/bin/dat2tuple ${temp_dir}/
./dat2tuple ${lepto_out}.dat ${lepto_out}_ntuple.root
echo "Finished LEPTO"

###########################################################################
###########################       GEMC          ###########################
###########################################################################

# Prereqs setting
echo "Running GEMC"
if [ -z "${GEMC_DATA_DIR}" ]
then
    module use /scigroup/cvmfs/hallb/clas12/sw/modulefiles
    module load clas12
fi

gemc_out=gemc_out_${id}_${target}_s${solenoid}_t${torus}
gcard_name=rge

# Copy the utils dir into execution dir 
cp -r ${rec_utils_dir} ${temp_dir}/
cd ${temp_dir}

# Transform lepto's output to LUND format
LUND_lepto_out=LUND_${lepto_out}
perl leptoLUND.pl ${z_vertex} ${beam_energy} < ${lepto_out}.txt > ${LUND_lepto_out}.dat

#./targets.pl config.dat (Not working for some reason)

# Change some variables in the gcard
sed -i "s/TORUS_VALUE/${torus}/g" ${gcard_name}.gcard
sed -i "s/SOLENOID_VALUE/${solenoid}/g" ${gcard_name}.gcard
sed -i "s/TARGET/${target}/g" ${gcard_name}.gcard

# EXECUTE GEMC
#For GEMC 4 - EVIO format output
#gemc ${gcard_name}.gcard -INPUT_GEN_FILE="LUND, ${LUND_lepto_out}.dat" -OUTPUT="evio, ${gemc_out}.ev" -USE_GUI="0"
#For GEMC 5 - HIPO format output
gemc ${gcard_name}.gcard -INPUT_GEN_FILE="LUND, ${LUND_lepto_out}.dat" -OUTPUT="hipo, ${gemc_out}.hipo" -USE_GUI="0"
echo "GEMC execution finished!"

###########################################################################
######################       RECONSTRUCTION          ######################
###########################################################################

# Transform to HIPO
evio2hipo -t ${torus} -s ${solenoid} -r 11 -o ${gemc_out}.hipo -i ${gemc_out}.ev
rm ${gemc_out}.ev
echo "Evio 2 HIPO transformation successful"

# EXECUTE RECONSTRUCTION
cp ${rec_utils_dir}/clas12_2021.yaml ${temp_dir}/
recon-util -y clas12_2021.yaml -i ${gemc_out}.hipo -o ${gemc_out}.rec.hipo
echo "Reconstruction successful"
rm ${gemc_out}.hipo

# Move output to its folder
mv ${lepto_out}.txt ${lepto_out}.dat ${lepto_out}_ntuple.root ${LUND_lepto_out}.dat ${out_dir_lepto}/
mv ${gemc_out}.rec.hipo ${out_dir_recon}/
mv ${lepto_out}_ntuple.root ${out_dir_lepto}/

# Remove folder
rm -rf ${temp_dir}
echo "Done!"
