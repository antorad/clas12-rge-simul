# CLAS12 simulations
Simple package set to obtain simulations in JLAB's farm (Based in E. Molina code).
The whole workflow consist in three major parts:
1. Event Generation with LEPTO
2. Particle passage through CLAS12 detector with GEMC.
3. Event reconstruction.

## Thrown (LEPTO)
### Setting Environment for compilation
- In JLab machines, set the environmet by loading clas12 modules:
  - module use /scigroup/cvmfs/hallb/clas12/sw/modulefiles
  - module load clas12
- Then, to compile LEPTO set the rest of the environment by running:
  - source thrown/set_env.sh

### List of scripts:
- **lepto2dat** : perl code modified from W. Brooks' original code. It transforms the output of lepto to a .dat file that can be easily read by *dat2tuple*.
    - *usage* : perl lepto2dat.pl z_vertex < lepto_original.out > lepto_out.dat
- **dat2tuple** : C++ code that takes a file formated by *lepto2dat* and outputs a root file with tuples for the electrons, hadrons, and raw.
    - *usage* :
       1. Execute *make*
       2. In bin folder: *./dat2tuple <input_file_name> <output_file_name>*
- **dat2root** : root macro to convert .dat output to raw root file.
    - *usage* : root dat2root
 **lepto** : Particle generator. check its own README in Lepto64 subdirectory.

### Notes
- To modify beam energy, it has to changed in:
  - clas12-rge-simul/thrown/dat2tuple/include/constants.h
  - clas12-rge-simul/thrown/Lepto64/src_f/qp1.f

## Reconstruction (GEMC)
W.I.P.

## Quick notes!
W.I.P.

## TODO
- Add a short description of every piece code used in run_full_simulation.sh and usage
- Once the target model is incorporated officialy to GEMC, remove the use of the target included here in run_full_simulation.sh and modify the gcard to use the official one. Keep the models just in case of future testing.
- Test