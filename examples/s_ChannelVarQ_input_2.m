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

## Author: Sebastiano Rusca
## Created: 2017-12-30

## Input files for ChannelVarQ study
# We generate all the inputs files needed to study the response of a given
# topography to different values of the upstream input flow |Q|.
#
# Since |Q| is defined only in the parameters file, this is the only file that
# needs to be generated several times.
# The values that we are going to use are defined in the Qin_values variable
# stored in the file |studyFolder/Qin_values.dat|

pkg load fswof2d

## Global parameters
#
dataFolder  = 'data';
studyName   = 'ChannelVarQ_2';

## Study variable
# These are the variables that we will change in this study
nQ        = 25;
Qin       = linspace (10, 100, nQ);
# Order to explore extremes
tmp = zeros (1,nQ);
tmp(1:2:end) = Qin(1:ceil(end/2));
tmp(2:2:end) = fliplr (Qin)(1:ceil(end/2)-1);
Qin = tmp;
clear tmp

## Generate topography
# Define variables needed for the parametrization of the topography.

##
# Channel geometry
Ly    = 100;   # Channel length
alpha = 5;    # Slope along the length in degrees

##
# Topography mesh parameters
Nxcell = 40;
Nycell = 200;
# mesh nodes
y             = linspace (0, Ly, Nycell + 1).';
y             = node2center (y);
[x z p xi zi] = csec_channel2lvlsym (Nxcell, "Embankment", 2, ...
                "Plain", 5, "RiverBank", 1, "riverbed", 4, ...
                "bankheight", 1, "embankmentheight", 1);
xc            = node2center (x);
z             = interp1 (x, z, xc);
x             = xc; clear xc;
[X Y Zc]      = extrude_csec (x, y, z);
# Define a plane with the given slope
nf = @(d1,d2) [cosd(d2).*sind(d1) sind(d2).*sind(d1) cosd(d1)];
np = nf (alpha, 0);
Zp = (np(1) * Y + np(2) * X ) ./ np(3);
# Total surface
Z = Zc + Zp;

## Generate initial conditions
# Define variables needed for the parametrization of the initial condition.

# The inital conditons is 0.5 meters of water inside the channel
zw0 = 0.5; # free surface at 0.5 meters
# mask bed of channel
bd_mask = z < sqrt (eps);
# mask banks of channel
bk_mask = z < zw0 & !bd_mask;
# mask whole channel
ch_mask = bd_mask | bk_mask;

zw0          = zw0 * ch_mask;
h0          = zw0 - z;
h0(h0 < 0) = 0;

H0 = extrude_csec (x, y, h0);
U0 = V0 = zeros (size (X));

## Write out data files
#

# Convert to FullSWOF_2D format
data = {X,Y,Z,H0,U0,V0};
[x_swf y_swf z_swf ...
 h_swf u_swf v_swf] = dataconvert ('fswof2d', data{:});

studyFolder   = fullfile (dataFolder, studyName);
inputsFolder  = fullfile (studyFolder, 'Inputs');
if !exist (inputsFolder, 'dir')
  mkdir (inputsFolder);
endif
fname         = @(s) fullfile (inputsFolder, s);
# write out topography
datatopo = {x_swf, y_swf, z_swf};
topo2file (datatopo{:}, fname ('topography.dat'));
# write out IC
datahuv = {x_swf, y_swf, h_swf, u_swf, v_swf};
huv2file (datahuv{:}, fname ('huv_init.dat'));
# Write out study variables
save (fname ('Qin_values.dat'), 'Qin');

## Write out parameters files
#
Lx        = (p.Embankment + p.Plain + p.RiverBank) * 2 + p.RiverBed;
simT      = 150;
nbT       = 50;
topbound  = 5;
botbound  = 3;
# template for parameters
params    = params2file (
            "xCells", Nxcell, ...
            "yCells", Nycell, ...
            "xLength", Lx, ...
            "yLength", Ly, ...
            "SimTime", simT, ...
            "SavedTimes", nbT, ...
            "TopImposedQ", NA, ...
            "BotBoundCond", botbound, ...
            "TopBoundCond", topbound
            );
[~,j] = ismember ("TopImposedQ", params(1:2:end));
if !j; error ("Option not found"); endif

# left padding with zeros
ns = floor (log10 (nQ)) + 1;
suffix_fmt = sprintf ("_%%0%dd", ns);
for i=1:nQ
  suffix      = sprintf(suffix_fmt, i);
  pfile       = fname (sprintf ("parameters%s.txt", suffix));
  printf ("Writing file %s\n", pfile); fflush (stdout);

  params{j+1} = Qin(i);
  params2file (params{:}, ...
               'ParamsFile', pfile, ...
               'OutputsSuffix', suffix);

  outputsFolder = fullfile (studyFolder, sprintf("Outputs%s", suffix));
  if !exist (outputsFolder, 'dir')
    mkdir (outputsFolder);
  endif
endfor

## Write bash script to run study
bfile = fullfile (studyFolder, "run.sh");
printf ("Writing Bash script to file %s\n", bfile); fflush (stdout);
timetxt = strftime ("%Y-%m-%d %H:%M:%S", localtime (time ()));
bsh = {
'#!/bin/bash', ...
sprintf("## Automatically generated on %s\n", timetxt), ...
sprintf("for i in {1..%d}; do", nQ), ...
sprintf("  id=`printf %s $i`", suffix_fmt), ...
'  nohup fswof2d -f parameters$id &', ...
'  if(( ($i % $(nproc)) == 0)); then wait; fi', ...
'done'
};
bsh = strjoin (bsh, "\n");
fid = fopen (bfile, "wt");
fputs (fid, bsh);
fclose (fid);
