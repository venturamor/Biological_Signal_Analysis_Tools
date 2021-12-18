function [sig_filtered_IIR] = IIR_LPF_a1(sig, a1)
% brief: LP filter - IIR. eaxmine different a1 coeffs.
% useful functions: filter, roots, fliplr,zplane 
% input:    
%           a1                   -   c (example: a1 = -0.9:0.1:-0.1;)
% output:
%           sig_filtered_IIR     -   filterd sig
%           plot  poles in z palne         

% comments: 
% Assuming second order LPF IIR and a0 = 1 : only for a1 negative values
% IIR exists only for 2 elements or more in the dominator
% for stable system we wiil check only |a1|<1

b0 = 1;

list_str = {};
r=[];
sig_filtered_IIR = zeros(length(sig),length(a1));
for i=1:length(a1)
    a = [1,a1(i)];
    b = [b0];
    sig_filtered_IIR(:,i) = filter(b,a,sig);
    list_str{i} = ['a1 = ', num2str(a1(i))];
    hold on;
    r = [r roots(fliplr(a))]; % for poles map
end
figure(); plot(t,sig_filtered_IIR);
legend(list_str);xlabel('time'); ylabel('sig');
vec_zero = zeros(size(r));
figure; zplane(vec_zero',(1./r)'); title('poles of different a1');
end

