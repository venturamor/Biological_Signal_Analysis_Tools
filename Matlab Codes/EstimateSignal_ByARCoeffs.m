function [Sig_hat,err] = EstimateSignal_ByARCoeffs(Sig,Fs,a_hat,L)
% brief: check if coeff correct by copmaring estimated signal and real
%        signal
% useful functions: randn
% input:    
%           Sig         - refrence signal (start of it)
%           a_hat{}     - AR coeffs (L order) 
%           L           - number of coeffs, order
% output:
%           Sig_hat      -   estimated signal
%           err          -   Normalized error compare to real Signal

% comments: 
dt = 1/Fs;
WN = randn(length(Sig),1);
% eegRef_hat = filter(1,a_hat{1,1},WN);

% estimating each point by previous L(10) points
Sig_hat = zeros(length(Sig),1);
Sig_hat(1) = WN(1);
for indn=2:length(Sig) % indn = time unit
    temp = 0;
   if indn > L % in case there are 10 previous points
       for k=1:L
           temp = temp + a_hat{1,1}(k)*Sig(indn-k);
       end
   end
   if indn <= L % there's no L previus points
       for k=1:indn-1
           temp = temp + a_hat{1,1}(k)*Sig(indn-k);
       end   
   end
   Sig_hat(indn) = WN(indn) - temp;
end

% plot
 tRef = (0:dt:length(Sig)*dt)'; tRef(end)=[];
 figure; subplot(2,2,[1,2]); grid on; axis on;
 plot(tRef,Sig); hold on; plot(tRef, Sig_hat,'redo-');
 title('Original Sig vs reconstructed '); grid on; axis on;
 legend('SigRef','SigRef estimated');
 
 % error
 err = Sig_hat- Sig'; % in case error - delete : '
%MSE = (eegRef_hat-eegRef).^2;

subplot(2,2,3);
stem(tRef,err);
title('Error');

subplot(2,2,4);
err_normalized = err ./ max(err);
stem(tRef,err_normalized);
title('Error Normalized');
