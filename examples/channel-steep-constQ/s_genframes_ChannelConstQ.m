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
%% Created: 2017-12-11

pkg load fswof2d
close all


%% Global parameters
dataFolder  = "data";

%% Read outputs from files
outputsFolder = fullfile (dataFolder, 'Outputs');

fname = @(s) fullfile (outputsFolder, s);

data_init = load (fname ('huz_initial.dat'));
data_evl  = load (fname ('huz_evolution.dat'));

paramsfile = fullfile (dataFolder, 'Inputs', 'parameters.txt');
params = read_params (paramsfile);

%% Get topography
% Topography in FullSWOF_2D format
x_swf = data_init(:,1);
y_swf = data_init(:,2);
z_swf = data_init(:,7);

% Convert the data from 'fswof2d' to 'octave'
Nx = params.Nxcell;
Ny = params.Nycell;
[X Y Z] = dataconvert ('octave', [Nx Ny], x_swf, y_swf, z_swf);

tsteps = params.nbtimes;
for t = 1:tsteps
  idx_1 = 1 + (t - 1) * Nx * Ny;
  idx_2 = t * Nx * Ny;
  span = idx_1:idx_2;

  hz_evl(:,t)  = data_evl(span,6);
  HZ_evl(:,:,t)  = dataconvert ('octave', [Nx Ny], hz_evl(:,t));
end%for

az = 70;
el = 45;

figure("position",get(0,"screensize"), "visible", "off")
ZZ = HZ_evl - Z;
ZZ(ZZ==0) = NA;
ZZ = ZZ + Z;
view (az, el);

g = surf (X, Y, ZZ(:,:,1), 'edgecolor', 'none');
shading interp
hold on
mesh (X, Y, Z, 'facecolor', 'w','edgecolor','k');
hold off
colormap(ocean(64));
axis ([min(X(:)) max(X(:)) min(Y(:)) max(Y(:)) min(Z(:)) max(Z(:))])
grid on;

% Save first frame
framesFolder = fullfile ('frames');
mkdir (framesFolder);
frame = fullfile (framesFolder, sprintf ('frame-%04d.png', 1));
print ('-dpng', '-r300', '-S1920,1080', frame);

% Save next frames
for t = 2:tsteps
  set(g, 'zdata', ZZ(:,:,t));
  frame = fullfile (framesFolder, sprintf ('frame-%04d.png', t));
  msg = sprintf ('Saving %s', frame);
  disp (msg)
  print ('-dpng', '-r300', '-S1920,1080', frame);
end%for
