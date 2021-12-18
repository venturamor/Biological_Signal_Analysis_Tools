function delay = delayXcorrFreq (sig1,sig2,fs, linearRange)
% xcorr in freq domain. delay calc
N = length(sig1);
T = N/fs; % num of samples / sample freq = time length

fft_sig1 = fftshift(fft(sig1));
fft_sig2 = fftshift(fft(sig2));

% convinient arrange for average adjacent points 
fft_sig1 = reshape((1/T)*fft_sig1,[2,N/2]); 
fft_sig2 = reshape((1/T)*fft_sig2,[2,N/2]);
meanSig1fft = mean(fft_sig1);
meanSig2fft = mean(fft_sig2);
% xCorr in freq domain
X_spectrum = (1/T)*meanSig1fft.*conj(meanSig2fft); %(1/T)* <.,.> (=cov) = Xcorr
M = length(X_spectrum);
f_Xspect = (0 : M - 1)./M*fs - fs/2;
% delay estimating
phaseXspect = unwrap(angle(X_spectrum));
% matching linear part in X_spectrum angle
p_coeff = polyfit(f_Xspect(linearRange),phaseXspect(linearRange),1); % first order polynom
fit = polyval(p_coeff,f_Xspect(linearRange));

delay = p_coeff(1)/(2*pi);

% % plots
% figure();
% plot(f_Xspect,phaseXspect);
% hold on;
% plot(f_Xspect(300:500),fit,'r--','linewidth',2);
% title('Phase of cross-spectrum and linear fit');
% xlabel('f[Hz]');
% ylabel('Amplitude');
% legend('Cross-spectrum phase','Linear fit');
% 
% figure(); plot(f_Xspect,X_spectrum); axis on;
% title('cross-spectrum');
% xlabel('f[Hz]');
% ylabel('Amplitude');


end
