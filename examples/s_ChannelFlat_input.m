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
studyName   = "ChannelFlat";

## Generate topography
# Define variables needed for the parametrization of the topography.

##
# Channel geometry
Ly    = 250;   # Channel length
alpha = 0;    # Slope along the length in degrees

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
keyboard
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

figure (1)
clf
plot_topo (X, Y, Z);
hold on
tmp   = H0; tmp(tmp < sqrt (eps)) = NA;
lblue = [0.5 0.5 1];
surf (X, Y, Z+tmp, 'edgecolor',lblue, 'facecolor','b');
hold off

## Write out data files
#

# Convert to FullSWOF_2D format
data = {X,Y,Z,H0,U0,V0};
[x_swf y_swf z_swf ...
 h_swf u_swf v_swf] = dataconvert ('fswof2d', data{:});
# FullSOWF_2D needs an Inputs and Ouput folder, check user manual.
inputsFolder  = fullfile (dataFolder, studyName, 'Inputs');
outputsFolder = fullfile (dataFolder, studyName, 'Outputs');
fname         = @(s) fullfile (inputsFolder, s);
mkdir (inputsFolder);
mkdir (outputsFolder);

# write out topography
data = {x_swf, y_swf, z_swf};
topo2file (data{:}, fname ('topography.dat'));
# write out IC
data = {x_swf, y_swf, h_swf, u_swf, v_swf};
huv2file (data{:}, fname ('huv_init.dat'));

## Write out paramters files
#
Lx        = (p.Embankment + p.Plain + p.RiverBank) * 2 + p.RiverBed;
simT      = 150;
nbT       = 50;
topbound  = 5;
Qin       = 10;
botbound  = 3;
params2file ("ParamsFile", fname('parameters.txt'), ...
             "xCells", Nxcell, ...
             "yCells", Nycell, ...
             "xLength", Lx, ...
             "yLength", Ly, ...
             "SimTime", simT, ...
             "SavedTimes", nbT, ...
             "TopimposedQ", Qin, ...
             "BotBoundCond", botbound, ...
             "TopBoundCond", topbound);




