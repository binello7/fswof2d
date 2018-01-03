## Copyright (C) YYYY Sebastiano Rusca
##
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.
##
## Author: Sebastiano Rusca <sebastiano.rusca@gmail.com>
## Created: 2018-01-02

pkg load fswof2d
pkg load linear-algebra

## Global parameters
#
dataFolder  = 'data';
studyName   = 'Channelweir';

## Generate the topography
#  First the cross-section shape, which will be a "rectangle" 2.5 m wide

B = 2.5;
Nx = 50;
x = linspace (0, B, Nx+1);
xc = node2center (x);
z = zeros (1, Nx);
z(1) = z(end) = 2;
#x = linspace (0, 2*R, Nx+1);
#z = R - sqrt (R^2 - (x-R).^2);

#  Extrude the cross-section along the y-axis
Ly = 40;
Ny = 80;
y = linspace (0, Ly, Ny+1);
yc = node2center (y);
[XX YY ZZc] = extrude_csec (xc, yc, z);


#  Rotate the cross-section by the chosen slope value alpha
alpha = -10;
rx_alpha = rotv ([1 0 0], deg2rad (alpha));
np = rx_alpha * [0 0 1].';
ZZp = -(np(1)*XX + np(2)*YY) / np(3);
ZZ = ZZp + ZZc;


## Generate initial conditions for h, u and v can be set to 0
HH = ones (Ny, Nx);
UU = zeros (Ny, Nx);
VV = zeros (Ny, Nx);
HH(:,1) = HH(:,end) = 0;
HZ = ZZ + HH;

#  Generate weir at the end of the channel
ZZ(1,:) = 1;

surf (XX, YY, ZZ, 'facecolor', 'k');
hold on
mesh (XX, YY, HZ, 'edgecolor', 'b');
hold off

## Generate needed inputs files and folders for FullSWOF_2D
#  Generate Folders
studyFolder   = fullfile (dataFolder, studyName);
inputsFolder  = fullfile (studyFolder, 'Inputs');
outputsFolder = fullfile (studyFolder, 'Outputs');
if !exist (inputsFolder, 'dir')
  mkdir (inputsFolder);
endif

if !exist (outputsFolder, 'dir')
    mkdir (outputsFolder);
  endif
  
fname         = @(s) fullfile (inputsFolder, s);

#  Convert the data to the FullSWOF_2D format
[X Y Z H U V] = dataconvert ('fswof2d', XX, YY, ZZ, HH, UU, VV);

#  Write the topography to the file
topo2file (X, Y, Z, fname ('topography.dat'));

#  Write the initial conditions to the file
huv2file (X, Y, H, U, V, fname ('huv_init.dat'));

#  Write the simulation parameters to a file
sim_duration    = 100;
saved_timesteps = 100;
top_boundary    = 5;
top_Q           = -0.3;
top_h           = 1;
bot_boundary    = 3;
params2file ('xCells', Nx, 'yCells', Ny, 'xLength', B, ...
            'yLength', Ly, 'SimTime', sim_duration, ...
            'SavedTimes', saved_timesteps, 'BotBoundCond', bot_boundary, ...
            'TopBoundCond', top_boundary, 'TopImposedQ', top_Q, ...
            'TopimposedH', top_h, 'ParamsFile', fname ('parameters.txt'));













