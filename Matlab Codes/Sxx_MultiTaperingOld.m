function [Sxx_hat,f_ax] = Sxx_MultiTapering(sig,fs)
% brief: Non parametric estimator for Spectrum by Multi tapering (DPSS)
% useful functions:dpss 
% input:    
%           sig          
%           fs          
% output:
%           Sxx_hat         
%           f_ax
%           plot Sxx Multu Tapering vs prediogram       

% comments: simple average over dpss windows

N = length(sig);
f_ax = (0:N-1)./N*fs -fs/2; % f axis
t_ax = (0:N-1) ./fs; % time axis

% dpss windows specification and generation
W = 3/N; % half bandwidth parameter
NW = N*W; % time - half bandwidth parameter
M = 2*NW -1 ; %number of windows
windows = dpss(N,NW,M);

% calculate fft of the windowed signal and the windows
Vf = fftshift(fft(windows,[],1),1);
Xf = fftshift(fft(repmat(sig,1,M).*windows,[],1),1); % fft windowd signals

Sxx_hat = (1/M)*sum(abs(Xf).^2,2);



% Perdiogram for comparison
Xk = abs(fftshift(fft(sig)));
Sxx = (1/N)*(abs(Xk).^2);
f = (0:N-1)./N*fs -fs/2 ; 



figure(); 
plot(f,Sxx,'--', 'LineWidth',0.1)
hold on;
plot(f_ax,Sxx_hat);
legend('True Sxx' , 'Multi Tapering')
xlabel('$f[Hz]$','Interpreter','Latex')
ylabel('$Amplitude$','Interpreter','Latex')
title('$Estimate \ S_{xx} $','Interpreter','Latex')