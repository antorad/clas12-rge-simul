# CLAS12 simulations
Simple package set to obtain simulations in JLAB's farm (Based in E. Molina code).
The whole workflow consist in three major parts:
1. Event Generation with LEPTO
2. Particle passage through CLAS12 detector with GEMC.
3. Event reconstruction.

## Thrown (LEPTO)
- **lepto2dat** : perl code modified from W. Brooks' original code. It transforms the output of lepto to a .dat file that can be easily read by *dat2tuple*.
    - *usage* : perl lepto2dat.pl z_vertex < lepto_original.out > lepto_out.dat
- **dat2tuple** : C++ code that takes a file formated by *lepto2dat* and outputs a root file with tuples for the electrons, hadrons, and raw.
    - *usage* :
       1. Execute *make*
       2. In bin folder: *./dat2tuple <input_file_name> <output_file_name>*

### Notes
- To modify beam energy, it has to changed in:
  - clas12-rge-simul/thrown/dat2tuple/include/constants.h
  - /home/antonio/clas12-rge-simul/thrown/Lepto64/src_f/qp1.f

## Reconstructed (GEMC)
W.I.P.

## Quick notes!
W.I.P.

## TODO
- Check enviroment varaibles set in run_full_simulation.sh
- Clean Lepto directory and keep only the necessary
- Remove duplicate codes
- Add a short description of every piece code used in run_full_simulation.sh and usage
- Add explanation on the setup of the JLab cluster environment to run this.
- Once the target model is incorporated officialy to GEMC, remove the use of the target included here in run_full_simulation.sh and modify the gcard to use the official one. Keep the models just in case of future testing.
- Test