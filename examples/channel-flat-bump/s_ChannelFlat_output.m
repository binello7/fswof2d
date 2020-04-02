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
if ~exist ('HZ_evl','var')
  #-------------------------------------------------------------------------------
  t   = 1;
  nbt = 60;
  #-------------------------------------------------------------------------------
  Nxcell = 250;
  Nycell = 50;
  #-------------------------------------------------------------------------------

  ## METADATA
  studyName   = "Channel_Flat";
  init   = 'huz_initial.dat';
  evl    = 'huz_evolution.dat';
  fin    = 'huz_final.dat';
  an_pdf = 'animation.pdf';
  an_gif = 'animation.gif';

  ## WRITE STUDY FOLDER
  dataName    = 'data';
  outputsName = 'Outputs';

  studyFolder   = fullfile (dataName, studyName);
  outputsFolder = fullfile (studyFolder, outputsName);
  frm = 'frames';

  finit  = fullfile (outputsFolder, init);
  fevl   = fullfile (outputsFolder, evl);
  ffin   = fullfile (outputsFolder, fin);
  fan_pdf = fullfile (studyFolder, an_pdf);
  fan_gif = fullfile (studyFolder, an_gif);
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

  for t = 1:nbt
    idx_1 = 1 + (t - 1) * Nxcell * Nycell;
    idx_2 = t * Nxcell * Nycell;
    span = idx_1:idx_2;

    hz_evl(:,t)  = evl_data(span, 6);
    [tmp1 tmp2 HZ_evl(:,:,t)]  = ...
      dataconvert (x, y, hz_evl(:,t), 'octave', [Nxcell Nycell]);
  endfor
endif

az = 70;
el = 45;

figure(1)
g1 = mesh (X, Y, HZ_init, 'FaceColor', 'white');
colormap ocean;
grid on;
view (az, el);

figure(2)
g2 = mesh (X, Y, HZ_fin, 'facecolor', 'white');
grid on;
colormap ocean;
view (az, el);



# Preparing the first frame to save
winX    = 200; 
winY    = 600;
width   = 560;
height  = 421;
fig = figure ('Position',[winX,winY,width,height]);
zz = HZ_evl - Z;
zz(zz=0) = NA;
colormap jet
g3 = surf (X, Y, zz(:,:,1), 'edgecolor', 'none');
shading interp
hold on
mesh (X, Y, Z, 'facecolor', 'w','edgecolor','k');
hold off
%colormap(ocean(64));
axis ([min(X(:)) max(X(:)) min(Y(:)) max(Y(:)) min(Z(:)) max(Z(:))])
#axis square
grid on;

view (az, el);
%fprintf('%d ',1)     # frame index
%frname = fullfile (fframes, sprintf ('frame-%04d.png',1));
%print ('-dpng', '-r300', frname);

ht=title(sprintf("%d",t(1)));
for t = 2:nbt
  set(g3, 'zdata', zz(:,:,t));
  set(ht,'string',sprintf("%d",t));
  %fprintf('%d ',t)     # frame index
  %frname = fullfile (fframes, sprintf ('frame-%04d.png',t));
  %print ('-dpng', '-r300', frname);
  # saves frame as png with 80 dpi resolution
  pause(0.1);
endfor

%close (fig);
%system('ffmpeg -f image2 -i data/Channel_Flat/frames/frame-%04d.png -vcodec mpeg4 data/Channel_Flat/bump.mp4');
%disp('');
%bidon=input('Frames created ; press <enter> to start assembling');
% sous Ubuntu nécessite package "ffmpeg"
% puis package "gstreamer0.10-ffmpeg" pour visualiser vidéo sous Totem
%disp('Video assembled, folder ''frames'' can be erased!')


#im = imread (fan_pdf, "Index", "all");
#imwrite (im, fan_gif, "DelayTime", .5)



