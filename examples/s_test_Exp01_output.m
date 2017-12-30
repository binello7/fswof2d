## Copyright (C) 2017 Sebastiano Rusca
## Copyright (C) 2017 Juan Pablo Carbajal
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
## Created: 2017-12-30

pkg load fswof2d
close all

if ~exist ('hz_fin', 'var')
  ## Global parameters
  #
  dataFolder  = "data";
  studyName   = "test_Exp01";

  ## Read outputs from files
  #
  outputsFolder = fullfile (dataFolder, studyName, 'Outputs');
  fname         = @(s) fullfile (outputsFolder, s);

  data_init = load (fname ('huz_initial.dat'));
  data_fin  = load (fname ('huz_final.dat'));
  data_evl  = load (fname ('huz_evolution.dat'));

  paramsfile = fullfile (dataFolder, studyName, 'Inputs', 'parameters.txt');
  params = read_params (paramsfile);

  ## Get topography and final state free surface
  # Topography in FullSWOF_2D format
  x_swf = data_init(:,1);
  y_swf = data_init(:,2);
  z_swf = data_init(:,7);

  # Convert the data from 'fswof2d' to 'octave'
  Nx = params.Nxcell;
  Ny = params.Nycell;
  [x y z] = dataconvert ('octave', [Nx Ny], x_swf, y_swf, z_swf);

  # Final state free surface
  hz_fin = data_fin(:,6);
  hz_fin = dataconvert ('octave', [Nx Ny], hz_fin);
endif

## Plot topography and final state free surface
#
figure (1)
g = plot_topo (x, y, z);
hold on
h = surf (x, y, hz_fin);
az = -135;
el = 15;
view (az, el);
lblue = [0.5 0.5 1];
set (h, 'facecolor', 'none', 'edgecolor', lblue)
hold off




