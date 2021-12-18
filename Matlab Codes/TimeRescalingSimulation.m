function [tspikes] = TimeRescalingSimulation(lambdat,Ttot,deltaint)
% brief: stimulates a point process depending on it's stochatic intensity
%        lambda(t) function, for a desired Ttot period of time.
%        the numerical integration is carried out in steps of deltaint
%        (minimal interval value)
% useful functions: cumtrapz
% input:    
%           lambdat    @  -   given stochastic intensity of our PP
%           Ttot          -   total "experiment" q stimulation length
%           deltaint      - minimal interval value/ numerical integration
%                           difference
% output:
%           tspikes       -   simulated spike times for PP with lambdat
%           plot          - plot the new pp
% comments: 

intaxis = (0:deltaint:Ttot)'; % the integration time axis
intval = cumtrapz(intaxis, lambdat(intaxis)); % the integral evaluated at each point
E = exprnd(1); %initial threshold
ind = find(intval >= E);% find the initial spike time
tspikes = intaxis (ind(1)); % initial spike time
thigh = tspikes; %init the upper integral time limit
h = waitbar(0,'Please wait...'); % add wait bar

% integrate and out
while thigh < Ttot
    intval = intval - intval(ind(1)); % current integral value
    E = exprnd(1); % cast a new threshold
    % find the appropriate spike time
    ind = find(intval >=E);
    if isempty (ind)
        break;
    end
    tspikescurr = intaxis(ind(1)); % current spike time
    tspikes = [tspikes tspikescurr]; % save the result
    thigh = tspikescurr; % new upper bound
    waitbar(thigh/Ttot); % update wait bar
end
close(h); %close waitbar

% plot
figure();
fplot(@(t) lambdat(t));
hold on; stem(tspikes,ones(1,length(tspikes)));
title('Simulation Using Time Rescaling'); xlabel('t [sec]'); ylabel('AMP');
legend('\lambda(t)','Sim.PP'); 
xlim([0 Ttot]); 
%ylim([0 max(lambdat(t))]);
% if ther's problem in ylim: insert fs as param and line: 
% t = 0:1/fs:Ttot; t(end)=[];


end


