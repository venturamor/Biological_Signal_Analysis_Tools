function [unbiased_xcorr,biased_xcorr,delay_unbiased,delay_biased] = Xcorr_unb_b_delay(sig1,sig2,t,dt)
% brief: unbiased xcorr / biased xcorr, and delay
% useful functions: xcorr, max
% input:    
%           sig1,sig2         
%           t, dt          
% output:
%           unbiased_xcorr,biased_xcorr         
%           delay_unbiased,delay_biased


% unbiased xcorr 
% time for corr. corr support equals to sum of supports-1
xcorr_t = (-length(t):length(t)).*dt; xcorr_t(end-1:end)=[];
[unbiased_xcorr,lags] = xcorr(sig1,sig2,'unbiased');
max_unbiased_xcorr = max(unbiased_xcorr);
delay_unbiased = xcorr_t(unbiased_xcorr==max_unbiased_xcorr);
figure(); plot(xcorr_t,unbiased_xcorr);
xlabel('t [msec]'); ylabel ('amplitude');
title('unbiased xcross(sig1,sig2)');

txt_delay = ['the unbiased delay id ', num2str(delay_unbiased)];
disp(txt_delay);

% biased xcorr 
[biased_xcorr,lags1] = xcorr(sig1,sig2,'biased');
max_biased_xcorr = max(biased_xcorr);
delay_biased = xcorr_t(biased_xcorr==max_biased_xcorr);
figure(); plot(xcorr_t,biased_xcorr);
xlabel('t [msec]'); ylabel ('amplitude');
title('biased xcross(sig1,sig2)');

txt_delay = ['the biased delay id ', num2str(delay_biased)];
disp(txt_delay);
end

