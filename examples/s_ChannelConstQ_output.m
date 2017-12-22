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
## Created: 2017-12-11

pkg load fswof2d

studyName    = "Channel_ConstQ";
inputsFolder = fullfile (studyName, 'Inputs');
inpfname     = @(s) fullfile (inputsFolder, s);
params       = read_params (inpfname('parameters.txt'));


#if ~exist ('x_swf')
#  ## Files
#  #
#  topofile    = "topography.dat";
#  huvfile     = "huv_init.dat";
#  paramfile   = "parameters.txt";
#  init        = 'huz_initial.dat';
#  evl         = 'huz_evolution.dat';
#  fin         = 'huz_final.dat';
##-------------------------------------------------------------------------------
#  ## Folders
#  #
#  studyName     = "Channel_ConstQ";
#  dataName      = 'data';
#  inputsName    = 'Inputs';
#  outputsName   = 'Outputs';
#  framesName    = 'frames';
##-------------------------------------------------------------------------------
#  ## Channel geometry
#  #
#  Nxcell = 250;
#  Nycell = 140;
#  L      = 250;
#  simT   = 150;
#  nbT    = 50;
#  Qin    = 1000;
#  alpha  = 10; # slope in degrees
##-------------------------------------------------------------------------------
#  studyFolder   = fullfile (dataName, studyName);
#  mkdir (dataName, studyName);
#  inputsFolder  = fullfile (studyFolder, inputsName);
#  mkdir (studyFolder, inputsName);
#  outputsFolder = fullfile (studyFolder, outputsName);
#  mkdir (studyFolder, outputsName);
#  framesFolder  = fullfile (studyFolder, framesName);
#  finit  = fullfile (outputsFolder, init);
#  fevl   = fullfile (outputsFolder, evl);
#  ffin   = fullfile (outputsFolder, fin);

#  ftopo  = fullfile (inputsFolder, topofile);
#  fhuv   = fullfile (inputsFolder, huvfile);
#  fparam = fullfile (inputsFolder, paramfile);

#  [y z p yi zi] = csec_channel2lvlsym (Nycell);
#  l = (p.Embankment + p.Plain + p.RiverBank)*2 + p.RiverBed;

#  x = [0:L/Nxcell:L].';
#  [X Y Zc] = extrude_csec (x, y, z);

#  # Here is the slope surface
#  nf = @(d1,d2) [cosd(d2).*sind(d1) sind(d2).*sind(d1) cosd(d1)];
#  np = nf (alpha, 0);
#  Zp = (np(1) * X + np(2) * Y ) ./ np(3);

#  Z = Zc + Zp;
##-------------------------------------------------------------------------------
#  ## Write topography to file
#  #
#  [x_swf y_swf z_swf] = dataconvert (X, Y, Z, 'fswof2d', [Nxcell Nycell]);
#  topo2file (x_swf, y_swf, z_swf, ftopo);

#  ## Write |huv_init| to file
#  #
#  h0 = 2;
#  u0 = 0;
#  v0 = 0;

#  n = length (x_swf);

#  h = zeros (n, 1);
#  u = zeros (n, 1);
#  v = zeros (n, 1);

#  y1 = (yi(3) + yi(4)) /2;
#  y2 = (yi(5) + yi(6)) /2;
#  h(y_swf > y1 & y_swf < y2 & x_swf > x(1) & x_swf < x(end)) = h0;

#  huv2file (x_swf, y_swf, h, u, v, fhuv);

#  ## Initialize parameters
#  #
#  init_params ("ParamsFile", fparam, ...
#               "xCells", Nxcell, ...
#               "yCells", Nycell, ...
#               "xLength", L, ...
#               "yLength", l, ...
#               "SimTime", simT, ...
#               "SavedTimes", nbT, ...
#               "RimposedQ", Qin);
#endif

#if exist (fevl, 'file')

#  close all
#  if ~exist ('HZ_evl','var')

#    init_data = load (finit);
#    evl_data  = load (fevl);
#    fin_data  = load (ffin);

#    hz_init = init_data(:,6);
#    hz_fin  = fin_data(:,6);

#    [~, ~, HZ_init] = dataconvert (x_swf, y_swf, hz_init, 'octave', ...
#    [Nxcell Nycell]);
#    [~, ~, HZ_fin]  = dataconvert (x_swf, y_swf, hz_fin, 'octave', ...
#    [Nxcell Nycell]);

#    for t = 1:nbT
#      idx_1 = 1 + (t - 1) * Nxcell * Nycell;
#      idx_2 = t * Nxcell * Nycell;
#      span = idx_1:idx_2;

#      hz_evl(:,t)  = evl_data(span, 6);
#      [~, ~, HZ_evl(:,:,t)]  = ...
#      dataconvert (x_swf, y_swf, hz_evl(:,t), 'octave', [Nxcell Nycell]);
#    endfor
#  endif

#  az = 70;
#  el = 45;

#  figure (1)
#  g1 = mesh (X, Y, HZ_init, 'FaceColor', 'white');
#  colormap ocean;
#  grid on;
#  view (az, el);

#  figure (2)
#  g2 = mesh (X, Y, HZ_fin, 'facecolor', 'white');
#  grid on;
#  colormap ocean;
#  view (az, el);
##-------------------------------------------------------------------------------

#  # Preparing the first frame to save
#  figure(3,"position",get(0,"screensize"))
#  ZZ = HZ_evl - Z;
#  ZZ(ZZ==0) = NA;
#  ZZ = ZZ + Z;
#  colormap jet
#  view (az, el);

#  g3 = surf (X, Y, ZZ(:,:,1), 'edgecolor', 'none');
#  ht = title (sprintf ("%d",1));
#  shading interp
#  hold on
#  mesh (X, Y, Z, 'facecolor', 'w','edgecolor','k');
#  hold off
#  #colormap(ocean(64));
#  axis ([min(X(:)) max(X(:)) min(Y(:)) max(Y(:)) min(Z(:)) max(Z(:))])
#  #axis square
#  grid on;
#  #  mkdir (studyFolder, framesName);
#  #  frname = fullfile (framesFolder, sprintf ('frame-%04d.png',1));
#  #  print ('-dpng', '-r300', '-S560,421', frname);

#  for t = 2:nbT
#    set(g3, 'zdata', ZZ(:,:,t));
#    set(ht,'string',sprintf("%d",t));

#    # saves frame as png with 80 dpi resolution
#    #frname = fullfile (fframes, sprintf ('frame-%04d.png',t));
#    #print ('-dpng', '-r300', frname);
#    pause(0.5);
#  endfor

#  #%close (fig);
#  #%system('ffmpeg -f image2 -i data/Channel_Flat/frames/frame-%04d.png -vcodec mpeg4 data/Channel_Flat/bump.mp4');
#  #%disp('');
#  #%bidon=input('Frames created ; press <enter> to start assembling');
#  #%disp('Video assembled, folder ''frames'' can be erased!')

#endif
