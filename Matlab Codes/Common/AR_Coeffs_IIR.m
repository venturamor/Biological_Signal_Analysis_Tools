function [a_hat] = AR_Coeffs_IIR (x,orders,R_or_Sig)
% calculate AR coefficients of given signal or Rxx (x) by Yule-Walker equations
% orders - vector of orderes to examine
% useful funcs: xcorr, toepliz, inv 
%(aryule, arx, levinson, lpc - not allowed)
% 1 coeff added

a_hat = {};
if(regexp(R_or_Sig,'Sig')) % if sig
    [x,tau_xx]= xcorr(x);
end
for indL = 1:length(orders)
    order = orders(indL); 
    [~,Rxx0_ind ] = max(x);
    Rxx_toep = toeplitz(x(Rxx0_ind : Rxx0_ind + order - 1));
    r_hat{indL} = - x(Rxx0_ind + 1 : Rxx0_ind + order); 
    a_hat{indL} = [1 (Rxx_toep\r_hat{indL}')'] ;
end

end