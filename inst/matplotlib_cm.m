## Copyright (C) 2016 - Juan Pablo Carbajal
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

## Author: JuanPi Carbajal <ajuanpi+dev@gmail.com>


function matplotlib_cm (name, pyver=3)
  cmd = sprintf("\
import matplotlib.pyplot as plt;\
import numpy as np;\
x = np.linspace(0,1,%%d);\
print (plt.get_cmap(\\\'%s\\\')(x))\
", name);

  fid = fopen (sprintf("%s.m", name),"w");
  fprintf (fid, "function c = %s (N=64)\n", name);
  fprintf (fid, "[~, txt] = system (sprintf (\"python%d -c \\\"%s\\\"\",N));\n", pyver, cmd);
  fprintf (fid, "eval(sprintf (\'c = %%s(:,1:3);\', txt(1:end-1)));\n");
  fprintf(fid, "endfunction");
  fclose (fid);
endfunction

