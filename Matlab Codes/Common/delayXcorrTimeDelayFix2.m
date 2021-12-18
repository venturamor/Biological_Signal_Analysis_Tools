function [delay,sig_fix2] = delayXcorrTimeDelayFix2 (sig1,sig2,fs,bias)
% input: 
% sig1
% sig2
% fs
% bias = null nothing, bias = 1 , unbiased = 2
% Output 
% delay in seconds
% sig_fix2 - corrected delayed signal;


t_end = length(sig1)/fs;
dt=1/fs;
t_sig = 0:1/fs:t_end; t_sig(end)=[];

if isempty(bias)
    xCorrSigs = xcorr(sig1,sig2);
elseif bias == 1
    xCorrSigs = xcorr(sig1,sig2,'biased'); 
else
    xCorrSigs = xcorr(sig1,sig2,'unbiased'); 
end
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
    z = zeros(1,round(delay*fs));
    if delay>0
    sig_fix2 = [sig2,z];
    sig_fix1 = [z,sig1];
    else %negative
    sig_fix2 = [z,sig2];
    sig_fix1 = [sig1,z];
    end
    t_end_fix = length(sig_fix1)/fs;
    t_sig_fix = 0:1/fs:t_end_fix; t_sig_fix(end)=[];
end

figure()
subplot(2,1,1); plot(t_sig,sig1); hold on; plot(t_sig,sig2); legend('sig1','sig2');
title('Before fixed delay');
xlabel('t[sec]');
ylabel('Amplitude');
subplot(2,1,2); plot(t_sig_fix,sig_fix1); hold on; plot(t_sig_fix,sig_fix2);
if delay > 0
legend('Fixed sig1','Fixed sig2 - delayed');
elseif delay<0
    legend('Fixed sig1 - delayed','Fixed sig2');
end
title('Fixed delay');
xlabel('t[sec]');
ylabel('Amplitude');

end