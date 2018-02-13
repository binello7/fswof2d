## Copyright (C) 2017 Juan Pablo Carbajal
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

## Author: Juan Pablo Carbajal <ajuanpi+dev@gmail.com>
## Created: 2017-12-22

## -*- texinfo -*-
## @defun {@var{params} =} read_params (@var{filename})
## Return a @code{struct} with the simulation parameters and their values.
##
## Read the FullSWOF_2D @code{parameters.txt} file and returns a @code{struct}
## @var{params} containing the names of all the parameters settable and their
## corresponding value.
##
## If @code{parameters.txt} is not stored in the same folder, then
## @var{filename} has to include the path to the file. @var{filename} is set by
## default to @code{parameters.txt}.
##
## @seealso{params2file}
## @end defun

function p = read_params (fname = 'parameters.txt')

  fid = fopen (fname, "rt");
  np  = 47;
  tmp = textscan (fid, "%s %f", np); #TODO parametrize
  tmp2 = textscan (fid, "%s %s");
  
  nam = strtok (tmp(1){1}, '<:>');
  nam = vertcat (nam, strtok (tmp2(1){1}, '<:>'));
  
  p = vertcat (mat2cell (tmp(2){1}, ones (np,1), 1), tmp2(2){1});
  p = cell2struct (p, nam);

endfunction
