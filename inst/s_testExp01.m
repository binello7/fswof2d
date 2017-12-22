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

close all

## METADATA
studyName   = "Exp01_rep";
topofile    = "topography.txt";
huvfile     = "huv.txt";
paramfile   = "parameters.txt";

## SIMULATION PARAMETERS
Nxcell              = 32;
Nycell              = 64;

T                   = 50;
nbtimes             = 2;

scheme_type         = 1;
dtfix               = 0.01;
cflfix              = 0.4;

L                   = 6.4;
l                   = 12.8;

Lbound              = 2;
left_imp_q          = 0.0005;
left_imp_h          = 0.005;

Rbound              = 2;
right_imp_q         = 0.0005;
right_imp_h         = 0.005;

Bbound              = 2;
bottom_imp_q        = 0.0005;
bottom_imp_h        = 0.005;

Tbound              = 2;
top_imp_q           = 0.0005;
top_imp_h           = 0.005;

fric_init           = 2;
fric                = 2;
fric_NF             = "friction_init.dat";
friccoef            = 0.25;

flux                = 5;

order               = 2;

rec                 = 1;
amortENO            = 0.25;
modifENO            = 0.9;
lim                 = 1;

inf                 = 1;
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

rain                = 1;
rain_NF             = "rain.txt";

suffix_o            = "";

output_f            = 1;



## INITIAL CONDITIONS


## BOUNDARY CONDITIONS

## WRITE STUDY FOLDER
dataName    = 'data';
inputsName  = 'Inputs';
outputsName = 'Outputs';

studyFolder   = fullfile (dataName, studyName);
inputsFolder  = fullfile (studyFolder, inputsName);

mkdir (dataName, studyName);
mkdir (studyFolder, inputsName);
mkdir (studyFolder, outputsName);

ftopo  = fullfile (inputsFolder, topofile);
fhuv   = fullfile (inputsFolder, huvfile);
fparam = fullfile (inputsFolder, paramfile);


## GENERATE FILES
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


# Topography definition
topo_data = load (ftopo);

x = topo_data(:,1);
y = topo_data(:,2);
z = topo_data(:,3);



## WRITE HUV_INIT TO FILE
h0 = 0;
u0 = 0;
v0 = 0;

huv2file ("InitWaterDepth", h0, ...
          "InitXvelocity", u0, ...
          "InitYvelocity", v0, ...
          "xValues", x, ...
          "yValues", y, ...
          "OutputFile", fhuv);

## OUTPUTS
outputsFolder = fullfile (studyFolder, outputsName);

init = 'huz_initial.dat';
evl  = 'huz_evolution.dat';
fin  = 'huz_final.dat';

finit  = fullfile (outputsFolder, init);
fevl   = fullfile (outputsFolder, evl);
ffin   = fullfile (outputsFolder, fin);

init_data = load (finit);
evl_data  = load (fevl);
fin_data  = load (ffin);


[X Y Z]   = dataconvert (x, y, z, 'octave', [Nxcell Nycell]);
[X Y HZ]  = dataconvert (x, y, fin_data(:,6), 'octave', [Nxcell Nycell]);


col = [0 0 1];  # or better to set it at the beginning, to have all changeable 
                # elements together?
C(1:Nycell, 1:Nxcell, 1:3) = 0;
C(:,:,1) = col(1,1);
C(:,:,2) = col(1,2);
C(:,:,3) = col(1,3);

h = plot_topo (X, Y, Z);
hold on
g = mesh (X, Y, HZ, "facecolor", 'none', "edgecolor", col);
hold off



#tstep = 2;
#plot_output ("xValues", x, "yValues", y, ...
#             "PlotVariable", evl_data(:,6), ...
#             "TimeStep", tstep);

#hold on
#plot_output ("xValues", x, "yValues", y, ...
#             "PlotVariable", evl_data(:,7), ...
#             "TimeStep", tstep);
#hold off








