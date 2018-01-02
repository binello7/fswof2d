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
## @defun {[@var{y},@var{z},@var{params},@var{yi},@var{zi}] =} 
##              csec_channel2lvlsym (@var{N}, @var{PROP}, @var{VAL})
## Generate a two levels trapezoidal cross-section.
##
## The generated cross-section s composed of embankments, floodplains, river 
## banks and riverbed. The length of these elements, as well as the channel and 
## embankments height is defined by the user.
##
## If @code{N} is a scalar then the cross-section generated will be composed of 
## @code{N} segments of equal length.
##
## If @code{N} is a @code{struct}, then the value associated with 
## @code{Embankment}, @code{Plain}, @code{RiverBank} and @code{RiverBed} 
## represents the number of segments of each one of these sections.
##
## @strong{Properties}:
## 
## @table @asis
## @item "Embankment"
## 10, isscalar (x), x > 0
## @item "Plain"
## 40, isscalar (x), x > 0
## @item "RiverBank"
## 5, isscalar (x), x > 0
## @item "RiverBed"
## 30, isscalar (x), x > 0
## @item "BankHeight"
## 3, isscalar (x), x > 0
## @item "EmbankmentHeight"
## 10, isscalar (x), x > 0
## @end table
## @seealso{extrude_csec}
## @end defun

function [y z p yi zi] = csec_channel2lvlsym (N, varargin)
  
  ### DEFAULT INIZIALIZATION OF THE FUNCTION ###
  parser = inputParser ();
  parser.FunctionName = 'csec_channel2lvlsym';

  checker = @(x) isscalar (x) || x > 0;

  parser.addParamValue ("Embankment", 10, checker);
  parser.addParamValue ("Plain", 40, checker);
  parser.addParamValue ("RiverBank", 5, checker);
  parser.addParamValue ("RiverBed", 30, checker);

  parser.addParamValue ("BankHeight", 3, checker);
  parser.addParamValue ("EmbankmentHeight", 10, checker);

  parser.parse (varargin{:});
  p = parser.Results;

  dy  = [0 p.Embankment p.Plain p.RiverBank p.RiverBed/2].';
  yi  = cumsum (dy);
  yi  = [yi(1:end-1); yi(end) + cumsum(flipud (dy(2:end)))];

  dz = [zeros(1,2) p.BankHeight 0 p.EmbankmentHeight].';
  zi = cumsum (dz);
  zi = [flipud(zi(2:end)); zi(2:end)];

  if isstruct (N)

    fname = {"Embankment", "Plain", "RiverBank","RiverBed"};
    nf    = [1:4 3:-1:1];
    y     = [];
    for i = 1:length(nf)
      f   = fname{nf(i)};
      n   = N.(f);
      tmp = linspace (yi(i), yi(i+1), n + 1).';
      if isempty(y)
        y = tmp;
      else
        y = [y; tmp(2:end)];
      endif
    endfor

  else
    y = linspace (0, yi(end), N+1).';
  endif

  z = interp1 (yi, zi, y);

endfunction

%!demo
%! [y z p yi zi] = csec_channel2lvlsym (140);
%! plot(y,z,'s-;mesh;',yi,zi,'*;knots;')
%! axis tight

%!demo
%! n = struct("Embankment",20, "Plain",10,"RiverBank",20,"RiverBed",10);
%! [y z p yi zi] = csec_channel2lvlsym (n);
%! plot(y,z,'s-;mesh;',yi,zi,'*;knots;')
%! axis tight

