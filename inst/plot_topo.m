## Copyright (C) 2017 Sebastiano Rusca
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
## @defun {[@var{h}] =} plot_topo (@var{x}, @var{y}, @var{z})
## Plot topography with corresponding colormap. Contour lines are displayed on the bottom plane of the graph.
##
## @var{x}, @var{y} and @var{z} have to be given in the @code{meshgrid} format.
## @end defun


function h = plot_topo (x,y,z)

    try
      if ~exist ('terrain.m')
        matplotlib_cm ('terrain');
      endif
      cc = terrain (64);
      colormap (cc);
    catch
      continue
    end_try_catch

    h = struct ();
    
    h.surf = surf(x,y,z); 
    shading interp; 
    axis tight; 

    v    = axis ();
    zmin = v(5); 
    axis([v(1:4) zmin*1.1 v(6)]); 
    
    hold on
    # Plot level curves at bottom of figure with labels with 1 cm resolution
    lvl           = round (linspace (min (z(:)), max (z(:)), 10)*1e1)*1e-1; 
    [c,h.contour] = contour (x, y, z, lvl, 'zlevel', zmin * 1.05, ...
                                          'zlevelmode','manual'); 
#    clabel (c, h.contour, lvl);
    hold off

endfunction

