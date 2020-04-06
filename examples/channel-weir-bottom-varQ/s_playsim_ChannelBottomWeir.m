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

if ~exist ('HZ_evl', 'var')
  %% Global parameters
  dataFolder  = "data";
  exp_nb      = 5;

  %% Read outputs from files
  outputsFolder = fullfile (dataFolder, 'Outputs_01');

  fname     = @(s) fullfile (outputsFolder, s);
  fsuf      = @(f,s) sprintf ("%s_%02d", f, s);
  data_init = load (fname ('huz_initial.dat'));
  data_evl  = load (fname ('huz_evolution.dat'));

  paramsfile = fullfile (dataFolder, 'Inputs', strcat (fsuf ('parameters', exp_nb), '.txt'));
  params = read_params (paramsfile);

  %% Get topography and final state free surface
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

    hz_evl(:,t)     = data_evl(span,6);
    fr_evl(:,t)     = data_evl(span,9);
    HZ_evl(:,:,t)   = dataconvert ('octave', [Nx Ny], hz_evl(:,t));
    Fr_evl(:,:,t)   = dataconvert ('octave', [Nx Ny], fr_evl(:,t));
  end%for
end%if

az = 70;
el = 45;

t_str = @(t) sprintf ("t = %d s", t);
figure(1,"position",get(0,"screensize"))
ZZ = HZ_evl - Z;
ZZ(ZZ==0) = NA;
ZZ = ZZ + Z;
view (az, el);
g3 = surf (X, Y, ZZ(:,:,1), 'edgecolor', 'none');
shading interp
colormap(ocean(64));
t1 = text (10, -20, 10, t_str (1), 'fontsize', 15);
hold on
mesh (X, Y, Z, 'facecolor', 'w','edgecolor','k');
hold off
axis equal
grid on;

for t = 2:tsteps
  set (g3, 'zdata', ZZ(:,:,t));
  set (t1, 'string', t_str (t));
  pause(0.3);
end%for

close all
