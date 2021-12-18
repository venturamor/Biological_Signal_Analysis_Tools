function [Sxx_hat,f_hat] = Sxx_Welch(Sig,Window,normfact,Fs,alpha,overLap)
% brief: Non parametric estimator for Spectrum by "Bartlett Upgarde"
%        (overlapping)
% useful functions: 
% input:    
%           Sig          
%           Window       -   window - hann for classic welch
%           normfact     -   
%           Fs           -   
%           alpha        -   if 0 - don't calc confidence interval
%           overLap      -   jumping interval of window (for highest resolution
%                            = 1)
% output:
%           Sxx_hat         
%           f_hat 
%           confidence interval (for analytic signal)
%           plot Sxx Barttlet vs prediogram

% comments: 

N = length(Sig);
L = length(Window);
k = floor(N/L);

count = 0;
for i=1:overLap:(N-L+1) % overlapping 
  x_win = Sig(i:(i+L-1)).*Window;
  Sxx_win(i,:) = normfact.*(abs(fftshift(fft(x_win))).^2);
  count = count + 1;
end

Sxx_hat = (1/(count*L))*sum(Sxx_win); % avg intervals
f_hat   = linspace((-Fs/2),(Fs/2 - Fs/L),length(Sxx_hat));

% Perdiogram for comparison
Xk = abs(fftshift(fft(Sig)));
Sxx = (1/N)*(abs(Xk).^2);
f = (0:N-1)./N*Fs -Fs/2 ; 


figure(); 
plot(f,Sxx,'--', 'LineWidth',0.1)
hold on;
plot(f_hat,Sxx_hat);
legend('True Sxx' , 'Welch')
xlabel('$f[Hz]$','Interpreter','Latex')
ylabel('$Amplitude$','Interpreter','Latex')
title('$Estimate \ S_{xx} \ with \ resolution = Hz$','Interpreter','Latex')

figure();
plot(f,mag2db(Sxx),'--', 'LineWidth',0.1)
hold on;
plot(f_hat,mag2db(Sxx_hat));
legend('True PSD' , 'Taper')
xlabel('$f[Hz]$','Interpreter','Latex')
ylabel('$Magnitude (dB)$','Interpreter','Latex')
title('$Power \ Spectral \ Density$','Interpreter','Latex')

if alpha ~= 0
    % Confidence Interval 
    chi_1 = chi2inv(alpha/2,2*k);
    chi_2 = chi2inv((1-alpha/2),2*k);
    Gxx_hat = 2*Sxx_hat(round(end/2):end);  %Gxx = 2/N |X[k]|^2 = 2Sxx 
    L_confidence = 2*k*Gxx_hat/chi_2;
    U_confidence = 2*k*Gxx_hat/chi_1;

    oneside_f = linspace(0,Fs/2,length(Gxx_hat));
    figure;
    plot(oneside_f,Gxx_hat)
    title('$Estimated \ One-Sided \ Spectrum$','Interpreter','Latex')
    xlabel('$f [Hz]$','Interpreter','Latex')
    ylabel('$G_x (f)$','Interpreter','Latex')

    figure;
    errorbar(oneside_f,Gxx_hat,L_confidence,U_confidence)
    hold on;
    plot(oneside_f,Gxx_hat, 'LineWidth',1)
    title(['$PSD \ estimate \ with \ $' num2str((1-alpha)*100)...
        '$ \ percentage \ Confidence \ Interval$'],'Interpreter','Latex')

end

end

