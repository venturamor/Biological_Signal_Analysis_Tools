function sig = Show_Signal(data,fs,name)
%   inputs:
% sig is a struct containing:
% sig.data
% sig.fs
% sig.name

%   outputs:
% sig.t
% sig.dt
% sig.f
% sig.fft
% figure of sig
% figure of fft
    sig.data = data;
    sig.fs = fs;
    sig.name = name;

    sig.N = length(sig.data);
    sig.dt = 1/sig.fs;
    sig.t = 0:sig.dt:length(sig.data)*sig.dt; sig.t(end) = [];
    sig.f = (0 : sig.N - 1)./(sig.N)*sig.fs - sig.fs/2;
    sig.fft = abs(fftshift(fft(sig.data)));
    figure()
    subplot(2,1,1)
    plot(sig.t,sig.data)
    title(sig.name); xlabel('t [sec]'); ylabel('Amp');
    subplot(2,1,2)
    plot(sig.f,sig.fft)
    title(['FFT of ' sig.name]); xlabel('f [Hz]'); ylabel('Amp');
end