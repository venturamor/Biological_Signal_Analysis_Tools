function [R] = Inst_Corr(x,t)
% brief: instanenius 2D corr for un stationary signals
% useful functions: 
% input:    
%           x         -   sig
%           t         -   time
% output:
%           R   
%comment: Dekel

N = length(x);
R = zeros(N,N);
for n = 0:N - 1
    M = min(n, N - 1 - n);
    for k = 0:M
        R(n + 1, k + 1) = x(n + k + 1) * conj(x(n - k + 1));
    end
    for k = N - 1 : -1 : N - M
        R(n + 1, k + 1) = conj(R(n + 1, N - k + 1));
    end
end
R(:,1:end/2) = fliplr(R(:,1:end/2));
R(:,end/2 + 1:end) = fliplr(R(:,end/2 + 1:end));
tau = linspace(-max(t)/2,max(t)/2,length(t));
imagesc(tau,t,R);
set(gca,'YDir','normal');
set(gca,'XDir','normal');
colorbar;
xlabel('$\tau$','interpreter','latex');
ylabel('$t[sec]$','interpreter','latex');
title('Instantaneous Autocorrelation');
end