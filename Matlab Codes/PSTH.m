function [PSTH_m]=PSTH (tau,t_Interval, nbins)
% brief: estimating intensity function (rythem) given samples
% useful functions: 
% input:    
%           tspikes            -   vector of gaps (if alredy times - rm
%                                  first code line)
%           Ttot               -   total time duration
%           t_Interval         -   time for one experiment (interval)
%           nbins              -   number of bins
% output:
%           PSTH               -   typical reaction (avg) to stimulation.
%                                  lambda estimating in one interval
%           bar graph of PSTH

% comments: 

tspikes = cumsum(tau); %RM in case already times  and write tspikes = tau;
Ttot = tspikes(end);
K = floor(Ttot/t_Interval); % number of repetitions
delta = t_Interval/nbins; % width of each bin

for m=0:nbins-1 % bin
    for k=0:K-1 % reptition
        % c - number of events in bin
        c(k+1) = sum((tspikes > (m+k*nbins)*delta) & (tspikes <= (m+1+k*nbins)*delta));
    end
    PSTH_m(m+1) = (1/(K*delta))*sum(c);
end
figure();
bar((0:delta:20-delta) + delta/2, PSTH_m);
xlabel('time [Sec]'); ylabel('firing rate [events/sec]'); 
title(['PSTH with nbins= ', num2str(nbins)]);

end