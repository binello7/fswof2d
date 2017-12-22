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
## @defun {@var{} =} center2node (@var{}, @var{})
## 
## @seealso{}
## @end defun

function x = center2node (cx, x0)

  was_row = false;
  if isrow (cx)
    was_row = true;
    cx      = cx.';
  endif

  n = length (cx);

  # Assumes cx is increasing
  i = lookup (cx, x0);
  if (i > 0 && i < n)

    cl = cx(1:i);
    cr = cx(i+1:end);
    xl = center2node (cl, x0);
    xr = center2node (cr, x0);
    x  = [xl; xr];

  else

    x        = zeros (n+1, 1);

    mirrored = false;
    if x0 > cx(end)
      cx       = - flipud (cx);
      x0       = -x0;
      mirrored = true;
    endif

    x(1)     = x0;
    x(2:end) = 2 * cx;

    for i = 1:n
      x(i+1) -= x(i);
    end

    if mirrored
      x = - flipud (x);
    endif
    
  endif

  if was_row; x = x.'; endif

endfunction

%!assert (center2node (1.5, 1), [1 2], sqrt(eps))
%!assert (center2node ([0.5 3 6 9], 0), [0 1 5 7 11], sqrt(eps))
%!assert (center2node ([-1.3 -1 -0.5 0 6], -1.5), [-1.5 -1.1 -0.9 -0.1 0.1 11.9], sqrt(eps))

%!assert (center2node ([-1.3 -1 -0.5 0 6], -1.5), center2node ([-1.3 -1 -0.5 0 6], 11.9), sqrt(eps))

%!assert (center2node ([-1.3 -1 -0.5 0 6], -0.9), center2node ([-1.3 -1 -0.5 0 6], 11.9), sqrt(eps))


