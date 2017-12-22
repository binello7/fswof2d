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
## Created: 2017-12-22

## -*- texinfo -*-
## @defun {} matplotlib_cm (@var{name})
## @defunx {} matplotlib_cm (@var{name}, @var{pyver})
## Import colormap from matplotlib.pyplot
##
## Uses a system call to extract values from matplotlib's colormaps.
## The colormap is selected with the @var{name} input, which should be a string.
##
## On successful execution the function generates a m-file @var{name}.m
## that can be used for future call to the colormap.
##
## The optional input argument @var{pyver} specifies the python version to use,
## default is 3.
##
## @seealso{python}
## @end defun

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

