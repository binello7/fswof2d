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
## @defun {[@var{xx} @var{yy} @var{zz}] =} extrude_csec (@var{x}, @var{y}, @var{z})
## Given a y-z cross-section profile, extrude it along the specified x-axis.
##
## The given values of the @var{x} vector represents the distances on the x-axis
## where a control cross-section will be generated. The @var{x} values don't 
## have to be linearly spaced. For compatibility with the accepted FullSWOF_2D 
## format the output @var{xx} will be shifted with respect to @var{x}.
##
## @seealso{csec_channel2lvlsym}
## @end defun

function [X Y Z] = extrude_csec (x, y, z)

 # TODO y or x or z are function handles

  [X Y] = meshgrid (x, y);
  # Assumes csec is defined on y
  Z     = repmat (z, 1, length (x));

endfunction

%!demo
%! n = struct("Embankment",20, "Plain",10,"RiverBank",20,"RiverBed",10);
%! [y z] = csec_channel2lvlsym (n);
%! x = linspace (0,max(y)*3, 100).';
%! [X Y Z] = extrude_csec (x, y, z);
%! plot_topo (X,Y,Z);

%!demo
%! n = struct("Embankment",20, "Plain",10,"RiverBank",20,"RiverBed",10);
%! [y z p] = csec_channel2lvlsym (n);
%! x = linspace (0,max(y)*3, 100).';
%! [X Y Zc] = extrude_csec (x, y, z);
%! nf =@(d1,d2) [cosd(d2).*sind(d1) sind(d2).*sind(d1) cosd(d1)];
%! np = nf (10, 0);
%! Zp = (np(1) * X + np(2) * Y ) ./ np(3);
%! 
%! y_ini = p.Embankment + p.Plain + p.RiverBank + 1;
%! y_end = y_ini + p.RiverBed - 1;
%! ch_mask = (Y > y_ini & Y < y_end);
%! Zs = 10*sin (2*pi*3*X/max(X(:))) .* ch_mask;
%!
%! Z  = Zc + Zp + Zs;
%! zmin = min (Z(:));
%! Z+= zmin;
%!
%! h = plot_topo (X,Y,Z);
%! set (h.surf, 'edgecolor', 'k');

%!demo
%! n = struct("Embankment",20, "Plain",10,"RiverBank",20,"RiverBed",10);
%! [y z p] = csec_channel2lvlsym (n);
%! x = linspace (0,max(y)*3, 100).';
%! [X Y Z] = extrude_csec (x, y, z);
%! 
%! w = p.RiverBed + p.RiverBank;
%! DY = w/5 * sin (pi*X/max(X(:)));
%! y_cen = p.Embankment + p.Plain + p.RiverBank + p.RiverBed/2;
%! sigma = w * 0.7;
%! s_mask = 2 * exp (- 0.5 * (Y - y_cen).^4 / 2 / sigma.^4);
%! Yt = Y + DY.* s_mask;
%!
%! h = plot_topo (X,Yt,Z);
%! set (h.surf, 'edgecolor', 'k');
