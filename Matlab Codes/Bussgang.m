function [h_est,f_est] = Bussgang(lambda,W,Fs,alpha,order)
% brief: LNL system
% useful functions: 
% input:    
%           lambda          -   final measurement after h(linear) and f(non
%                               linear)
%           W               -   input signal. if not given - put
%                               WhiteNoise(lambda size)
%           Fs              -   freq sample
%           alpha           -   level of correctness (statistic)(ex: 1
%                               (1%))
%           order           -   order of f function polynom (ex: 4)

% output:
%           h_est          -   normalized linear filter estimated
%           f_est          -   nonlinear function estimated
%           plot 

% comments: CHOOSE NORMALITATION FUNCTION as requested (default = abs) 
if (isempty(alpha)) % if not given - defaulte = 1 (by HW)
    PA.percentile = 1;
else
    PA.percentile = alpha;
end
dt = 1/Fs;
% From busganag:
ac_R_ww = xcorr(W,W); cc_S_ww = fft(ac_R_ww); % AutoCorolation W,W
cc_R_wlambda = xcorr(W,lambda); cc_S_wlambda = fft(cc_R_wlambda); % CrossCorolation W,lambda

h_est.H=conj(cc_S_wlambda./cc_S_ww);
h_est.a=ifftshift(ifft(h_est.H));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHOOSE NORMALITATION FUNCTION:
h_est.norm = sum(abs(h_est.a)); % From HW
% h.norm = sum(h.a.^2);

h_est.a=h_est.a/h_est.norm;
 
h_t = (-(length(W)-1):1:length(W)-1)/Fs;
figure();
plot(h_t,h_est.a);
title('$$\hat{h}$$','Interpreter','Latex'); xlabel('time [sec]'); ylabel('Amp - normalized');

% finding x(t) by using h filter on w
h_est.b=1;
x_hat = filter(h_est.a(length(W):end),h_est.b,W);
x_t = 0:dt:length(x_hat)*dt; x_t(end)=[];

figure();
plot(x_t,x_hat);
title('$$\hat{x}$$','Interpreter','Latex'); xlabel('t[sec]'); ylabel('Amp');

figure(); 
scatter(x_hat,lambda');

% Estimating x,Lambda by Polyfit:
% Poly.xL.order = 2; 
% Poly.xL.coeffs = polyfit(x.hat,LN.lambda,Poly.xL.order);
% Poly.xL.x_fit = polyval(Poly.xL.coeffs,x.hat);
% hold on;
% plot(x.hat,Poly.xL.x_fit,'g','LineWidth',2)


% Precentiles Analysis: f(.):
PA.percent = 0:PA.percentile:100;
PA.quantile = prctile(x_hat,PA.percent);
for i = 1:length(PA.quantile)
     if i == 1 
         temp_x = x_hat(x_hat<PA.quantile(i));
         temp_lamb = lambda(x_hat<PA.quantile(i));
         x_mean(i) = mean(temp_x);
         lambda_mean(i) = mean(temp_lamb);
     else
         temp_x = x_hat(x_hat>PA.quantile(i-1) & x_hat<PA.quantile(i));
         temp_lamb = lambda(x_hat>PA.quantile(i-1) & x_hat<PA.quantile(i));
         x_mean(i) = mean(temp_x);
         lambda_mean(i) = mean(temp_lamb);
     end
end
clear temp_lamb temp_x i

hold on;
plot(x_mean,lambda_mean,'r','LineWidth',2);  
legend('Original',['Mean ' num2str(PA.percentile) '%']);
xlabel('x(t)'); ylabel('\lambda(t)');  
title('Precentiles Analysis: \lambda(t)=f(x(t))');

% Estimating f(.) by Polyfit:
f_est.order = order; 
f_est.coeffs = polyfit(x_mean(2:end),lambda_mean(2:end),f_est.order);
f_est.fit = polyval(f_est.coeffs,x_mean);


figure(); 
plot(x_mean,lambda_mean, 'r','LineWidth',2); hold on; plot(x_mean,f_est.fit,'--b','LineWidth',2);
legend(['Mean ' num2str(PA.percentile) '%'],['Polyfit order ' num2str(f_est.order)]);
xlabel('x(t)'); ylabel('\lambda(t)');  title('Modelling f(x(t))');

end