function [runsCountMean,runsCountVar] = runs_Test(x,N)
% x - signal, process
% N - num of batches
% a - significance level (statistics)

% init params
lenBatch = floor(length(x)/N);
meanX = mean(x);
varX = var(x);
meanSigns = zeros(N,1); % - : already set as smaller 
varSigns = zeros(N,1); % - : already set as smaller
runsCountMean = 0;
runsCountVar = 0;

for indBatch=0:(N-1)
% batch params relative to general params
   meanBatch(indBatch+1) = mean(x(indBatch*lenBatch+1:(indBatch+1)*lenBatch));
   varBatch (indBatch+1) = var(x(indBatch*lenBatch+1:(indBatch+1)*lenBatch));
   if meanBatch(indBatch+1)>= meanX
       meanSigns(indBatch+1) = 1; % + 
   end
   
   if varBatch(indBatch+1)>= varX
       varSigns(indBatch+1) = 1; % +
   end
   
%runs counters:
% sum(diff(x)) does the same...
   if indBatch ~=0 % not the first
       if meanSigns(indBatch+1)~= meanSigns(indBatch) %diff from prev
           runsCountMean = runsCountMean +1;
       end
       if varSigns(indBatch+1)~= varSigns(indBatch+1)%diff from prev
           runsCountvar = runsCountvar +1;
       end
   end
end

% results messsages
strRunMean = ['for ', num2str(N), ' batches: ',num2str(runsCountMean), ' runs(mean).']; 
strRunVar = ['for ', num2str(N), ' batches: ',num2str(runsCountVar), ' runs(variance).'];
disp(strRunMean);disp(strRunVar);
disp('final decision will be based on statistical data');
end