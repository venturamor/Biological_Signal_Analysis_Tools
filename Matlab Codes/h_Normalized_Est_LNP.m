function [h,tau,kg] = h_Normalized_Est_LNP(w,times,Fs,tau_min,tau_max)
% brief: estimating h in LNP cascade (from given PP (given times)) (up to const)
% useful functions: 
% input:    
%           w           -   white noise
%           times       -   time of Point Process
%           Fs          -   Freq sample
%           tau_min     -   lower boundery for cropping 
%           tau_max     -   upper boundery for cropping
% output:
%           h          -   noralized h by it's norm(2)


% comments: 

N = length(w);
t = (0:N-1)./Fs;
PP = zeros(N,1); % Point Process
PP(round(times*Fs)) = ones(size(times)); %spikes at given times

%find the idx of the first spike

idx_first = find(PP==1,1);
%tau axis
[~,tau] = xcorr(PP,w,idx_first); %limits the lag range from -(idx_first) to (idx_first)

[Rww,tauw] = xcorr(w);
[RwN,tauwN] = xcorr(w,PP);
hgal = flipud(RwN)/Rww(tauw==0); % estimate the compound system (LN)

% norm restrication and cropping only the central part to reduce noise
h = hgal(tauwN >= tau_min & tauwN <= tau_max )/ ...
    norm(hgal(tauwN >= tau_min & tauwN <= tau_max),2);



% Nonlinear constant
kg = norm(hgal(tauwN >= tau_min & tauwN <= tau_max),2);


end

