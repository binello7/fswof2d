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

## -*- texinfo -*-
## @defun {@var{zz} =} extrude_csec (@var{x}, @var{y}, @var{z})
## @defunx {[@var{xx} @var{yy} @var{zz}] =} extrude_csec (@dots{})
## Given a x-z cross-section profile, extrude it along the specified y-axis.
##
## The given values of the @var{y} vector represents the positions on the y-axis
## where a cross-section will be copied. The @var{y} values don't 
## have to be linearly spaced.
##
## @seealso{csec_channel2lvlsym}
## @end defun

function [X Y Z] = extrude_csec (x, y, z)

  # TODO y or x or z are function handles

  # is csec defined on x
  if length (z) != length (x)
    error ('Octave:invalid-input-arg', ...
       'X and Z must have the same shape')
  endif

  [X Y] = meshgrid (x(:), y(:));
  Z     = repmat (z(:).', length (y), 1);

  if nargout == 1
    X = Z;
  endif

endfunction

%!demo
%! n = struct("Embankment",20, "Plain",10,"RiverBank",20,"RiverBed",10);
%! [x z] = csec_channel2lvlsym (n);
%! y = linspace (0,max(x)*3, 100).';
%! [X Y Z] = extrude_csec (x, y, z);
%! plot_topo (X,Y,Z);

%!demo
%! n = struct("Embankment",20, "Plain",10,"RiverBank",20,"RiverBed",10);
%! [x z p] = csec_channel2lvlsym (n);
%! y = linspace (0,max(x)*3, 100).';
%! [X Y Zc] = extrude_csec (x, y, z);
%! nf =@(d1,d2) [cosd(d2).*sind(d1) sind(d2).*sind(d1) cosd(d1)];
%! np = nf (10, 0);
%! Zp = (np(1) * X + np(2) * Y ) ./ np(3);
%! 
%! x_ini = p.Embankment + p.Plain + p.RiverBank + 1;
%! x_end = x_ini + p.RiverBed - 1;
%! ch_mask = (X > x_ini & X < x_end);
%! Zs = 10*sin (2*pi*3*Y/max(Y(:))) .* ch_mask;
%!
%! Z  = Zc + Zp + Zs;
%! zmin = min (Z(:));
%! Z+= zmin;
%!
%! h = plot_topo (X,Y,Z);
%! set (h.surf, 'edgecolor', 'k');

%!demo
%! n = struct("Embankment",20, "Plain",10,"RiverBank",20,"RiverBed",10);
%! [x z p] = csec_channel2lvlsym (n);
%! y       = linspace (0,max(x)*3, 100).';
%! [X Y Z] = extrude_csec (x, y, z);
%! 
%! w = p.RiverBed + p.RiverBank;
%! DX = w/5 * sin (pi*Y/max(Y(:)));
%! x_cen = p.Embankment + p.Plain + p.RiverBank + p.RiverBed/2;
%! sigma = w * 0.7;
%! s_mask = 2 * exp (- 0.5 * (X - x_cen).^4 / 2 / sigma.^4);
%! Xt = X + DX.* s_mask;
%!
%! h = plot_topo (Xt,Y,Z);
%! set (h.surf, 'edgecolor', 'k');
