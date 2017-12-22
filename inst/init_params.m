## Copyright (C) 2017 Sebastiano Rusca
## Copyright (C) 2017 JuanPi Carbajal
##
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## Author: Sebastiano Rusca <sebastiano.rusca@gmail.com>
## Created: 2017-12-07


## -*- texinfo -*-
## @defun {[@var{params}] =} init_params (@var{PROP}, @var{VAL})
## Create the FullSWOF_2D compatible input file @code{parameters.txt}.
##
## @strong{Properties}:
##
## @table @asis
## @item "xCells"
## 250
## @item "yCells"
## 140
## @item "SimTime"
## 150
## @item "SavedTimes"
## 50
## @item "SchemeType"
## 1
## @item "TimeStep"
## 0.01
## @item "CFLval"
## 0.4
## @item "xLength"
## 250
## @item "yLength"
## 140
## @item "LBoundCond" (x=0)
## 2, 1=imp.h, 2=wall, 3=neumann, 4=periodic, 5=imp.q
## @item "LimposedQ"
## 0.0005
## @item "LimposedH"
## 0.005
## @item "RBoundCond" (x=xmax)
## 2, 1=imp.h, 2=wall, 3=neumann, 4=periodic, 5=imp.q
## @item "RimposedQ"
## 0.0005
## @item "RimposedH"
## 0.005
## @item "BotBoundCond" (y=0)
## 2, 1=imp.h, 2=wall, 3=neumann, 4=periodic, 5=imp.q
## @item "BotImposedQ"
## 0.0005
## @item "BotImposedH"
## 0.005
## @item "TopBoundCond" (y=ymax)
## 2, 1=imp.h, 2=wall, 3=neumann, 4=periodic, 5=imp.q
## @item "TopImposedQ"
## 0.0005
## @item "TopImposedH"
## 0.005
## @item "FrictInit"
## 2, 1=file, 2=const_coef
## @item "FrictLaw"
## 1, 0=no Friction, 1=Manning, 2=Darcy-Weisbach, 3=laminar
## @item "FrictFile"
## 'friction_init.dat'
## @item "FrictCoef"
## 0.03
## @item "NumFlux"
## 5, 1=Rusanov, 2=HLL, 3=HLL2, 4=HLLC, 5=HLLC2
## @item "SchemeOrder"
## 2, 1=order1, 2=order2
## @item "Reconstruction"
## 1, 1=MUSCL, 2=ENO, 3=ENOmod
## @item "AmortENO"
## 0.25, Between 0 and 1
## @item "ModifENO"
## 0.9, Between 0 and 1
## @item "Limiter"
## 1, 1=Minmod 2=VanAlbada 3=VanLeer
## @item "InfModel"
## 0, 0=no Infiltration, 1=Green-Ampt
## @item "CrustThickness"
## 2
## @item "CrustCoef"
## 1
## @item "CrustFile"
## 'crust.dat'
## @item "HydrCondCrustInit"
## 2
## @item "HydrCondCrustCoef"
## 1.8e-6
## @item "HydrCondCrustFile"
## 'crust_hydr_cond.dat'
## @item "HydrCondSoilInit"
## 2
## @item "HydrCondSoilCoef"
## 1.8e-6
## @item "HydrCondSoilFile"
## 'soil_hydr_cond.dat'
## @item "WaterContInit"
## 2, 1=file 2=const_coef
## @item "WaterContCoef"
## 0.254
## @item "WaterContFile"
## water_cont.dat
## @item "PsiInit"
## 2, 1=file 2=const_coef
## @item "PsiCoef"
## 0.167
## @item "PsiFile"
## 'psi.dat'
## @item "MaxInfRateInit"
## 2, 1=file 2=const_coef
## @item "MaxInfRateCoef"
## 1.7e-4
## @item "MaxInfRateFile"
## 'max_inf.dat'
## @item "TopographyInit"
## 1, 1=file, 2=flat, 3=Thacker
## @item "TopographyFile"
## 'topography.dat'
## @item "huvInit"
## 1, 1=file 2=h,u&v=0 3=Thacker, 4=Radial_Dam_dry 5=Radial_Dam_wet
## @item "huvFile"
## 'huv_init.dat'
## @item "RainInit"
## 0, 0=no rain, 1=file, 2=function
## @item "RainFile"
## 'rain.dat'
## @item "OutputsSuffix"
## ' '
## @item "OutputFormat"
## 1, 1=gnuplot, 2=vtk
## @end table
## @end defun



function [params] = init_params (varargin)

  translate = struct (
  "xCells", {'Nxcell', '%d'}, ...
  "yCells", {'Nycell', '%d'}, ...
  "SimTime", {'T', '%d'}, ...
  "SavedTimes", {'nbtimes', '%d'}, ...
  "SchemeType", {'scheme_type', '%d'}, ...
  "TimeStep", {'dtfix', '%f'}, ...
  "CFLval", {'cflfix', '%f'}, ...
  "xLength", {'L', '%f'}, ...
  "yLength", {'l', '%f'}, ...

  "LBoundCond", {'Lbound', '%d'}, ...
  "LimposedQ", {'left_imp_discharge', '%f'}, ...
  "LimposedH", {'left_imp_h', '%f'}, ...

  "RBoundCond", {'Rbound', '%d'}, ...
  "RimposedQ", {'right_imp_discharge', '%f'}, ...
  "RimposedH", {'right_imp_h', '%f'}, ...

  "BotBoundCond", {'Bbound', '%d'}, ...
  "BotImposedQ", {'bottom_imp_discharge', '%f'}, ...
  "BotImposedH", {'bottom_imp_h', '%f'}, ...

  "TopBoundCond", {'Tbound', '%d'}, ...
  "TopImposedQ", {'top_imp_discharge', '%f'}, ...
  "TopImposedH", {'top_imp_h', '%f'}, ...

  "FrictInit", {'fric_init', '%d'}, ...
  "FrictLaw", {'fric', '%d'}, ...
  "FrictFile", {'fric_NF', '%s'}, ...
  "FrictCoef", {'friccoef', '%f'}, ...

  "NumFlux", {'flux', '%d'}, ...
  "SchemeOrder", {'order', '%d'}, ...
  "Reconstruction", {'rec', '%d'}, ...
  "AmortENO", {'amortENO', '%f'}, ...
  "ModifENO", {'modifENO', '%f'}, ...
  "Limiter", {'lim', '%d'}, ...

  "InfModel", {'inf', '%d'}, ...
  "CrustThickness", {'zcrust_init', '%d'}, ...
  "CrustCoef", {'zcrustcoef', '%f'}, ...
  "CrustFile", {'zcrust_NF', '%s'}, ...

  "HydrCondCrustInit", {'Kc_init', '%d'}, ...
  "HydrCondCrustCoef", {'Kccoef', '%f'}, ...
  "HydrCondCrustFile", {'Kc_NF', '%s'}, ...

  "HydrCondSoilInit", {'Ks_init', '%d'}, ...
  "HydrCondSoilCoef", {'Kscoef', '%f'}, ...
  "HydrCondSoilFile", {'Ks_NF', '%s'}, ...

  "WaterContInit", {'dtheta_init', '%d'}, ...
  "WaterContCoef", {'dthetacoef', '%f'}, ...
  "WaterContFile", {'dtheta_NF', '%s'}, ...

  "PsiInit", {'Psi_init', '%d'}, ...
  "PsiCoef", {'Psicoef', '%f'}, ...
  "PsiFile", {'Psi_NF', '%s'}, ...

  "MaxInfRateInit", {'imax_init', '%d'}, ...
  "MaxInfRateCoef", {'imaxcoef', '%f'}, ...
  "MaxInfRateFile", {'imax_NF', '%s'}, ...

  "TopographyInit", {'topo', '%d'}, ...
  "TopographyFile", {'topo_NF', '%s'}, ...

  "huvInit", {'huv_init', '%d'}, ...
  "huvFile", {'huv_NF', '%s'}, ...

  "RainInit", {'rain', '%d'}, ...
  "RainFile", {'rain_NF', '%s'}, ...

  "OutputsSuffix", {'suffix_o', '%s'}, ...
  "OutputFormat", {'output_f', '%d'}
  );



  ### DEFAULT INIZIALIZATION OF THE FUNCTION ###
  parser = inputParser ();
  parser.FunctionName = 'init_params';

  #TODO
  #checker = ...

  parser.addParamValue ("ParamsFile", 'parameters.txt'); # name of the generated
                                                         # parameters file


  parser.addParamValue ("xCells", 250);  # nodes in x-direction
  parser.addParamValue ("yCells", 140);   # nodes in y-direction

  parser.addParamValue ("SimTime", 150);    # time duration of simulation [s]
  parser.addParamValue ("SavedTimes", 50);  # number of times saved
  parser.addParamValue ("SchemeType", 1);   # 1=fixed cfl, 2=fixed dt
  parser.addParamValue ("TimeStep", 0.01);  # timestep [s]
  parser.addParamValue ("CFLval", 0.4);     # cfl-value
  parser.addParamValue ("xLength", 250);    # length of domain in x [m]
  parser.addParamValue ("yLength", 140);    # length of the domain in y [m]


  parser.addParamValue ("LBoundCond", 2);     # 1=imp.h, 2=wall, 3=neumann,
                                              # 4=periodic, 5=imp.q at x=0
  parser.addParamValue ("LimposedQ", 0.0005); # imposed discharge at x=0 [m3/s]
  parser.addParamValue ("LimposedH", 0.005);  # imposed water height at x=0 [m]


  parser.addParamValue ("RBoundCond", 2);     # 1=imp.h, 2=wall, 3=neumann,
                                              # 4=periodic, 5=imp.q at xmax
  parser.addParamValue ("RimposedQ", 0.0005);  # imposed discharge at xmax [m3/s]
  parser.addParamValue ("RimposedH", 0.005);  # imposed water height at xmax [m]


  parser.addParamValue ("BotBoundCond", 2);    # 1=imp.h, 2=wall, 3=neumann,
                                               # 4=periodic, 5=imp.q at y=0
  parser.addParamValue ("BotImposedQ", 0.0005);# imposed discharge at y=0 [m3/s]
  parser.addParamValue ("BotImposedH", 0.005); # imposed water height at y=0 [m]


  parser.addParamValue ("TopBoundCond", 2);    # 1=imp.h, 2=wall, 3=neumann,
                                               # 4=periodic, 5=imp.q at ymax
  parser.addParamValue ("TopImposedQ", 0.0005);# imposed discharge at ymax [m3/s]
  parser.addParamValue ("TopImposedH", 0.005); # imposed water height at ymax [m]


  parser.addParamValue ("FrictInit", 2); # 1=file, 2=const_coef
  parser.addParamValue ("FrictLaw", 1);  # 0=No Friction, 1=Manning, 
                                         # 2=Darcy-Weisbach, 3=laminar
  parser.addParamValue ("FrictFile", 'friction_init.dat'); # friction file
  parser.addParamValue ("FrictCoef", 0.03); # friction coefficient

  parser.addParamValue ("NumFlux", 5); # 1=Rusanov, 2=HLL, 3=HLL2, 4=HLLC, 5=HLLC2
  parser.addParamValue ("SchemeOrder", 2); # 1=order1, 2=order2
  parser.addParamValue ("Reconstruction", 1); # 1=MUSCL, 2=ENO, 3=ENOmod
  parser.addParamValue ("AmortENO", 0.25); # Between 0 and 1
  parser.addParamValue ("ModifENO", 0.9);  # Between 0 and 1
  parser.addParamValue ("Limiter", 1);     # 1=Minmod 2=VanAlbada 3=VanLeer

  parser.addParamValue ("InfModel", 0);       # 0=No Infiltration, 1=Green-Ampt
  parser.addParamValue ("CrustThickness", 2); # thickness of the crust [m]
  parser.addParamValue ("CrustCoef", 1);      # crust coefficient
  parser.addParamValue ("CrustFile", 'crust.dat'); # crust file name
  
  parser.addParamValue ("HydrCondCrustInit", 2); # 1=file, 2=const_coef
  parser.addParamValue ("HydrCondCrustCoef", 1.8e-6);
  parser.addParamValue ("HydrCondCrustFile", 'crust_hydr_cond.dat'); # hydro cond crust file

  parser.addParamValue ("HydrCondSoilInit", 2); # 1=file, 2=const_coef
  parser.addParamValue ("HydrCondSoilCoef", 1.8e-6);
  parser.addParamValue ("HydrCondSoilFile", 'soil_hydr_cond.dat'); # hydro cond soil file

  parser.addParamValue ("WaterContInit", 2); # 1=file 2=const_coef
  parser.addParamValue ("WaterContCoef", 0.254); # water content coefficient
  parser.addParamValue ("WaterContFile", 'water_cont.dat'); # water cont file

  parser.addParamValue ("PsiInit", 2);          # 1=file 2=const_coef
  parser.addParamValue ("PsiCoef", 0.167);      # psi coefficient
  parser.addParamValue ("PsiFile", 'psi.dat');  # psi file name

  parser.addParamValue ("MaxInfRateInit", 2);       # 1=file 2=const_coef
  parser.addParamValue ("MaxInfRateCoef", 1.7e-4);  # max inf rate coefficient
  parser.addParamValue ("MaxInfRateFile", 'max_inf.dat'); # max inf rate file
  
  parser.addParamValue ("TopographyInit", 1); # 1=file, 2=flat, 3=Thacker
  parser.addParamValue ("TopographyFile", 'topography.dat'); # topography file

  parser.addParamValue ("huvInit", 1); # 1=file 2=h,u&v=0 3=Thacker
                                      # 4=Radial_Dam_dry 5=Radial_Dam_wet
  parser.addParamValue ("huvFile", 'huv_init.dat'); # huv file

  parser.addParamValue ("RainInit", 0); # 0=no rain, 1=file, 2=function
  parser.addParamValue ("RainFile", 'rain.dat'); # rain file

  parser.addParamValue ("OutputsSuffix", ''); # suffix for "Outputs" folder
  parser.addParamValue ("OutputFormat", 1);   # 1=gnuplot, 2=vtk


  parser.parse (varargin{:});
  p = parser.Results;

  fid = fopen (p.ParamsFile, 'w');
  fmt = ' <%s>:: %s\n';
  fname = fieldnames (translate);


  for i=1:numel(fname)
    f = fname{i};
    fprintf (fid, sprintf (fmt, translate.(f)), p.(f));
  endfor

  fclose (fid);

endfunction



