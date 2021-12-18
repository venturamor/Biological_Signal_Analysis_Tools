function [sig_filtered_FIR] = FIR_LPF_MA(sig,windowLen)
% brief: FIR LPF - Moving Average 
% useful functions: conv
% input:    
%           sig 
%           windowLen     - vec of Window Lengthes (example 2:100)
% output:
%           sig_filtered_FIR          
%           plot (mse(windowLen)
%           plot filtered sig after LPF FIR with WinChosenLength

% comments: fill WinChosenLength for plot.
sig_filtered_FIR = {}; % avoiding dim determination
for indLen=1:length(windowLen)
    % moving average filter
    filter_lp = (1/windowLen(indLen))*ones(1,windowLen(indLen));
    sig_filtered_FIR{indLen} = conv(sig,filter_lp,'same');
    mse(indLen)= mean((sig-sig_filtered_FIR{indLen}).^2);
end

sig_filtered_FIR = cell2mat(sig_filtered_FIR);
WinChosenLength = 98; 
figure(); plot(t,[sig sig_filtered_FIR(:,WinChosenLength)]);legend('y', 'y filtered'); 
title('original signal and filtered FIR LPF version')

figure(); plot(windowLen,mse);xlabel('window length'); ylabel('MSE');
title('MSE(window Length)');
% MSE is getting bigger as the window length, (the LPF is getting more effective)

% figure();freqz(ones(1,100),1); % sanity-test
% figure();zplane(ones(1,50),1);
end

