function [Sxx_hat_AR,Rxx_hat_AR,tau_ax,f_ax] = Sxx_Parametric_Estimate(x,Fs,L)
% brief: estimate the Sxx - spectrom by adjusting AR model
% useful functions: 
% input:    
%           x          -   data
%           fs          
%           L           - order for the AR model
% output:
%           Sxx_hat_AR      -   estimation of Sxx
%           Rxx_hat_AR      -   
%           tau             -   tau axais for Rxx
%           f_ax            -   f axis for Sxx


% comments: 

N = length(x);
df = Fs/N;
f_ax = -Fs/2:df:(Fs/2 - df);
%adjust AR model 
[Rxx_vec,tau_ax] = xcorr(x);
[~,Rxx0_ind ] = max(Rxx_vec);
Rxx_toep = toeplitz(Rxx_vec(Rxx0_ind : Rxx0_ind + L - 1));
r_hat = -( Rxx_vec(Rxx0_ind + 1 : Rxx0_ind + L) ); 
a_hat = (Rxx_toep\r_hat')' ;
% % find the creating noise for sigma_w 
% 
w  = filter([1 a_hat],1,x);
sigma2_w = var(w);

% create the transmission function
theta = 2*pi*f_ax/Fs;
z     = exp(-1i*theta);
A     = ones(size(z));
for i=1:L
    A = A + a_hat(i)*z.^i;
end 
Sxx_hat_AR = sigma2_w./(abs(A)).^2 ; 
Rxx_hat_AR = abs(fftshift(ifft(Sxx_hat_AR)));
end

    