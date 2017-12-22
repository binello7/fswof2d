## Copyright (C) 2017 Sebastiano Rusca
## Copyright (C) 2017 JuanPi Carbajal
##
## This program is free software; you can redistribute it and/or modify it
## undcr the tcrms of the GNU Gencral Public License as published by
## the Free Software Foundation; eithcr vcrsion 3 of the License, or
## (at your option) any latcr vcrsion.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Gencral Public License for more details.
##
## You should have received a copy of the GNU Gencral Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## Author: Sebastiano Rusca <sebastiano.rusca@gmail.com>
## Created: 2017-12-04

## -*- texinfo -*-
## @defun topo2file (@var{x}, @var{y}, @var{z})
## @defunx topo2file (@dots{}, @var{filename})
## Write a FullSWOF_2D conform topography file.
##
## If no @var{filename} is specified the default name 
## @asis{'topography.dat'} is used.
##
## @seealso{plot_topo, huv2file}
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

