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
## @defun huv2file (@var{x}, @var{y})
## @defunx huv2file (@dots{}, @var{h}, @var{u}, @var{v})
## @defunx huv2file (@dots{}, @var{filename})
## Write initial conditions file.
##
## Given vectors of @var{x}, @var{y}, @var{h}, @var{u}, 
## @var{v} values, prints them to a file. 
## All values have to be given in 
## FullSWOF_2D format (compare function @code{dataconvert}).
##
## If no values for @var{h}, @var{u}, @var{v} are given, 
## then those are set to zero.
##
## If no @var{filename} is given, then the standard file name 
## @code{huv_init.dat} is used.
##
## @seealso{dataconvert, topo2file}
## @end defun

function huv2file (x, y, h=[], u=[], v=[], fname='huv_init.dat')
  if isempty (h); h = zeros(size (x)); endif
  if isempty (u); u = zeros(size (x)); endif
  if isempty (v); v = zeros(size (x)); endif

  header = {
'#==============================================================', ...
'# POINTS LIST', ...
'# automatically generated by huv2file.m on %s', ...
'#==============================================================', ...
'# (i-0.5)*dx   #(j-0.5)*dy   h[i][j]   u[i][j]   v[i][j]', ...
'#--------------------------------------------------------------'
  };
  header  = strjoin (header, "\n");
  timetxt = strftime ("%Y-%m-%d %H:%M:%S", localtime (time ()));
  header  = sprintf (header, timetxt);

  fid = fopen (fname, 'w'); 
  fdisp (fid, header);
  precision = 15; 
  fmt = [repmat(sprintf (" %%.%dg", precision), 1, 5) "\n"];
  fprintf (fid, fmt, [x y h u v].');
  fclose(fid);

endfunction 


