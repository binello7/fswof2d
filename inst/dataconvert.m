## Copyright (C) YYYY Sebastiano Rusca
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
##
## Author: Sebastiano Rusca <sebastiano.rusca@gmail.com>
## Created: YYY-YY-DD


## -*- texinfo -*-
## @defun {[@var{xx}, @var{yy}, @var{vv}] =} dataconvert (@var{x}, @var{y}, @var{v}, @var{format}, @var{[Nx Ny]})
## @defunx {[@var{x}, @var{y}, @var{v}] =} dataconvert (@var{xx}, @var{yy}, @var{vv}, @var{format})
## Convert data from the @code{octave} format to the @code{fswof2d} format or vice-versa.
##
## If the conversion takes place from the @code{fswof2d} format to the @code{octave} format, then @var{format} takes the value @code{octave} and [@var{Nx} @var{Ny}] (number of cells in the x and y directions) cannot be empty.
##
## If the conversion is the other way round, then @var{format} assumes the value @code{fswof2d} and [@var{Nx} @var{Ny}] don't have to be filled.
## @seealso{huv2file, topo2file}
## @end defun

function [X Y VAR] = dataconvert (x, y, var, fmt, sz=[])

  if strcmp (fmt, 'octave')
    if isempty (sz)
      print_usage();
      error ('Octave:invalid-input-arg', "When output format is octave, sz cannot be empty.\n");
    endif
    
    Nx  = sz(1);
    Ny  = sz(2);
    X   = reshape (x, Ny, Nx);
    Y   = reshape (y, Ny, Nx);
    VAR = reshape (var, Ny, Nx);

  elseif strcmp (fmt, 'fswof2d')
    X   = x(:);
    Y   = y(:);
    VAR = var(:);

  else
    warning ("Accepted output formats are only 'octave' or 'fswof2d'")
  endif

endfunction


%!demo
%! Nx = 34;
%! Ny = 68;
%! xx = floor (100 * rand (Nx, Ny));
%! yy = floor (100 * rand (Nx, Ny));
%! hh = floor (100 * rand (Nx, Ny));
%! [x y h] = dataconvert (xx, yy, hh, 'fswof2d');

%!demo
%! Nx = 34;
%! Ny = 68;
%! L = Nx * Ny;
%! x = floor (100 * rand (L,1));
%! y = floor (100 * rand (L,1));
%! u = floor (100 * rand (L,1));
%! [xx yy uu] = dataconvert (x, y, u, 'octave', [Nx Ny]);


