%% Copyright (C) 2017 Sebastiano Rusca
%%
%% This program is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 3 of the License, or
%% (at your option) any later version.
%%
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public License
%% along with this program. If not, see <http://www.gnu.org/licenses/>.

%% Author: Sebastiano Rusca
%% Created: 2020-04-07

imgs_dir = 'imgs'
if ~exist (imgs_dir, 'dir')
  mkdir imgs_dir
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pkg load fswof2d

% Generate cross-section and plot it
Nx = 100 % number of x-nodes
[x z p xi zi] = csec_channel2lvlsym (Nx);
elements = fieldnames (p);
plot(x,z,'s-;mesh;',xi,zi,'*;knots;')
hold on
axis tight

for i = 1:length (elements)
  t = sprintf ("%s = %d", elements{i}, p.(elements{i}));
  text (15, 12-0.5*i, t, 'fontsize', 8);
end
axis square
hold off
print (fullfile (imgs_dir, 'csec.png'))

% Extrude cross-section and plot it
L = 400 % channel length
Ny = 100 % number of y-nodes

y = linspace (0, L, Ny);

[X Y Z] = extrude_csec (x, y, z);
mesh (X, Y, Z, 'edgecolor', 'k');
axis equal
axis tight
set (gca, 'ztick', [min(z), max(z)]);
print (fullfile (imgs_dir, 'mesh.png'))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find the centers of the mesh
xc = node2center (x);
yc = node2center (y);
zc = node2center (z);

[XC YC ZC] = extrude_csec (xc, yc, zc);

mesh (X, Y, Z, 'edgecolor', 'k');
hold on
p = scatter3 (XC, YC, ZC, 3, 'r', 'filled');
hold off
axis equal
axis tight
set (gca, 'ztick', [min(z), max(z)]);
print (fullfile (imgs_dir, 'centers.png'), '-r300')
