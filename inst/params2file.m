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
## @defun {@var{params} =} params2file (@var{paramsfile}, @var{filename}, @var{PROP}, @var{VAL})
## Generate the FullSWOF_2D compatible input file @code{parameters.txt}.
##
## @strong{Properties}:
##
## @table @asis
## @item "ParametersFile"
## ' '
## @item "xCells"
## 250
## @item "yCells"
## 140
## @item "SimDuration"
## 150
## @item "SavedStates"
## 50
## @item "SchemeType"
## 1, 1=fixed cfl, 2=fixed dt
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
## @item "FrictionInit"
## 2, 1=file, 2=const_coef
## @item "FrictionLaw"
## 1, 0=no friction, 1=Manning, 2=Darcy-Weisbach, 3=laminar
## @item "FrictionFile"
## 'friction_init.dat'
## @item "FrictionCoef"
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
## @item "InfiltrationModel"
## 0, 0=no infiltration, 1=Green-Ampt
## @item "CrustThicknessInit"
## 2, 1=file 2=const_val
## @item "CrustThicknessVal"
## 1
## @item "CrustThicknessFile"
## 'crust.dat'
## @item "HydrCondCrustInit"
## 2, 1=file, 2=const_coef
## @item "HydrCondCrustCoef"
## 1.8e-6
## @item "HydrCondCrustFile"
## 'crust_hydr_cond.dat'
## @item "HydrCondSoilInit"
## 2, 1=file, 2=const_coef
## @item "HydrCondSoilCoef"
## 1.8e-6
## @item "HydrCondSoilFile"
## 'soil_hydr_cond.dat'
## @item "DeltaWaterContentInit"
## 2, 1=file 2=const_val
## @item "DeltaWaterContentVal"
## 0.254
## @item "DeltaWaterContentFile"
## water_cont.dat
## @item "WetFrontSuccHeadInit"
## 2, 1=file 2=const_val
## @item "WetFrontSuccHeadVal"
## 0.167
## @item "WetFrontSuccHeadFile"
## 'psi.dat'
## @item "MaxInfiltrationRateInit"
## 2, 1=file 2=const_val
## @item "MaxInfiltrationRateVal"
## 1.7e-4
## @item "MaxInfiltrationRateFile"
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
## @item "OutputsFormat"
## 1, 1=gnuplot, 2=vtk
## @end table
## @end defun

function p = params2file (varargin)

  translate = struct (
  "xCells", {'Nxcell', '%d'}, ...
  "yCells", {'Nycell', '%d'}, ...
  "SimDuration", {'T', '%d'}, ...
  "SavedStates", {'nbtimes', '%d'}, ...
  "SchemeType", {'scheme_type', '%d'}, ...
  "TimeStep", {'dtfix', '%f'}, ...
  "CFLval", {'cflfix', '%f'}, ...
  "xLength", {'L', '%f'}, ...
  "yLength", {'l', '%f'}, ...

  "LBoundConst", {'L_bc_init', '%d'}, ...
  "LBoundCond", {'Lbound', '%d'}, ...
  "LimposedQ", {'left_imp_discharge', '%f'}, ...
  "LimposedH", {'left_imp_h', '%f'}, ...

  "RBoundConst", {'R_bc_init', '%d'}, ...
  "RBoundCond", {'Rbound', '%d'}, ...
  "RimposedQ", {'right_imp_discharge', '%f'}, ...
  "RimposedH", {'right_imp_h', '%f'}, ...

  "BBoundConst", {'B_bc_init', '%d'}, ...
  "BotBoundCond", {'Bbound', '%d'}, ...
  "BotImposedQ", {'bottom_imp_discharge', '%f'}, ...
  "BotImposedH", {'bottom_imp_h', '%f'}, ...

  "TBoundConst", {'T_bc_init', '%d'}, ...
  "TopBoundCond", {'Tbound', '%d'}, ...
  "TopImposedQ", {'top_imp_discharge', '%f'}, ...
  "TopImposedH", {'top_imp_h', '%f'}, ...

  "FrictionInit", {'fric_init', '%d'}, ...
  "FrictionLaw", {'fric', '%d'}, ...
  "FrictionFile", {'fric_NF', '%s'}, ...
  "FrictionCoef", {'friccoef', '%f'}, ...

  "NumFlux", {'flux', '%d'}, ...
  "SchemeOrder", {'order', '%d'}, ...
  "Reconstruction", {'rec', '%d'}, ...
  "AmortENO", {'amortENO', '%f'}, ...
  "ModifENO", {'modifENO', '%f'}, ...
  "Limiter", {'lim', '%d'}, ...

  "InfiltrationModel", {'inf', '%d'}, ...
  "CrustThicknessInit", {'zcrust_init', '%d'}, ...
  "CrustThicknessVal", {'zcrustcoef', '%f'}, ...
  "CrustThicknessFile", {'zcrust_NF', '%s'}, ...

  "HydrCondCrustInit", {'Kc_init', '%d'}, ...
  "HydrCondCrustCoef", {'Kccoef', '%g'}, ...
  "HydrCondCrustFile", {'Kc_NF', '%s'}, ...

  "HydrCondSoilInit", {'Ks_init', '%d'}, ...
  "HydrCondSoilCoef", {'Kscoef', '%g'}, ...
  "HydrCondSoilFile", {'Ks_NF', '%s'}, ...

  "DeltaWaterContentInit", {'dtheta_init', '%d'}, ...
  "DeltaWaterContentVal", {'dthetacoef', '%f'}, ...
  "DeltaWaterContentFile", {'dtheta_NF', '%s'}, ...

  "WetFrontSuccHeadInit", {'Psi_init', '%d'}, ...
  "WetFrontSuccHeadVal", {'Psicoef', '%f'}, ...
  "WetFrontSuccHeadFile", {'Psi_NF', '%s'}, ...

  "MaxInfiltrationRateInit", {'imax_init', '%d'}, ...
  "MaxInfiltrationRateVal", {'imaxcoef', '%g'}, ...
  "MaxInfiltrationRateFile", {'imax_NF', '%s'}, ...

  "TopographyInit", {'topo', '%d'}, ...
  "TopographyFile", {'topo_NF', '%s'}, ...

  "huvInit", {'huv_init', '%d'}, ...
  "huvFile", {'huv_NF', '%s'}, ...

  "RainInit", {'rain', '%d'}, ...
  "RainFile", {'rain_NF', '%s'}, ...

  "OutputsSuffix", {'suffix_o', '%s'}, ...
  "OutputsFormat", {'output_f', '%d'}
  );

  ### If there is only one input argument it should be a structure
  if nargin == 1
    if !isstruct (varargin{1})
      error
    endif
    varargin = struct2params (varargin{1});
  endif

  ### DEFAULT INIZIALIZATION OF THE FUNCTION ###
  parser = inputParser ();
  parser.FunctionName = 'params2file';
  #TODO
  #checker = ...
  parser.addParamValue ("ParametersFile", []); # name of the generated  parameters
                                           # file. If empty, do not write file.

  parser.addParamValue ("xCells", 250);   # cells in x-direction
  parser.addParamValue ("yCells", 140);   # cells in y-direction

  parser.addParamValue ("SimDuration", 150);    # time duration of simulation [s]
  parser.addParamValue ("SavedStates", 50);  # number of times saved
  parser.addParamValue ("SchemeType", 1);   # 1=fixed cfl, 2=fixed dt
  parser.addParamValue ("TimeStep", 0.01);  # timestep [s]
  parser.addParamValue ("CFLval", 0.4);     # cfl-value
  parser.addParamValue ("xLength", 250);    # length of domain in x [m]
  parser.addParamValue ("yLength", 140);    # length of the domain in y [m]

  parser.addParamValue ("LBoundConst", 2);
  parser.addParamValue ("LBoundCond", 2);     # 1=imp.h, 2=wall, 3=neumann,
                                              # 4=periodic, 5=imp.q at x=0
  parser.addParamValue ("LimposedQ", 0.0005); # imposed discharge at x=0 [m3/s]
  parser.addParamValue ("LimposedH", 0.005);  # imposed water height at x=0 [m]

  parser.addParamValue ("RBoundConst", 2);
  parser.addParamValue ("RBoundCond", 2);     # 1=imp.h, 2=wall, 3=neumann,
                                              # 4=periodic, 5=imp.q at xmax
  parser.addParamValue ("RimposedQ", 0.0005);  # imposed discharge at xmax [m3/s]
  parser.addParamValue ("RimposedH", 0.005);  # imposed water height at xmax [m]

  parser.addParamValue ("BBoundConst", 2);
  parser.addParamValue ("BotBoundCond", 2);    # 1=imp.h, 2=wall, 3=neumann,
                                               # 4=periodic, 5=imp.q at y=0
  parser.addParamValue ("BotImposedQ", 0.0005);# imposed discharge at y=0 [m3/s]
  parser.addParamValue ("BotImposedH", 0.005); # imposed water height at y=0 [m]

  parser.addParamValue ("TBoundConst", 2);
  parser.addParamValue ("TopBoundCond", 2);    # 1=imp.h, 2=wall, 3=neumann,
                                               # 4=periodic, 5=imp.q at ymax
  parser.addParamValue ("TopImposedQ", 0.0005);# imposed discharge at ymax [m3/s]
  parser.addParamValue ("TopImposedH", 0.005); # imposed water height at ymax [m]

  parser.addParamValue ("FrictionInit", 2); # 1=file, 2=const_coef
  parser.addParamValue ("FrictionLaw", 1);  # 0=No Friction, 1=Manning,
                                         # 2=Darcy-Weisbach, 3=laminar
  parser.addParamValue ("FrictionFile", 'friction_init.dat'); # friction file
  parser.addParamValue ("FrictionCoef", 0.03); # friction coefficient

  parser.addParamValue ("NumFlux", 5); # 1=Rusanov, 2=HLL, 3=HLL2, 4=HLLC, 5=HLLC2
  parser.addParamValue ("SchemeOrder", 2); # 1=order1, 2=order2
  parser.addParamValue ("Reconstruction", 1); # 1=MUSCL, 2=ENO, 3=ENOmod
  parser.addParamValue ("AmortENO", 0.25); # Between 0 and 1
  parser.addParamValue ("ModifENO", 0.9);  # Between 0 and 1
  parser.addParamValue ("Limiter", 1);     # 1=Minmod 2=VanAlbada 3=VanLeer

  parser.addParamValue ("InfiltrationModel", 0);       # 0=No Infiltration,
                                                       # 1=Green-Ampt
  parser.addParamValue ("CrustThicknessInit", 2);  # 1=file 2=const_val
  parser.addParamValue ("CrustThicknessVal", 1);   # crust thickness value
  parser.addParamValue ("CrustThicknessFile", 'crust.dat'); # crust thickness file name

  parser.addParamValue ("HydrCondCrustInit", 2); # 1=file, 2=const_coef
  parser.addParamValue ("HydrCondCrustCoef", 1.8e-6);
  parser.addParamValue ("HydrCondCrustFile", 'crust_hydr_cond.dat'); # hydro cond crust file

  parser.addParamValue ("HydrCondSoilInit", 2); # 1=file, 2=const_coef
  parser.addParamValue ("HydrCondSoilCoef", 1.8e-6);
  parser.addParamValue ("HydrCondSoilFile", 'soil_hydr_cond.dat'); # hydro cond soil file

  parser.addParamValue ("DeltaWaterContentInit", 2); # 1=file 2=const_val
  parser.addParamValue ("DeltaWaterContentVal", 0.254); # water content value
  parser.addParamValue ("DeltaWaterContentFile", 'water_cont.dat'); # water cont file

  parser.addParamValue ("WetFrontSuccHeadInit", 2);         # 1=file 2=const_val
  parser.addParamValue ("WetFrontSuccHeadVal", 0.167);      # psi value
  parser.addParamValue ("WetFrontSuccHeadFile", 'psi.dat'); # psi file name

  parser.addParamValue ("MaxInfiltrationRateInit", 2);       # 1=file 2=const_val
  parser.addParamValue ("MaxInfiltrationRateVal", 1.7e-4);  # max inf rate value
  parser.addParamValue ("MaxInfiltrationRateFile", 'max_inf.dat'); # max inf rate file

  parser.addParamValue ("TopographyInit", 1); # 1=file, 2=flat, 3=Thacker
  parser.addParamValue ("TopographyFile", 'topography.dat'); # topography file

  parser.addParamValue ("huvInit", 1); # 1=file 2=h,u&v=0 3=Thacker
                                      # 4=Radial_Dam_dry 5=Radial_Dam_wet
  parser.addParamValue ("huvFile", 'huv_init.dat'); # huv file

  parser.addParamValue ("RainInit", 0); # 0=no rain, 1=file, 2=function
  parser.addParamValue ("RainFile", 'rain.dat'); # rain file

  parser.addParamValue ("OutputsSuffix", ''); # suffix for "Outputs" folder
  parser.addParamValue ("OutputsFormat", 1);   # 1=gnuplot, 2=vtk

  parser.parse (varargin{:});
  p = parser.Results;

  if !isempty (p.ParametersFile)
    fid = fopen (p.ParametersFile, 'w');
    fmt = ' <%s>:: %s\n';
    fname = fieldnames (translate);

    idx = [];
    for i=1:numel(fname)
      f = fname{i};
      if strcmp({translate.(f)}{2},'%s')
        idx(end+1) = i;
        continue
      endif

      fprintf (fid, sprintf (fmt, translate.(f)), p.(f));
    endfor

    for k=1:length(idx)
      i = idx(k);
      f = fname{i};
      fprintf (fid, sprintf (fmt, translate.(f)), p.(f));
    endfor

    fclose (fid);
  else
    warning ('Octave:fswof2d:params2file:no-file-generated', ...
   "No parameters file was generated, to do it set the option 'ParametersFile'.\n");
  endif

endfunction

function params = struct2params (s)

  k = fieldnames (s);
  v = cellfun (@(f)getfield(s,f), k, 'unif', 0);

  params          = cell (1, 2 * numel (k));
  params(1:2:end) = k;
  params(2:2:end) = v;

endfunction

%!test
%! warning ('off', 'Octave:fswof2d:params2file:no-file-generated', 'local');
%! params2file (params2file ());

%!test
%! warning ('off', 'Octave:fswof2d:params2file:no-file-generated', 'local');
%! p  = params2file ();
%! p2 = params2file (p);
%! assert (p, p2);
