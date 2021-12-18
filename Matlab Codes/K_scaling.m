function [] = K_scaling(K,tau,rel_err)
% brief: K-scaling (depenadency)
% useful functions: 
% input:    
%           K          -   num of taus (gaps)
%           tau        -   gaps  tau
%           err        -   relative error threshold (~0.1)
% output:
%           plot
%           disp result

% comments: 
var_tau = var(tau);
for k=1:K
    for i=1:length(tau)-k
        tau_k(i) = sum(tau(i:i+k-1));
    end
    var_tau_k(k) = var(tau_k);
end
p1 = polyfit(1:K, var_tau_k,1); % line equation
relative_err = abs((p1(1)-var_tau)/var_tau);

%if(var_tau ~= p1(1)) % or var_tau_k(1)
str = ['slope: ', num2str(p1(1)),' var: ', num2str(var_tau),' relative error: ',num2str(relative_err)];
if(relative_err <= rel_err) 
    disp ('not dependant');
else
    disp ('depenadent');
end
disp(str);
figure(); 
plot(1:K, var_tau_k);
ylabel('Var - Tau K'); xlabel ('k');
title('K-Scaling');
end

