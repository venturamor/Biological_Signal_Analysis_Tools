function [a_hat] = AR_Coeffs (x, orders)
% calculate AR coefficients of given signal (x) by Yule-Walker equations
% orders - vector of orderes to examine
% useful funcs: xcorr, toepliz, inv 
%(aryule, arx, levinson, lpc - not allowed)
% 1 coeff added
for indL = 1:length(orders)
    order = orders(indL); 
    Rxx_vec= xcorr(x);
    [~,Rxx0_ind ] = max(Rxx_vec);
    Rxx_toep = toeplitz(Rxx_vec(Rxx0_ind : Rxx0_ind + order - 1));
    r_hat{indL} = - Rxx_vec(Rxx0_ind + 1 : Rxx0_ind + order); 
    a_hat{indL} = [1 (Rxx_toep\r_hat{indL})'] ;
end
end