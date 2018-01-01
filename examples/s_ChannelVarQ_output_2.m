## Copyright (C) 2017 Sebastiano Rusca
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

if ~exist ('HZ_evl', 'var')
  ## Global parameters
  #
  suff        = 2;
  suff_fmt    = '_%02d';
  dataFolder  = "data";
  studyName   = "ChannelVarQ_2";
  outputsName = strcat ("Outputs", sprintf (suff_fmt, suff));

  ## Read outputs from files
  #
  outputsFolder = fullfile (dataFolder, studyName, outputsName);
  fname         = @(s) fullfile (outputsFolder, s);

  data_init = load (fname ('huz_initial.dat'));
  data_fin  = load (fname ('huz_final.dat'));
  data_evl  = load (fname ('huz_evolution.dat'));

  paramsfile = fullfile (dataFolder, studyName, 'Inputs', 'parameters_02.txt');

  params = read_params (paramsfile);

  ## Get topography and final state free surface
  # Topography in FullSWOF_2D format
  x_swf = data_init(:,1);
  y_swf = data_init(:,2);
  z_swf = data_init(:,7);

  # Convert the data from 'fswof2d' to 'octave'
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
  endfor
endif

az = 70;
el = 45;

figure (1)
g1 = mesh (X, Y, HZ_evl(:,:,1), 'FaceColor', 'white');
colormap ocean;
grid on;
view (az, el);

figure (2)
g2 = mesh (X, Y, HZ_evl(:,:,end), 'facecolor', 'white');
grid on;
colormap ocean;
view (az, el);


figure(3,"position",get(0,"screensize"))
ZZ = HZ_evl - Z;
ZZ(ZZ==0) = NA;
ZZ = ZZ + Z;
view (az, el);
g3 = surf (X, Y, ZZ(:,:,1), 'edgecolor', 'none');
shading interp
hold on
mesh (X, Y, Z, 'facecolor', 'w','edgecolor','k');
hold off
#colormap jet
colormap(ocean(64));
axis ([min(X(:)) max(X(:)) min(Y(:)) max(Y(:)) min(Z(:)) max(Z(:))])
#axis square
grid on;

sv = false;
# Save first frame if 'sv' is active
if sv
  framesFolder = fullfile (dataFolder, studyName, 'frames');
  mkdir (framesFolder);
  frame = fullfile (framesFolder, sprintf ('frame-%04d.png', 1));
  print ('-dpng', '-r300', '-S560,421', frame);
endif

for t = 2:tsteps
  set(g3, 'zdata', ZZ(:,:,t));
  pause(0.5);
  if sv
    #saves each frame if 'sv' is active
    frame = fullfile (framesFolder, sprintf ('frame-%04d.png', t));
    print ('-dpng', '-r300', '-S560,421', frame);
  endif
endfor

if sv
  close (3)
  system ('ffmpeg -f image2 -i data/ChannelConstQ_small/frames/frame-%04d.png -vcodec mpeg4 data/ChannelConstQ_small/animation.mp4');
  bidon=input ('Frames created ; press <enter> to start assembling');
  disp ('Video assembled, folder ''frames'' can be erased!')
endif



