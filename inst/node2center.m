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
## @defun {@var{cx} =} node2center (@var{x})
## Converts nodes to centers.
##
## @seealso{linspace, meshgrid}
## @end defun

function cx = node2center (x, dim=1)

  if !ismatrix (x)
    error ('Octave:invalid-input-arg', 'Works only on 1D/2D arrays');
  endif
  # FIXME doesn't work for dims > 2
  if dim == 2; x = x.'; endif;

  # indexes
  nx   = size (x, 1);
  next = (2:nx).';
  prev = (1:nx-1).';
  cx   = ( x(next,1:end-1) + x(prev,1:end-1) ) / 2;

  cx(cx>max(x(:))) = [];
  cx(cx<min(x(:))) = [];

  if dim == 2; cx = cx.'; endif;
endfunction

%!assert (node2center ([1 2]), 1.5)
%!assert (node2center ([0 1 5 7 11]), [0.5 3 6 9])

%!demo
%! x = linspace (-1,1,10).';
%! y = sqrt (linspace (0,1,25)).';
%! # Nodes
%! [X Y]   = meshgrid (x, y);
%! [Cx Cy] = meshgrid (node2center (x), node2center (y));
%!
%! figure (1);
%! clf
%! mesh (X, Y, zeros(size(X)));
%! hold on
%! mesh (Cx, Cy, zeros(size(Cx)),'edgecolor','r');
%! hold off
%! view (2);
%! axis tight
%! axis off

