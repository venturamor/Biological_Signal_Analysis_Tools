function [Sxx_hat,f_ax] = Sxx_MultiTapering(sig,fs,NW)
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
% W = 3/N; % half bandwidth parameter
% NW = N*W; % time - half bandwidth parameter
M = 2*NW -1 ; %number of windows
[windows,mu] = dpss(N,NW,M);

% calculate fft of the windowed signal and the windows
Vf = fftshift(fft(windows,[],1),1);
Xf = fftshift(fft(repmat(sig,1,M).*windows,[],1),1); % fft windowd signals

Xk_hat = zeros(size(Xf));
for i=1:M
    Xk_hat(:,i) = mu(i)*abs(Xf(:,i)).^2 ;
end

Sxx_hat = (sum(Xk_hat,2)/(sum(mu)));



% Perdiogram for comparison
Xk = abs(fftshift(fft(sig)));
Sxx = (1/N)*(abs(Xk).^2);
f = (0:N-1)./N*fs -fs/2 ; 



figure; 
plot(f,Sxx,'--', 'LineWidth',0.1)
hold on;
plot(f_ax,Sxx_hat);
legend('True Sxx' , 'Multi Tapering')
xlabel('$f[Hz]$','Interpreter','Latex')
ylabel('$Amplitude$','Interpreter','Latex')
title('$Estimate \ S_{xx} $','Interpreter','Latex')

figure; 
plot(f,mag2db(Sxx),'--', 'LineWidth',0.1)
hold on;
plot(f_ax,mag2db(Sxx_hat));
legend('True Sxx' , 'Multi Tapering')
xlabel('$f[Hz]$','Interpreter','Latex')
ylabel('$dB$','Interpreter','Latex')
title('$Estimate \ S_{xx} $','Interpreter','Latex')
