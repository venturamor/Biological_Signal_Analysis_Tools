function [Sxx_hat,f_ax] = Perdiogram_Spectrum(Sig,Fs)
% brief: Non parametric estimator for Spectrum by Perdiogram -
%        DFT on signal, square. averaged
% input:    
%           Sig          
%           Fs           

% output:
%           Sxx_hat         
%           f_hat          

% comments: 
N = length(Sig);
Xk = abs(fftshift(fft(Sig)));
Sxx_hat = (1/N)*(abs(Xk).^2);
f_ax = (0:N-1)./N*Fs -Fs/2 ; 

% % in Rxx:
% Rxx = xcorr(Sig,N/2,'unbiased');
% Sxx_hat = abs(fftshift(fft(Rxx)));

end