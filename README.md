# fswof2d

GNU Octave package including utility functions to interact with the [FullSWOF_2D](https://www.idpoisson.fr/fullswof/) overland flow simulator.

The *fswof2d* package include a series of function that facilitate interaction
with the FullSWOF_2D simulator. Minimal requirements in order to run a
FullSWOF_2D simulation are:
* topography file: *topography.dat*
* initial conditions file: *huv_init.dat*
* simulation parameters file: *parameters.txt*

Writing these files in a format fully-compatible with FullSWOF_2D (:heavy_exclamation_mark:v-1.07.00:heavy_exclamation_mark:) can be easily achieved by using the functions `topo2file`, `huv2file` and `params2file`.

The function `read_params` allows reading the parameters used for a given simulation (stored in the `parameters.txt` file) as a `struct`. This can be useful in order to carry out sensitivity analysis where one or more simulation parameters are to be varied.

*GNU Octave* and *FullSWOF_2D* have different ways of representing 3D meshes

## Code examples

## Complete Functions list
* topo2file
* huv2file
* params2file
* read_params
* dataconvert
* center2node
* csec_channel2lvlsym
* extrude_csec
* matplotlib_cm
* node2center




## Install
