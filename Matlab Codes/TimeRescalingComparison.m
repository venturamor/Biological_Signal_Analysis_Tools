function [E,tspikeshom] = TimeRescalingComparison(lambdat,Tau)
% brief: function generates homogenous poisson process depending from a
%       process with stochastic intensity function lamda(t) with intervals vactor
%       Tau assuming the first interval is calculated from zero. the output is
%       the intervals in the homogenous Time-Rescaled poisson process (supposed
%       to be distrubiotion ~ Exp(1)) and the appropriate spikes
%       useful functions: cumsum
% input:    
%           lambdat       -   given stochastic intensity of our PP,(write math func @)
%           Tau           -   

% output:
%           tspikeshom       -   simulated spike times for PP with lambdat
%           E


% spiking time
 tspikes = cumsum(Tau);
% init
tlow = 0; % lower bound integral
thigh = tspikes(1); % inot higer inegration bound
h = waitbar (0,'Please wait...'); 
E = zeros(1,length(tspikes)-1); %init output

% integrate on lambda(t) to calculate EN
for i=1:numel (tspikes)-1
    E(i) = integral(lambdat, tlow, thigh); % current integration result
    tlow = thigh;
    thigh = tspikes (i+1);
    waitbar(i/(numel(tspikes)-1))
end
close(h);

% spike in the homogenous axis
tspikeshom = cumsum(E);


end

