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

% future 
% pkg load fswf2d

## METADATA
studyName   = "Channel_2lvl";
topofile    = "topography.dat";
huvfile     = "huv_initial.dat";
paramfile   = "parameters.txt";

## WRITE STUDY FOLDER
dataName    = 'data';
inputsName  = 'Inputs';
outputsName = 'Outputs';

studyFolder   = fullfile (dataName, studyName);
inputsFolder  = fullfile (studyFolder, inputsName);
outputsFolder = fullfile (studyFolder, outputsName);

mkdir (dataName, studyName);
mkdir (studyFolder, inputsName);
mkdir (studyFolder, outputsName);

ftopo  = fullfile (inputsFolder, topofile);
fhuv   = fullfile (inputsFolder, huvfile);
fparam = fullfile (inputsFolder, paramfile);

## CHANNEL GEOMETRY
Er = 7; # =El
Pr = 10; # =Pl
rb = 4;  # =lb
B  = 8;
H1 = 3;
H2 = 7;
% TOT = 50m

Lx = 250;
Ly = (Er + Pr + rb) * 2 + B;

dx = 1;
dy = 1;

L = Lx;
l = Ly;

Nxcell              = Lx / dx;
Nycell              = Ly / dy;

## Simulation Parameters
T                   = 30;
nbtimes             = 60;

scheme_type         = 1;
dtfix               = 0.01;
cflfix              = 0.7;

Lbound              = 3;           # x = 0
left_imp_q          = 0.0005;
left_imp_h          = 0.005;

Rbound              = 2;           # x = xmax
right_imp_q         = 0.0005;
right_imp_h         = 0.005;

Bbound              = 2;           # y = 0
bottom_imp_q        = 0.0005;
bottom_imp_h        = 0.005;

Tbound              = 2;           # y = ymax
top_imp_q           = 0.0005;
top_imp_h           = 0.005;

fric_init           = 2;
fric                = 1;
fric_NF             = "friction_init.dat";
friccoef            = 0.02;

flux                = 5;

order               = 2;

rec                 = 1;
amortENO            = 0.25;
modifENO            = 0.9;
lim                 = 1;

inf                 = 0;
zcrust_init         = 2;
zcrustcoef          = 1;
zcrust_NF           = "";

Kc_init             = 2;
Kccoef              = 1.8e-6;
Kc_NF               = "";

Ks_init             = 2;
Kscoef              = 1.8e-6;
Ks_NF               = "";

dtheta_init         = 2;
dthetacoef          = 0.254;
dtheta_NF           = "";

Psi_init            = 2;
Psicoef             = 0.167;
Psi_NF              = "";

imax_init           = 2;
imaxcoef            = 1.7e-4;
imax_NF             = "";

topo                = 1;
topo_NF             = topofile;

huv_init            = 1;
huv_NF              = huvfile;

rain                = 0;
rain_NF             = "rain.txt";

suffix_o            = "";

output_f            = 1;

# Define mesh points for every section
n = struct (
"Embankment", Er / dy + 1, ...
"Plain", Pr / dy + 1, ...
"RiverBank", rb / dy + 1, ...
"RiverBed",B / dy + 1
);

[y z p]  = csec_channel2lvlsym (n, "Embankment", Er, "Plain", Pr, 
                                "RiverBank", rb, "RiverBed", B, 
                                "BankHeight", H1, "EmbankmentHeight", H2);

y(Nycell + 1:Nycell:end) = [];
z(Nycell + 1:Nycell:end) = [];

y += 0.5 * dy;

x        = 0.5*dx:dx:Lx-0.5*dx;
[X Y Zc] = extrude_csec (x, y, z);

# Here is the slope surface
alpha = 5; # slope in degrees
nf    = @(d1,d2) [cosd(d2).*sind(d1) sind(d2).*sind(d1) cosd(d1)];
np    = nf (alpha, 0);
Zp    = (np(1) * X + np(2) * Y ) ./ np(3);

Z = Zc + Zp;

## WRITE TOPOGRAPHY TO FILE
[x_swf y_swf z_swf] = dataconvert (X, Y, Z, 'fswof2d', [Nxcell Nycell]);
topo2file (x_swf, y_swf, z_swf, ftopo);

## WRITE HUV_INIT TO FILE
h0 = 1.5;
u0 = 0;
v0 = 0;

huv2file (x_swf, 

## INITIALIZE PARAMETERS
init_params ("ParamsFile", fparam, ...
             "xNodes", Nxcell, ...
             "yNodes", Nycell, ...
             "SimTime", T, ...
             "SavedTimes", nbtimes, ...
             "SchemeType", scheme_type, ...
             "TimeStep", dtfix, ...
             "CFLval", cflfix, ...
             "xLength", L, ...
             "yLength", l, ...
             "LBoundCond", Lbound, ...
             "LimposedQ", left_imp_q, ...
             "LimposedH", left_imp_h, ...
             "RBoundCond", Rbound, ...
             "RimposedQ", right_imp_q, ...
             "RimposedH", right_imp_h, ...
             "TopBoundCond", Tbound, ...
             "TopimposedQ", top_imp_q, ...
             "TopimposedH", top_imp_h, ...
             "BotBoundCond", Bbound, ...
             "BotimposedQ", bottom_imp_q, ...
             "BotimposedH", bottom_imp_h, ...
             "FrictInit", fric_init, ...
             "FrictLaw", fric, ...
             "FrictFile", fric_NF, ...
             "FrictCoef", friccoef, ...
             "NumFlux", flux, ...
             "SchemeOrder", order, ...
             "Reconstruction", rec, ...
             "AmortENO", amortENO, ...
             "ModifENO", modifENO, ...
             "Limiter", lim, ...
             "InfModel", inf, ...
             "CrustThickness", zcrust_init, ...
             "CrustCoef", zcrustcoef, ...
             "CrustFile", zcrust_NF, ...
             "HydrCondCrustInit", Kc_init, ...
             "HydrCondCrustCoef", Kccoef, ...
             "HydrCondCrustFile", Kc_NF, ...

             "HydrCondSoilInit", Ks_init, ...
             "HydrCondSoilCoef", Kscoef, ...
             "HydrCondSoilFile", Ks_NF, ...

             "WaterContInit", dtheta_init, ...
             "WaterContCoef", dthetacoef, ...
             "WaterContFile", dtheta_NF, ...

             "PsiInit", Psi_init, ...
             "PsiCoef", Psicoef, ...
             "PsiFile", Psi_NF, ...
  
             "MaxInfRateInit", imax_init, ...
             "MaxInfRateCoef", imaxcoef, ...
             "MaxInfRateFile", imax_NF, ...
  
             "TopographyInit", topo, ...
             "TopographyFile", topo_NF, ...
  
             "huvInit", huv_init, ...
             "huvFile", huv_NF, ...
  
             "RainInit", rain, ...
             "RainFile", rain_NF, ...
  
             "OutputsSuffix", suffix_o, ...
             "OutputFormat", output_f
);



