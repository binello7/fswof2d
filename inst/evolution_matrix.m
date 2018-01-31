## Copyright (C) 2018 Sebastiano Rusca
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
## Created: 2018-01-31

## -*- texinfo -*-
## @defun {@var{outarg} =} funcname (@var{inarg}, @dots{})
## @defunx {@var{outarg2} =} funcname (@var{inarg2}, @dots{})
## Oneliner
##
## Explanation usage 1
##
## Explanation usage 2
##
## @seealso{func1, func2}
## @end defun


function varargout = evolution_matrix (Nx, Ny, nframes, varargin)

  for n = 1:nframes
    idx_1 = 1 + (n - 1) * Nx * Ny;
    idx_2 = n * Nx * Ny;
    span = idx_1:idx_2;

    for i = 1:length (varargin)
      varargout{i}(:,:,n) = dataconvert ('octave', [Nx Ny], varargin{i}(span));
    endfor
  endfor

endfunction

%!demo
%! Nx = 2;
%! Ny = 3;
%! nframes = 3;
%! H = [1 2 3 1 2 3 2 4 6 2 4 6 3 6 9 3 6 9].';
%! U = 0.5 * H;
%! [HHt, UUt] = evolution_frames (Nx, Ny, nframes, H, U)
