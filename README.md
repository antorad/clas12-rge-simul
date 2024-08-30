# CLAS12 simulations
Simple package set to obtain simulations in JLAB's farm (Based in E. Molina code).
The whole workflow consist in three major parts:
1. Event Generation with LEPTO
2. Passage through detector with GEMC.
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
- 