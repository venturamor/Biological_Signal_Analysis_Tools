function pred_model = MMSE_model(samples,t,paramsVec)
% brief: finding params by MSE and compare predicted model with those
%        params to existing model
% useful functions: lsqnonlin (or fminsearch), 
% input:    
%           samples    -   given samples
%           t          -   time vec
%           paramsVec  - [] params. order set the x(i) in equation
% output:
%           pred_model -   mmse params in equation
%           MSE        -   display in cmdWin


% comments: example params   = [miu,sigma,AUC,t0,I0]
%           example equation = pdf_logNormal = @(x)sum((samples(ind:end)-(x(3)./((t(ind:end)-x(4)).*(sqrt(2*pi)*x(2))).*exp(-((log(t(ind:end)-x(4))-x(1)).^2)./(x(2)^2*2))+x(5))).^2);
%           fill equation!

% finding optimal params by MSE for predicted model
equation = @(x)sum((samples(ind:end)-(x(3));
% example params = [miu,sigma,AUC,t0,I0];
% x = fminsearch(pdf_logNormal,params); %MSE 
x = lsqnonlin(pdf_logNormal,paramsVec);

% predicted(analytic) model
pred_model= zeros(size(samples));
rel_time = find(t >= x(4)); % before t0 the signal is 0
start_time = rel_time(1);
time_new = t(start_time:end);
pred_model(start_time:end) = (x(3)./((time_new-x(4)).*sqrt(2*pi).*x(2))).*exp(-((log(time_new-x(4))-x(1)).^2)./(2*sigma^2))+x(5);

% calculating MMSE between samples to expected model
MMSE = sum((samples - pred_model).^2)/length(samples);
disp (num2str(MMSE));
% plot
figure();plot(t,samples);hold on;
plot(t,pred_model,'LineWidth',2);
xlabel('time[sec]');ylabel('amplitude');
title('samples vs. predicted model');
legend('samples','predicted model');
end

