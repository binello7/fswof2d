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
## Created: 2017-12-04

## -*- texinfo -*-
## @defun topo2file (@var{x}, @var{y}, @var{z})
## @defunx topo2file (@dots{}, @var{filename})
## Write topography file.
##
## Given vectors of @var{x}, @var{y}, @var{z} values prints them to a file.
## All values have to be given in FullSWOF_2D format (compare function
## @code{dataconvert}).
##
## If no @var{filename} is specified the default name
## @code{topography.dat} is used.
##
## @seealso{dataconvert, huv2file}
## @end defun

function topo2file (x, y, z, fname='topography.dat')

  header = {
'#==============================================================', ...
'# POINTS LIST', ...
'# automatically generated by topo2file.m on %s', ...
'#==============================================================', ...
'# x, y, z', ...
'#--------------------------------------------------------------'
  };
  header  = strjoin (header, "\n");
  timetxt = strftime ("%Y-%m-%d %H:%M:%S", localtime (time ()));
  header  = sprintf (header, timetxt);

  fid = fopen (fname, 'w');
  fdisp (fid, header);
  precision = 15;
  fmt = [repmat(sprintf (" %%.%dg", precision), 1, 3) "\n"];
  fprintf (fid, fmt, [x y z].');
  fclose(fid);

endfunction
