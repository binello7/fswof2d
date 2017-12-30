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

## Global parameters
#
dataFolder  = "data";
studyName   = 'ChannelVarQ';


## Generate topography
# Define variables needed for the parametrization of the topography.

##
# Channel geometry
Ly    = 100;   # Channel length
alpha = 5;    # Slope along the length in degrees

##
# Topography mesh parameters
Nxcell = 40;
Nycell = 200;
# mesh nodes
y             = linspace (0, Ly, Nycell + 1).';
y             = node2center (y);
[x z p xi zi] = csec_channel2lvlsym (Nxcell, "Embankment", 2, ...
                "Plain", 5, "RiverBank", 1, "riverbed", 4, ...
                "bankheight", 1, "embankmentheight", 1);
xc            = node2center (x);
z             = interp1 (x, z, xc);
x             = xc; clear xc;
[X Y Zc]      = extrude_csec (x, y, z);
# Define a plane with the given slope
nf = @(d1,d2) [cosd(d2).*sind(d1) sind(d2).*sind(d1) cosd(d1)];
np = nf (alpha, 0);
Zp = (np(1) * Y + np(2) * X ) ./ np(3);
# Total surface
Z = Zc + Zp;

## Generate initial conditions
# Define variables needed for the parametrization of the initial condition.

# The inital conditons is 0.5 meters of water inside the channel
zw0 = 0.5; # free surface at 0.5 meters
# mask bed of channel
bd_mask = z < sqrt (eps);
# mask banks of channel
bk_mask = z < zw0 & !bd_mask;
# mask whole channel
ch_mask = bd_mask | bk_mask;

zw0          = zw0 * ch_mask;
h0          = zw0 - z;
h0(h0 < 0) = 0;

H0 = extrude_csec (x, y, h0);
U0 = V0 = zeros (size (X));

## Write out data files
#

# Convert to FullSWOF_2D format
data = {X,Y,Z,H0,U0,V0};
[x_swf y_swf z_swf ...
 h_swf u_swf v_swf] = dataconvert ('fswof2d', data{:});


  # write out topography
  datatopo = {x_swf, y_swf, z_swf};

  # write out IC
  datahuv = {x_swf, y_swf, h_swf, u_swf, v_swf};

  ## Write out paramters files
  #
  Lx        = (p.Embankment + p.Plain + p.RiverBank) * 2 + p.RiverBed;
  simT      = 150;
  nbT       = 50;
  topbound  = 5;
  botbound  = 3;
  studyNr   = 1;
  Qin       = 10;

studyFolder   = fullfile (dataFolder, studyName);


while studyNr <= 8;
  seqName       = strcat (studyName, '_', sprintf ('%02d', studyNr));
  seqFolder     = fullfile (studyFolder, seqName);
  inputsFolder  = fullfile (seqFolder, 'Inputs');
  fname         = @(s) fullfile (inputsFolder, s);
  outputsFolder = fullfile (seqFolder, 'Outputs');
  mkdir (inputsFolder);
  mkdir (outputsFolder);
  params2file ("ParamsFile", fname ('parameters.txt'), ...
               "xCells", Nxcell, ...
               "yCells", Nycell, ...
               "xLength", Lx, ...
               "yLength", Ly, ...
               "SimTime", simT, ...
               "SavedTimes", nbT, ...
               "TopimposedQ", Qin, ...
               "BotBoundCond", botbound, ...
               "TopBoundCond", topbound);

  topo2file (datatopo{:}, fname ('topography.dat'));
  huv2file (datahuv{:}, fname ('huv_init.dat'));

  Qin     += 2;
  studyNr += 1;
endwhile






