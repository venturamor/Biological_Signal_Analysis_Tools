function [filtfilt1_cos_new] = filtfilt_cos_FIR_func (coeff1,coeff2, signal,f,t)
% brief: filt filt fix for phase diff caused by high order filter
% useful functions: filtfilt

    filtfilt1 = filtfilt(coeff1,1,signal); % filtered no phase delay 
    cos_filtfilt = 2*filtfilt1.*cos(2*pi*f*t);
    filtfilt1_cos_new = filtfilt(coeff2, 1, cos_filtfilt);
end