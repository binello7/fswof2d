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

close all
#-------------------------------------------------------------------------------
t   = 1;
nbt = 60;
y1  = 20;
y2  = 32;
#-------------------------------------------------------------------------------
Nxcell = 250;
Nycell = 50;
#-------------------------------------------------------------------------------

## METADATA
studyName   = "Channel_2lvl";
init = 'huz_initial.dat';
evl  = 'huz_evolution.dat';
fin  = 'huz_final.dat';

## WRITE STUDY FOLDER
dataName    = 'data';
outputsName = 'Outputs';
frm = 'frames';

studyFolder   = fullfile (dataName, studyName);
outputsFolder = fullfile (studyFolder, outputsName);

finit    = fullfile (outputsFolder, init);
fevl     = fullfile (outputsFolder, evl);
ffin     = fullfile (outputsFolder, fin);
fframes  = fullfile (studyFolder, frm);

mkdir (studyFolder, frm);

init_data = load (finit);
evl_data  = load (fevl);
fin_data  = load (ffin);

x = init_data(:,1);
y = init_data(:,2);
z = init_data(:,7);

hz_init = init_data(:,6);
hz_fin  = fin_data(:,6);

[X Y Z]             = dataconvert (x, y, z, 'octave', [Nxcell Nycell]);
[tmp1 tmp2 HZ_init] = dataconvert (x, y, hz_init, 'octave', [Nxcell Nycell]);
[tmp1 tmp2 HZ_fin]  = dataconvert (x, y, hz_fin, 'octave', [Nxcell Nycell]);


[X Y Z]             = dataconvert (x, y, z, 'octave', [Nxcell Nycell]);
[tmp1 tmp2 HZ_init] = dataconvert (x, y, hz_init, 'octave', [Nxcell Nycell]);
[tmp1 tmp2 HZ_fin]  = dataconvert (x, y, hz_fin, 'octave', [Nxcell Nycell]);

for t = 1:nbt
  idx_1 = 1 + (t - 1) * Nxcell * Nycell;
  idx_2 = t * Nxcell * Nycell;
  span = idx_1:idx_2;

  hz_evl(:,t)  = evl_data(span, 6);
  [tmp1 tmp2 HZ_evl(:,:,t)]  = ...
    dataconvert (x, y, hz_evl(:,t), 'octave', [Nxcell Nycell]);

  u_evl(:,t) = evl_data(span, 4);
  v_evl(:,t) = evl_data(span, 5);
  [tmp1 tmp2 U_evl(:,:,t)]  = ...
    dataconvert (x, y, u_evl(:,t), 'octave', [Nxcell Nycell]);
  [tmp1 tmp2 V_evl(:,:,t)]  = ...
    dataconvert (x, y, v_evl(:,t), 'octave', [Nxcell Nycell]);
endfor


az = 230;
el = 20;

figure
g1 = mesh (X, Y, HZ_init, 'FaceColor', 'white');
axis square
colormap ocean;
grid on;
view (az, el);

figure
g2 = mesh (X, Y, HZ_fin, 'facecolor', 'white');
axis square
grid on;
colormap ocean;
view (az, el);

figure
plot_topo (X, Y, Z);
print -deps -color topography.eps

## Preparing the first frame to save
#fig = figure;
#g3 = mesh (X, Y, HZ_evl(:,:,1), 'facecolor', 'none');
#axis square
#grid on;
#colormap ocean;
#view (az, el);
#fprintf('%d ',1)     # frame index
#frname = fullfile (fframes, sprintf ('frame-%04d.png',1));
#print ('-dpng', '-r300', frname);

## Next frames: update of the old plot
#for t = 2:nbt
#  set (g3, 'zdata', HZ_evl(:,:,t));
#  fprintf ('%d ',t)     # frame index
#  frname = fullfile (fframes, sprintf ('frame-%04d.png',t));
#  print ('-dpng', '-r300', frname);
#  # saves frame as png with 300 dpi resolution
#endfor

#close (fig);
#system('ffmpeg -f image2 -i data/Channel_2lvl/frames/frame-%04d.png -vcodec mpeg4 data/Channel_2lvl/const_depth.mp4');
#disp('');
#bidon=input('Frames created ; press <enter> to start assembling');
#disp('Video assembled, folder ''frames'' can be erased!')





## Preparing the first frame to save
#fig = figure;
#g4 = quiver (X, Y, U_evl(:,:,1), V_evl(:,:,1), 'color', 'r');
#set (g4, 'maxheadsize', 0.1);
#axis ([0 max(x) y1 y2]);
#grid on;
#printf('%d ',1)     # frame index
#frname = fullfile (fframes, sprintf ('frame-%04d.png',1));
#print ('-dpng', '-r300', frname);

## Next frames: update of the old plot
#for t = 2:nbt
#  set (g4, 'udata', U_evl(:,:,t), 'vdata', V_evl(:,:,t));
#  printf ('%d ',t)     # frame index
#  frname = fullfile (fframes, sprintf ('frame-%04d.png',t));
#  print ('-dpng', '-r300', frname);
#  # saves frame as png with 300 dpi resolution
#endfor

#close (fig);
#system('ffmpeg -f image2 -i data/Channel_2lvl/frames/frame-%04d.png -vcodec mpeg4 data/Channel_2lvl/vel_field.mp4');
#disp('');
#bidon=input('Frames created ; press <enter> to start assembling');
#disp('Video assembled, folder ''frames'' can be erased!')









