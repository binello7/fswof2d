## Copyright (C) 2018 Sebastiano Rusca
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program. If not, see <http://www.gnu.org/licenses/>.

## Author: Sebastiano Rusca
## Created: 2018-01-05

pkg load fswof2d
close all


## Global parameters
#
dataFolder  = "data";
studyName   = "Channelweir";
fsuf = @(s, n) strcat (s, sprintf ('_%02d', n));

## Read outputs from files
#
inputsFolder  = fullfile (dataFolder, studyName, 'Inputs');
outputsFolder = fullfile (dataFolder, studyName, 'Outputs_01');
fname         = @(s) fullfile (outputsFolder, s);
data_init     = load (fname ('huz_initial.dat'));
Qin           = load (fullfile (inputsFolder, 'Qin_values.dat'), '-ascii');
Qin = Qin.';
paramsfile    = fullfile (inputsFolder, 'parameters_01.txt');
params = read_params (paramsfile);
nfiles        = length (Qin);

## Get topography
# Topography in FullSWOF_2D format
x_swf = data_init(:,1);
y_swf = data_init(:,2);
z_swf = data_init(:,7);
Nx = params.Nxcell;
Ny = params.Nycell;
# Convert the data from 'fswof2d' to 'octave'
[X Y Z] = dataconvert ('octave', [Nx Ny], x_swf, y_swf, z_swf);

## Read outputs that have to be updated
for i = 1:nfiles
  outputsFolder = fullfile (dataFolder, studyName, fsuf ('Outputs', i));
  data_fin   = load (fullfile (outputsFolder, 'huz_final.dat'));

  ## Get the free surface altitude at the last time step
  hz_fin = data_fin(:,6);
  HZ_fin = dataconvert ('octave', [Nx Ny], hz_fin);

  ## Get the mean height over the weir
  h_weir(i,1) = mean (HZ_fin(1,:) - Z(1,:));
endfor
