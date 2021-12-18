function [Xt, Yn] = DistExamples(numExamples, tLen)
% brief: distribution function examples + plot. not general function, need to set
%        to question request
% useful functions: rand ~ U[0,1], randn ~ N(0,1), ~N(B,A^2) 
% input:    
%           numExamples -   number of examples functions
%           tLen        -   t length
% output:
%           Xt          -   continous random process
%           Yn          -   discrete random process
%           plots
% comments: (2*a*rand - a) ~ U[-a,a]

for ind=1:numExamples
    % random params
    B = 2*rand-1; % ~U[-1,1] 
    A = randn; % ~ N(0,1)
    n = (0:1:tLen)'; n(end)=[];
    t = (0:1:tLen)'; t(end)=[];
    Xt(:,ind) = A*t + B;
    Yn(:,ind) = A^2*randn(length(n),1)+ B ; % ~N(B,A^2) 

end

figure(); hold on;
subplot (1,2,1); plot(t,Xt);title('Xt = A*t + B');xlabel('t');ylabel('X(t)');
subplot (1,2,2); plot(n,Yn);title('Yn ~ N(B,A^2)');xlabel('n');ylabel('Y[n]');
end
