function [tspikes,gaps] = DrawPointProcess_ByTimeRescaling(lambda,delta,deltaint,timeLength)
% brief: 
% useful functions: histogram, diff, 
% input:    
%           lambda          -   vector of lambdas build the mius(intensity
%                               function)
%           delta           -   threshold in miu (example: [10,100,1000]
%           deltaint        -   resolution (example: delta/100)
%           timeLength      -   time duration of PP
% output:
%           stem plot       
%           histogram of gaps intervals
%           tspikes (cell)
%           gaps (cell)

% comments: change intensity function as needed (mu)

N_lambdas = length(lambda);
fig1 = figure(); 
fig2 = figure();

for indLambda=1:N_lambdas
    mu = @(tau) lambda(indLambda)*(tau >= delta);
    tspikes{indLambda,1}    = TimeRescalingSimulation(mu,timeLength,deltaint);
    gaps   {indLambda,1}    = diff(tspikes{indLambda,1}); %for gaps histogram
    set(0,'CurrentFigure',fig1) % fig1 the current figure 
    subplot(ceil(N_lambdas/2),2,indLambda); 
    stem(tspikes{indLambda,1},ones(1,length(tspikes{indLambda,1})));
    title(['$\lambda = $' num2str(lambda(indLambda))] ,'Interpreter','Latex');
    set(0,'CurrentFigure',fig2) % fig2 the current figure
    subplot(ceil(N_lambdas/2),2,indLambda);
    histogram(gaps{indLambda,1});%,100,'BinLimits',[0 max(gaps{indLambda,1})]);
    title(['Histogram ''$\lambda = $' num2str(lambda(indLambda))],'Interpreter','Latex');
end
end


