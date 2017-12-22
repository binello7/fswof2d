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

## Author: Sebastiano Rusca <sebastiano.rusca@gmail.com>
## Created: 2017-12-22

## -*- texinfo -*-
## @defun {[@var{x}, @dots{}] =} dataconvert (@asis{'fswof2d'}, @var{xx}, @dots{})
## @defunx {[@var{xx}, @dots{}] =} dataconvert (@asis{'octave'}, @var{sz}, @var{x}, @dots{})
## Convert data from the @code{octave} format to the @code{fswof2d} format or vice-versa.
##
## If the conversion takes place from the @code{fswof2d} format to the 
## @code{octave} format, then @var{format} takes the value @code{octave} and 
## @var{sz} = [@var{Nx} @var{Ny}] (number of cells in the x and y directions) 
## cannot be empty.
##
## If the conversion is the other way round, then @var{format} assumes the 
## value @code{fswof2d} and [@var{Nx} @var{Ny}] don't have to be filled.
##
## @seealso{huv2file, topo2file}
## @end defun

function varargout = dataconvert (fmt, varargin)

  valid_fmt = {'octave', 'fswof2d'};
  [tf, idx] = ismember (fmt, valid_fmt);

  if ( !tf || length(tf) > 1 )
    error ('Octave:invalid-input-arg', ...
                    "Accepted output formats are only 'octave' or 'fswof2d'\n");
  endif

  is_size =@(x) numel (x) == 2 && all ((fix (x) - x) == 0);
  if idx == 1
    if !is_size (varargin{1})
      error ('Octave:invalid-input-arg', ...
                      "'octave' format needs size as 4th argument\n");
    endif
    sz          = varargin{1};
    varargin(1) = [];
  endif

  func      = {@(x)reshape (x, sz), ...
               @(x)x(:)};
  varargout = cellfun (func{idx}, varargin, 'UniformOutput', false);

endfunction

%!demo
%! Nx = 47;
%! Ny = 56;
%! x  = linspace (-1, 1, Nx+1).';
%! y  = linspace (0, 1, Ny+1).';
%!
%! [xx yy] = meshgrid (x, y);
%! xxco     = node2center (xx, 2);
%! yyco     = node2center (yy);
%! hhco     = cos(2*pi*xxco).*sin(2*pi*yyco);
%! [xc yc hc] = dataconvert ('fswof2d', xxco, yyco, hhco);
%! [xxc yyc hhc] = dataconvert ('octave', [Ny Nx], xc, yc, hc);
%!
%! figure (1)
%! clf
%! mesh (xxco,yyco,hhco,'facecolor','none','edgecolor','r');
%! hold on
%! surf (xxc,yyc, hhc,'edgecolor','none');
%! hold off
%! axis tight

