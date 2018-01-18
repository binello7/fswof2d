## Copyright (C) 2018 Sebastiano Rusca
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
## Created: 2018-01-17


close all

## Global parameters
#
dataFolder  = 'data';
studyName   = 'MatTestTopo_input';
stlName     = 'floodx_surface.stl';

## Generate needed folders for FullSWOF_2D
studyFolder   = fullfile (dataFolder, studyName);
stlFile       = fullfile (dataFolder, stlName);
inputsFolder  = fullfile (studyFolder, 'Inputs');
outputsFolder = fullfile (studyFolder, 'Outputs');
fname         = @(s) fullfile (inputsFolder, s);

if !exist (inputsFolder, 'dir')
  mkdir (inputsFolder);
endif

## Read .stl file
#
[vertices, faces, c] = stlread(stlFile);
#stlview(stlFile);

## Plot .stl file with patch
#
figure (1)
g = 192/255;
patch ('Faces', faces, 'Vertices', vertices, 'facecolor', ...
       [g g g]);
axis equal;

## Convert .stl to uniform grid
x = vertices(:,1);
y = vertices(:,2);
z = vertices(:,3);

xMax = max (x);
xMin = min (x);
yMax = max (y);
yMin = min (y);


xi = linspace (xMin, xMax, 500);
yi = linspace (yMin, yMax, 500);

[xxi yyi] = meshgrid (xi, yi);
zzi = griddata (x, y, z, xxi, yyi, 'linear');

figure (2)
mesh (xxi, yyi, zzi);
axis equal;
colormap gray
light ();








