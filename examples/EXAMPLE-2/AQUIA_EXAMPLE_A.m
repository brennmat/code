% AQUIA_EXAMPLE.m
%
% Script that illustrates the use of NOBLEFIT.
%
% 1. Load data from file AQUIA_GW.txt (a subset of the noble gas data published in W. Aeschbach-Hertig, M. Stute, J. Clark, R. Reuter, and P. Schlosser. A paleotemperature record derived from dissolved noble gases in groundwater of the Aquia Aquifer (Maryland, USA). Geochim. Cosmochim. Acta, 66(5):797–817, 2002.)
%
% 2. Fit a model to the data: ASW(T) and EA(T,A,F) according to the CE model. He isotope data is ignored in this example.
%
% *******************************************************************
% This file is part of NOBLEFIT.
% 
% NOBLEGASFIT is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% NOBLEGASFIT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with NOBLEGASFIT.  If not, see <http://www.gnu.org/licenses/>.
%
% Copyright (C) 2013,2014 Matthias S. Brennwald.
% Contact: matthias.brennwald@eawag.ch
% Further information: http://homepages.eawag.ch/~brennmat/
% *******************************************************************


% *******************************************************************
% load data from data file
options.replace_zeros           = NA; % replace zero values in data file by NA
options.filter_InvIsotopeRatios = 1;  % try to replace isotope ratios in the form heavy/light by the inverse (light/heavy)
smpl = nf_read_datafile ('AQUIA_DATA.txt',options);


% *******************************************************************
% define the fit (model, varialbes/parameters, limits):
mdl = 'ASW_EAce';               % model: ASW and closed-system excess air
trc = {'Ne','Ar','Kr','Xe'};    % tracers used in the fits: Ne, Ar, Kr, and Xe
fp  = [1,0,0,1,1,0];            % fit temperature T, entrapped air A, and fractionation F
p0  = [8,0,0.944*1013.25,1E-3,0,1980];      % initial / fixed values for the fits (using the same values for all samples, S = 0 and p = 0.944 atm as in Aeschbach et al., GCA, 2002).
pSc  = [];                      % scaling factors for the fitter (empty, so the fitter determines values automagically)
pMin = [0,0,0,0,0,0];             % lower limits of fitted variable values (values of fixed parameters are not used)
pMax = [25,0,Inf,0.1,1,2020];        % upper limits of fitted variable values (values of fixed parameters are not used) 


% *******************************************************************
% fit the samples
[par_val,par_err,chi2,DF,pVal] = noblefit ( mdl , smpl , trc , fp, p0 , pSc , pMin , pMax );

% *******************************************************************
% save results to ASCII file
nf_save_fitresults ('AQUIA_FITRESULTS_A.txt',smpl,{'T (°C)','A (ccSTP/g)','F (-)'},par_val,par_err,chi2,DF,pVal,'Fit results from noblefit, fitted T-A-F fit with CE model to a subset of the noble gas data published in W. Aeschbach-Hertig, M. Stute, J. Clark, R. Reuter, and P. Schlosser. A paleotemperature record derived from dissolved noble gases in groundwater of the Aquia Aquifer (Maryland, USA). Geochim. Cosmochim. Acta, 66(5):797–817, 2002.');
