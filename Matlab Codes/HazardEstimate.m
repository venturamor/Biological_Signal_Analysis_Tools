function [hazard,tauaxis] = HazardEstimate(tau,nbins)
% brief: estimates the hazard function of a process depending on it's
% intervals vector and specified number of bins in the histogram
% [event/sec]
% useful functions: 
% input:    
%           tau          -   input intervals vector
%           nbins        -   number of bins in the histogram
% output:
%           hazard          -   estimated hazard function
%           tauaxis         -   appropriate tau axis

figure(); % fig to hist %2875
h = histogram(tau, nbins,'Normalization','pdf','BinLimits',[0 max(tau)]);
delta = h.BinWidth; % extract the binwidth
denom = flipud(cumsum(flipud(h.Values(:)))).*delta;
hazard = h.Values(:) ./ denom; %estimate the hazard function
hazard = [0; hazard];
tauaxis = (h.BinEdges(1:end-1) + h.BinEdges(2:end)) ./2;
tauaxis = [0 tauaxis];
%close 2875;

end

