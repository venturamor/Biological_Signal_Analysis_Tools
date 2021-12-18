function [Indicator] = FindRWave(ECG,thresh)
% brief: assume - noised removed (the signal already denoised) - signal parallel to x-axis
%        detection by threshold and local maximum.
% useful functions: max
% input:    
%           ECG           -   signal
%           thresh        -   threshold by maximum val

% output:
%           Indicator          -   indices of R places

Indicator = zeros (size(ECG));
maxVal = max(ECG);

for i=2:length(ECG)-1
    if (ECG(i) > maxVal*thresh && ECG(i) > ECG(i-1) && ECG(i) > ECG(i+1)
        Indicator(i) = 1;
    end
end
end

