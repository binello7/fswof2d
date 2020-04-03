%% Copyright (C) YYYY Sebastiano Rusca
%%
%% This program is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 3 of the License, or
%% (at your option) any later version.
%%
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public License
%% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%%
%% Author: Sebastiano Rusca <sebastiano.rusca@gmail.com>
%% Created: 2018-01-02

pkg load fswof2d
pkg load linear-algebra

%% Global parameters
dataFolder  = 'data';

%% Study variable
% Variables to change during the study
nQ        = 25;
Qin       = linspace (-0.2, -5, nQ);

% Order to explore extremes
tmp = zeros (1,nQ);
tmp(1:2:end) = Qin(1:ceil(end/2));
tmp(2:2:end) = fliplr (Qin)(1:ceil(end/2)-1);
Qin = tmp;
clear tmp

%% Generate the topography
%  First the cross-section shape, which will be a "rectangle" 2.5 m wide
B = 2.5;
Nx = 50;
x = linspace (0, B, Nx+1);
xc = node2center (x);
z = zeros (1, Nx);
z(1) = z(end) = 2;

%  Extrude the cross-section along the y-axis
Ly = 40;
Ny = 80;
y = linspace (0, Ly, Ny+1);
yc = node2center (y);
[XX YY ZZc] = extrude_csec (xc, yc, z);


%  Rotate the cross-section by the chosen slope value alpha
alpha = -10;
rx_alpha = rotv ([1 0 0], deg2rad (alpha));
np = rx_alpha * [0 0 1].';
ZZp = -(np(1)*XX + np(2)*YY) / np(3);
ZZ = ZZp + ZZc;


%% Generate initial conditions for h, u and v can be set to 0
HH = ones (Ny, Nx);
UU = zeros (Ny, Nx);
VV = zeros (Ny, Nx);
HH(:,1) = HH(:,end) = 0;
HZ = ZZ + HH;

%  Generate weir at the end of the channel
wh = 1;
ZZ(1,:) = wh;

figure ('visible', 'off')
surf (XX, YY, ZZ, 'facecolor', 'k');
hold on
mesh (XX, YY, HZ, 'edgecolor', 'b');
hold off
print study-setup.png

%% Generate needed inputs files and folders for FullSWOF_2D
%  Generate Folders
inputsFolder  = fullfile (dataFolder, 'Inputs');
outputsFolder = fullfile (dataFolder, 'Outputs');

if !exist (inputsFolder, 'dir')
  mkdir (inputsFolder);
end%if

fname = @(s) fullfile (inputsFolder, s);

%  Convert the data to the FullSWOF_2D format
[X Y Z H U V] = dataconvert ('fswof2d', XX, YY, ZZ, HH, UU, VV);

%  Write the topography to the file
topo2file (X, Y, Z, fname ('topography.dat'));

%  Write the initial conditions to the file
huv2file (X, Y, H, U, V, fname ('huv_init.dat'));

% Save the experiment discharge values
save (fname ('Qin_values.dat'), 'Qin');

%  Write the simulation parameters to a file
sim_duration    = 100;
saved_timesteps = 100;
top_boundary    = 5;
top_Q           = -0.3;
top_h           = 1;
bot_boundary    = 3;
p = params2file ('xCells', Nx, 'yCells', Ny, 'xLength', B, ...
            'yLength', Ly, 'SimDuration', sim_duration, ...
            'SavedStates', saved_timesteps, 'BotBoundCond', bot_boundary, ...
            'TopBoundCond', top_boundary, 'TopImposedQ', top_Q, ...
            'TopimposedH', top_h);

ns = floor (log10 (nQ)) + 1;
suffix_fmt = sprintf ("_%%0%dd", ns);

for i=1:nQ
  % update Q
  p.TopImposedQ = Qin(i);

  % update output suffix
  suffix = sprintf (suffix_fmt, i);
  p.OutputsSuffix = suffix;

  % update filename
  pfile = fname (sprintf ("parameters%s.txt", suffix));
  p.ParametersFile = pfile;

  printf ("Writing file %s\n", pfile); fflush (stdout);
  params2file (p);

  outputsFolder = fullfile (dataFolder, sprintf("Outputs%s", suffix));
  if !exist (outputsFolder, 'dir')
    mkdir (outputsFolder);
  end%if
end%for

%% Write bash script to run study
bfile = fullfile ("run.sh");
printf ("Writing Bash script to file %s\n", bfile); fflush (stdout);
timetxt = strftime ("%Y-%m-%d %H:%M:%S", localtime (time ()));
bsh = {
'%!/bin/bash', ...
sprintf("%% Automatically generated on %s\n", timetxt), ...
sprintf("for i in {1..%d}; do", nQ), ...
sprintf("  id=`printf %s $i`", suffix_fmt), ...
'  nohup fswof2d -f parameters$id.txt &', ...
'  if(( ($i % $(nproc)) == 0)); then wait; fi', ...
'done'
};
bsh = strjoin (bsh, "\n");
fid = fopen (bfile, "wt");
fputs (fid, bsh);
fclose (fid);
