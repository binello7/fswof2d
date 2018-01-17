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
## Created: 2018-01-10

pkg load fswof2d
pkg load linear-algebra

## Global parameters
#
dataFolder  = 'data';
studyName   = 'TransformationFunction';

B = 4;
Nx = 100;
x = linspace (0, B, Nx+1);
xc = node2center (x);
z = zeros (1, Nx);
z(1) = z(end) = 5;


#  Extrude the cross-section along the y-axis
Ly = 150;
Ny = 375;
y = linspace (0, Ly, Ny+1);
yc = node2center (y);
[XX YY ZZch] = extrude_csec (xc, yc, z);


##  Rotate the cross-section by the chosen slope value alpha
#alpha = -10;
#rx_alpha = rotv ([1 0 0], deg2rad (alpha));
#np = rx_alpha * [0 0 1].';
#ZZp = -(np(1)*XX + np(2)*YY) / np(3);
#ZZ = ZZp + ZZc;


### h, u and v will all be set to zero


