%% Copyright (C) 2017 Sebastiano Rusca
%% Copyright (C) 2017 Juan Pablo Carbajal
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

%% Author: Juan Pablo Carbajal <ajuanpi+dev@gmail.com>
%% Created: 2017-12-11

close all
pkg load fswof2d

%% METADATA
init   = 'huz_initial.dat';
evl    = 'huz_evolution.dat';
fin    = 'huz_final.dat';
an_pdf = 'animation.pdf';
an_gif = 'animation.gif';

%% WRITE STUDY FOLDER
dataFolder    = 'data';
framesFolder  = 'frames';
outputsName   = 'Outputs';

outputsFolder = fullfile (dataFolder, outputsName);

finit  = fullfile (outputsFolder, init);
fevl   = fullfile (outputsFolder, evl);
ffin   = fullfile (outputsFolder, fin);

mkdir (dataFolder);
mkdir (framesFolder);

paramsfile = fullfile (dataFolder, 'Inputs', 'parameters.txt');
params = read_params (paramsfile);

% SIMULATION PARAMETERS
Nxcell = params.Nxcell;
Nycell = params.Nycell;
nbt = params.nbtimes;

init_data = load (finit);
evl_data  = load (fevl);
fin_data  = load (ffin);

x = init_data(:,1);
y = init_data(:,2);
z = init_data(:,7);

hz_init = init_data(:,6);
hz_fin  = fin_data(:,6);

[X Y Z]             = dataconvert ('octave', [Nxcell Nycell], x, y, z);
[tmp1 tmp2 HZ_init] = dataconvert ('octave', [Nxcell Nycell], x, y, hz_init);
[tmp1 tmp2 HZ_fin]  = dataconvert ('octave', [Nxcell Nycell], x, y, hz_fin);

for t = 1:nbt
  idx_1 = 1 + (t - 1) * Nxcell * Nycell;
  idx_2 = t * Nxcell * Nycell;
  span = idx_1:idx_2;

  hz_evl(:,t)  = evl_data(span, 6);
  [tmp1 tmp2 HZ_evl(:,:,t)]  = ...
    dataconvert ('octave', [Nxcell Nycell], x, y, hz_evl(:,t));
end%for

az = 70;
el = 45;

% Preparing the first frame to save
winX    = 200;
winY    = 600;
width   = 560;
height  = 421;
fig = figure ('position',[winX,winY,width,height], 'visible', 'off');
zz = HZ_evl - Z;
zz(zz==0) = NA;
colormap jet
g3 = surf (X, Y, zz(:,:,1), 'edgecolor', 'none');
shading interp
hold on
mesh (X, Y, Z, 'facecolor', 'w','edgecolor','k');
hold off
%colormap(ocean(64));
axis ([min(X(:)) max(X(:)) min(Y(:)) max(Y(:)) min(Z(:)) max(Z(:))])
ht=title('1');
%axis square
grid on;

view (az, el);

quality = '-r200';
frname = fullfile (framesFolder, sprintf ('frame-%04d.png',1));
print ('-dpng', quality, frname);


for t = 2:nbt
  set(g3, 'zdata', zz(:,:,t));
  set(ht,'string',sprintf("%d",t));
  frname = fullfile (framesFolder, sprintf ('frame-%04d.png',t));
  print ('-dpng', quality, frname);
end%for
