function delay = delayXcorrTime (sig1,sig2,t_end)
% xcorr in time domain. delay calc
xCorrSigs = xcorr(sig1,sig2);
tau = linspace(-t_end, t_end, length(xCorrSigs)); % time for xcorr
[~,ind] = max(xCorrSigs);
delay = -tau(ind);
% %plot
% figure();
% plot(tau,xCorrSigs);
% title('Cross-correlation between Signal 1 and Signal 2');
% xlabel('\tau[sec]');
% ylabel('Amplitude');

end
