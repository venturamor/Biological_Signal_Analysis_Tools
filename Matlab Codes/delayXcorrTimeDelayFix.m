function [delay,sig_fix2] = delayXcorrTimeDelayFix (sig1,sig2,fs)
% input: 
% sig1
% sig2
% fs

% Output 
% delay in seconds
% sig_fix2 - corrected delayed signal;

t_end = length(sig1)/fs;
dt=1/fs;
t_sig = 0:1/fs:t_end; t_sig(end)=[];

xCorrSigs = xcorr(sig1,sig2);
tau = linspace(-t_end, t_end, length(xCorrSigs)); % time for xcorr
[~,ind] = max(xCorrSigs);
delay = -tau(ind);
%plot
figure();
plot(tau,xCorrSigs);
title('Cross-correlation between Signal 1 and Signal 2');
xlabel('\tau[sec]');
ylabel('Amplitude');


if abs(delay)>0
    z = zeros(round(delay*fs),1);
    if delay>0
    sig_fix2 = [sig2(round(delay*fs)+1:end);z];
    else
    sig_fix2 = [z ; sig2(1:end-round(delay*fs))];
    end
end

figure()
subplot(2,1,1); plot(t_sig,sig1); hold on; plot(t_sig,sig2);
legend('sig1 before','sig2 before');
subplot(2,1,2); plot(t_sig,sig1); hold on; plot(t_sig,sig_fix2);
legend('sig1', 'sig2 fixed');

end