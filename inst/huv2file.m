## Copyright (C) 2017 Sebastiano Rusca
## Copyright (C) 2017 JuanPi Carbajal
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

## Author: Sebastiano Rusca <sebastiano.rusca@gmail.com>
## Created: 2017-12-07

## -*- texinfo -*-
## @defun {[@var{x} @var{y}] =} huv2file (@var{xx}, @var{yy})
## @defunx {[@var{x} @var{y} @var{h} @var{u} @var{v}] =} huv2file (@var{xx}, @var{yy}, @var{hh}, @var{uu}, @var{vv})
## @defunx {[@dots{}] =} huv2file (@dots{}, @var{filename})
## Given matrices of @var{xx}, @var{yy}, @var{hh}, @var{uu}, @var{vv} values, 
## prints them in a FullSWOF_2D compatible format in a file.
##
## If no values for @var{hh}, @var{uu}, @var{vv} are given, then those are set
## to zero.
##
## All values can be given in an @code{octave meshgrid format} or in a 
## @code{FullSWOF_2D linear format}. If no @var{filename} is given, then
## the values are printed to a file named @code{huv_init.dat}.
##
## By specifying @var{filename} the name of the output file can be changed.
## @seealso{huvIC, topo2file}
## @end defun




function [X Y H U V] = huv2file (xx, yy, hh=zeros((size(xx,1)*size(xx,2)),1), ...
                                 uu=zeros((size(xx,1)*size(xx,2)),1), ...
                                 vv=zeros((size(xx,1)*size(xx,2)),1), ...
                                 filename='huv_init.dat')

  X = xx(:);
  Y = yy(:);
  H = hh(:);
  U = uu(:);
  V = vv(:);


  fid = fopen (filename, 'w');

  header = sprintf ('# POINTS LIST - generated on\n', ...
                    strftime ("%Y-%m-%d %H:%M:%S", localtime (time ())));

  fprintf(fid, ...
  '#=======================================================================\n');
  fprintf(fid, header);
  fprintf(fid, ...
  '#=======================================================================\n');
  fprintf(fid, '#(i-0.5)*dx   #(j-0.5)*dy   h[i][j]   u[i][j]   v[i][j]\n');
  fprintf(fid, ...
  '#-----------------------------------------------------------------------\n');
  fprintf(fid, '%0.4f   %0.4f   %0.4f   %0.4f   %0.4f\n', [X(:) Y(:) ...
    H(:) U(:) V(:)].');

  fclose(fid);

endfunction 


