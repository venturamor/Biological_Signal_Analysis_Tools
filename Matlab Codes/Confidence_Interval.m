function [L_confidence,U_confidence,Gxx_hat] = Confidence_Interval(alpha,Sxx_hat,x,Fs)

% brief: create confidence interval for estimate Sxx
%        with level of confidence alpha.
% important comment: written specificly to Gxx estimation. 
% useful functions: 
% input:    
%           alpha   - requird level of confidence. example alpha=0.05. 
%           Sxx_hat - estimated spectrom (by AR/Tapering/welch...)
%           x       - original signal
%           Fs      
% output:
%           L_confidence          -   lower bound
%           U_confidence          -   higher bound
%           Gxx_hat

% comments: !!! change k as the number of windows. if only no windows - k =1;

k=1;

figure();
h1  = histfit(x,[] ,'Normal');
pd1 = fitdist(x , 'Normal');
xlabel('$time[sec]$','Interpreter','Latex')
ylabel('$counts[.]$','Interpreter','Latex')
title('$Signal \ 1$','Interpreter','Latex')
legend('$Histogram$', ...
    [ '$Normal: \ \mu \ =$' num2str(pd1.mu) '$ \ \sigma =$' num2str(pd1.sigma)],...
    'Interpreter','Latex')


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

figure();
errorbar(oneside_f,Gxx_hat,L_confidence,U_confidence)
hold on;
plot(oneside_f,Gxx_hat, 'LineWidth',1)
title(['$PSD \ estimate \ with \ $' num2str((1-alpha)*100)...
    '$ \ percentage \ Confidence \ Interval$'],'Interpreter','Latex')

figure;
plot(oneside_f,Gxx_hat); hold on;
plot(oneside_f,abs(L_confidence),'r--'); 
plot(oneside_f,abs(U_confidence),'g--');
title('Confidence interval of Signal 1');
xlabel('f[Hz]'); ylabel('AMP');
legend('$$\hat{G}_{sig1}(f)$$','Lower Bound','Upper Bound','Interpreter','Latex');


end