function [tau_xx,New_Rxx,NewSig] = SimulateGauss(WN_size,kind,a_hat,Rxx_vec,tauxx_given,order)
% brief: generate new gauss process by known Rxx and coeffs
% useful functions: 
% input:    
%           kind          -   'FIR' or 'IIR' based coeffs
%           a_hat []      -   a_hat incase IIR. otherwise ~
%           Rxx_vec       -   given
%           tauxx_given   -   given ax for Rxx
%           WN_size       -   size of wanted final signal 
% output:
%           tau_xx          
%           New_Rxx          
%           NewSig

% comments: 
a_hat = a_hat{1,1};
wn = randn(1,WN_size);  % random white noise
switch kind
    case 'FIR'
        % H = sqrtm Rxx. filter FIR (MA)
        % H*whiteN_gauss = signal
        R = toeplitz([Rxx_vec(find(tauxx_given==0):find(tauxx_given==order)),zeros(1,order)]); %padding
        H = sqrtm(R);% find H, R=H*H_transpose
        b_hat= H(round(end/2),:);
        NewSig = filter(b_hat,1,wn);
        [New_Rxx,tau_xx] = xcorr(NewSig,'biased'); % new AutoCorr
        %normalization factor
        normalizeCoeff = Rxx_vec(find(tauxx_given==0))/New_Rxx(tau_xx==0);
        New_Rxx = New_Rxx*normalizeCoeff;      
    case 'IIR'
        % coeff = a_hat
        [h,~] = impz(1,a_hat);
        normalizeCoeff = 1/sum(h.^2);
       NewSig = normalizeCoeff.*filter(1,a_hat,wn);
%         NewSig = filter(1,a_hat,wn);
        ss = floor(length(NewSig)/2);
       [New_Rxx,tau_xx] = xcorr(NewSig,ss,'biased'); % new AutoCorr

    otherwise
        disp('choose in kind only FIR or IIR!');
end

% time for corr. corr support equals to sum of supports-1
% t_ax_New = (-(length(NewSig)-1):(length(NewSig)-1));
% plot
figure();
plot(tau_xx,New_Rxx);
hold on;
plot(tauxx_given,Rxx_vec)
xlabel('\tau')
ylabel('R[\tau]')
title (['$achieved \ R[x] \ vs \ desierd \ R[k], \ using \ ' kind ...
        ' \ from \ order = \ $' num2str(order)],...
    'interpreter', 'latex', 'FontSize', 13)
legend('Rxx New','Rxx Given')
        
        
