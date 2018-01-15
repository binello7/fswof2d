## Copyright (C) 2018 Sebastiano Rusca
##
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##g
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.
##
## Author: Sebastiano Rusca <sebastiano.rusca@gmail.com>
## Created: 2018-01-08

pkg load fswof2d
pkg load linear-algebra
close all




## Global parameters
#
dataFolder  = 'data';
studyName   = 'ChannelMiddleWeir_meshstudy';

## Generate needed folders for FullSWOF_2D
studyFolder   = fullfile (dataFolder, studyName);
inputsFolder  = fullfile (studyFolder, 'Inputs');
outputsFolder = fullfile (studyFolder, 'Outputs');
fname         = @(s) fullfile (inputsFolder, s);
suffname      = @(s,d) sprintf ('%s_%02d.dat', s, d);
if !exist (inputsFolder, 'dir')
  mkdir (inputsFolder);
endif


## Parameters that don't change in the loop
nExp = 4;     # how many experiments we run
B = 4;
Ly = 40;     # length of the channel, same for all experiments
alpha = -5; # slope of the channel

## Define the shape of the weir
#
weir_height = 3;
pweir  = interp1 ([0 16 17 20 21 40], [0 0 weir_height weir_height 0 0], 'pp');
hwater = interp1 ([0 20 21 40], [0 0 weir_height weir_height], 'pp');


# write the alpha-rotation matrix
rx_alpha = rotv ([1 0 0], deg2rad (alpha));
np = rx_alpha * [0 0 1].';

for i = 1:nExp
  ## Generate the parameters varying from one experiment to the other
  # the number of grid cells is doubled from one experiment to the other
  Ny = 100 * 2^(i-1); # number of grid cells in longitudinal direction
  Nx = 10 * 2^(i-1);  # number of grid cells in lateral direction

  # Generate nodes vectors
  x = linspace (0, B, Nx+1);
  xc = node2center (x);
  y = linspace (0, Ly, Ny+1);
  yc = node2center (y);

  # Generate nodes meshes
  [XX YY] = meshgrid (xc, yc);

  # Generate the weir topography
  zc = (ppval (pweir, yc)).';
  ZZ = repmat (zc, 1, Nx);


  ## Generate initial conditions for h, depending on weir position
  hc = (ppval (hwater, yc)).';
  HH = repmat (hc, 1, Nx);

  # generate the free surface
  HZ = ZZ + HH;

  # u and v can be set to 0
  UU = zeros (Ny, Nx);
  VV = zeros (Ny, Nx);


  surf (XX, YY, ZZ);
  hold on
  mesh (XX, YY, HZ, 'facecolor', 'none', 'edgecolor', 'b');
  hold off

  pause (2);


  #  Convert the data to the FullSWOF_2D format
  [X Y Z H U V] = dataconvert ('fswof2d', XX, YY, ZZ, HH, UU, VV);

  #  Write the topography to the file
  topofile = suffname ("topography", i);
  topo2file (X, Y, Z, fname (topofile));

  #  Write the initial conditions to the file
  huvfile = suffname ("huv_init", i);
  huv2file (X, Y, H, U, V, fname (huvfile));


  #  Write the simulation parameters to a file
  sim_duration    = 200;
  saved_states    = 200;
  top_boundary    = 5;
  top_Q           = -5;
  top_h           = 6.3;
  bot_boundary    = 3;
  out_suff        = sprintf ('_%02d', i);
  paramsfile      = suffname ("parameters", i);
  p = params2file ('xCells', Nx, 'yCells', Ny, 'xLength', B, ...
              'yLength', Ly, 'SimDuration', sim_duration, ...
              'SavedStates', saved_states, 'BotBoundCond', bot_boundary, ...
              'TopBoundCond', top_boundary, 'TopImposedQ', top_Q, ...
              'TopimposedH', top_h, 'huvFile', huvfile, ...
              'TopographyFile', topofile, 'ParamsFile', fname (paramsfile), ...
              'OutputsSuffix', out_suff);

  # generate the 'Outputs' folders
  suffoutputsFolder = strcat (outputsFolder, out_suff);
  if !exist (suffoutputsFolder, 'dir')
    mkdir (suffoutputsFolder);
  endif
endfor

close all

## Write bash script to run study
bfile = fullfile (studyFolder, "run.sh");
printf ("Writing Bash script to file %s\n", bfile); fflush (stdout);
timetxt = strftime ("%Y-%m-%d %H:%M:%S", localtime (time ()));
bsh = {
'#!/bin/bash', ...
sprintf("## Automatically generated on %s\n", timetxt), ...
'echo Started on $(date)', ...
sprintf("for i in {1..%d}; do", nExp), ...
sprintf("  id=`printf %%02d $i`"), ...
'  nohup fswof2d -f parameters_$id.dat &', ...
'  if(( ($i % $(nproc)) == 0)); then wait; fi', ...
'done', ...
'echo Finished on $(date)'
};
bsh = strjoin (bsh, "\n");
fid = fopen (bfile, "wt");
fputs (fid, bsh);
fclose (fid);

# save global variables
save(fullfile (studyFolder, 'input_variables.dat'), 'nExp', 'wpos', 'weir_height');
clear all


