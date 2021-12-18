function [H1, simexp,eegsub] = DetectSinComponent(sig,fs,f_sin,NW)
N = length(sig);
f_ax = (0:N-1)./N*fs -fs/2; % f axis
t_ax = (0:N-1) ./fs; % time axis

% dpss windows specification and generation
% W = 3/N; % half bandwidth parameter
% NW = N*W; % time - half bandwidth parameter
M = 2*NW -1 ; %number of windows
windows = dpss(N,NW,M);

% calculate fft of the windowed signal and the windows
Vf = fftshift(fft(windows,[],1),1);
Xf = fftshift(fft(repmat(sig,1,M).*windows,[],1),1); % fft windowd signals

% estimate right and left constant
C0r = pinv(Vf(~f_ax,:).')*Xf(f_ax==f_sin,:).';
C0l = pinv(Vf(~f_ax,:).')*Xf(f_ax==-f_sin,:).';

% simulate the appropriate complex exponentials and substract them
simexp = C0r*exp(1j*2*pi*f_sin*t_ax') + C0l*exp(1j*2*pi*(-f_sin)*t_ax');
eegsub = sig - simexp;

% plot
figure;
plot(t_ax, sig); hold on;
plot(t_ax, eegsub,'r'); title('Clean Signal'); hold on;
plot(t_ax, simexp,'--g');
title('Substract Known Freq Component'); xlabel('t[sec]'); ylabel('amp'); 
legend('Original Signal','Clean Signal','Extracted Sine-Wave');

% F test 
F = (M - 1)*((norm(C0r + C0l))^2)*norm(Vf(~f_ax,:)).^2 ...
    /norm(Xf(f_ax == -f_sin,:) + Xf(f_ax == f_sin,:)...
    - C0r*Vf(~f_ax,:) - C0l*Vf(~f_ax,:)).^2;

alpha = 1/N; % sureness level
b = 2*M - 2;
test = b*(1 - alpha^(2/b))/(2*alpha^(2/b));

if F > test
    H1 = true; % reject H0
else
    H1 = false; % dont reject H0
end

end