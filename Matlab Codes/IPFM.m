function [tspikes] = IPFM(R,m,t,dt)
% brief: IPFM - Integral Pulse Frequency Modulation
%        simulation of point process. good for determin process as heart
%        beat rate.
%        scheme: m0+m(t) > integrator > y(t) [threshold R (only y>R)]
% useful functions: cumsum
% input: 
%           m          - numerical rate (mean + changes(t)). example: m = 0.1*ones(1,3000) + abs(cos(0.5*2*pi*t));
%           R          - threshold (example = 0.2)
%           t,dt       - example(linspace(0,2,3000),1/1000)
% output:
%           tspikes          


% comments: 

% time axis and increment for integration

% rate function m(t), numerical integral, and threshold for firing

I = cumsum(m)*dt;

% IPFM sim
k=1; Ishort = I; t0=0; %init
tspikes = [];
while Ishort(end) > R
    tspikes(k) = find((Ishort-R)>=0,1) + t0; % kth spikes time
    Ishort = I(tspikes(k):end) - I(tspikes(k)); % remaining integral
    t0 = tspikes(k); % time from which the (k+1)th spike is found
    k = k + 1; % advance counter
end


end

