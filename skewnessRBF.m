## Copyright (C) 2015 ABINAYA
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

## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} skewnessRBF (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn
## Author: ABINAYA <ABINAYA@ABINAYA-PC>
## Created: 2015-02-05

function [skewness] = skewnessRBF (cpu, ram)
  averagePMTotalResources = (cpu+ram)/2;  
  skewFactor_one =(cpu/averagePMTotalResources-1)^2;
  skewFactor_two =(ram/averagePMTotalResources-1)^2;
  skewness = sqrt(skewFactor_one+skewFactor_two);
endfunction
