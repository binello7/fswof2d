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

## Author: Juan Pablo Carbajal <ajuanpi+dev@gmail.com>
## Created: 2017-12-11

% future 
% pkg load fswf2d


for i = 1:6
  ## FILES
  topofile    = "topography.dat";
  huvfile     = "huv_init.dat";
  paramfile   = "parameters.txt";
  init        = 'huz_initial.dat';
  evl         = 'huz_evolution.dat';
  fin         = 'huz_final.dat';

 #-------------------------------------------------------------------------------

  ## FOLDERS
  studyName     = strcat ('Channel_VarAngle', num2str (i));
  dataName      = 'data';
  inputsName    = 'Inputs';
  outputsName   = 'Outputs';
  framesName    = 'frames';
 #-------------------------------------------------------------------------------

  ## CHANNEL GEOMETRY
  Nxcell = 250;
  Nycell = 140 - (i-1) * 2;
  L      = 250;
  simT   = 150;
  nbT    = 50;
  rb     = 5 + 1 - i;

  alpha = 10; # slope in degrees

  ## BOUNDARY CONDITIONS
  Bbottom = 1;
  Hbottom = 2;
 #-------------------------------------------------------------------------------

  studyFolder   = fullfile (dataName, studyName);
  mkdir (dataName, studyName);
  inputsFolder  = fullfile (studyFolder, inputsName);
  mkdir (studyFolder, inputsName);
  outputsFolder = fullfile (studyFolder, outputsName);
  mkdir (studyFolder, outputsName);
  framesFolder  = fullfile (studyFolder, framesName);
  finit  = fullfile (outputsFolder, init);
  fevl   = fullfile (outputsFolder, evl);
  ffin   = fullfile (outputsFolder, fin);

  ftopo  = fullfile (inputsFolder, topofile);
  fhuv   = fullfile (inputsFolder, huvfile);
  fparam = fullfile (inputsFolder, paramfile);

  [y z p yi zi] = csec_channel2lvlsym (Nycell, "RiverBank", rb);
  l = (p.Embankment + p.Plain + p.RiverBank)*2 + p.RiverBed;


  x = [0:L/Nxcell:L].';
  [X Y Zc] = extrude_csec (x, y, z);

  # Here is the slope surface
  nf = @(d1,d2) [cosd(d2).*sind(d1) sind(d2).*sind(d1) cosd(d1)];
  np = nf (alpha, 0);
  Zp = (np(1) * X + np(2) * Y ) ./ np(3);

  Z = Zc + Zp;
 #-------------------------------------------------------------------------------

  ## WRITE TOPOGRAPHY TO FILE
  [x_swf y_swf z_swf] = dataconvert (X, Y, Z, 'fswof2d', [Nxcell Nycell]);
  topo2file (x_swf, y_swf, z_swf, ftopo);


  ## WRITE HUV_INIT TO FILE
  h0 = 2;
  u0 = 0;
  v0 = 0;

  n = length (x_swf);

  h = zeros (n, 1);
  u = zeros (n, 1);
  v = zeros (n, 1);

  y1 = (yi(3) + yi(4)) /2;
  y2 = (yi(5) + yi(6)) /2;
  h(y_swf > y1 & y_swf < y2 & x_swf > x(1) & x_swf < x(end)) = h0;

  huv2file (x_swf, y_swf, h, u, v, fhuv);
  
  figure (i)
  plot_topo (X, Y, Z);
  pause (4);
  close

  ## INITIALIZE PARAMETERS
  init_params ("ParamsFile", fparam, ...
               "xCells", Nxcell, ...
               "yCells", Nycell, ...
               "xLength", L, ...
               "yLength", l, ...
               "SimTime", simT, ...
               "SavedTimes", nbT, ...
               "LBoundCond", Bbottom, ...
               "LimposedH", Hbottom);
endfor




