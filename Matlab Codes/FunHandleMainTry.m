%main

% Create function Handled to estimators
est1 = @Estimator1;
a = [1:100];
miu1 = est1(a,length(a));

est2 = @Estimator2;
a = [1:100];
miu2 = est2(a,length(a));

est3 = @Estimator3;
a = [1:100];
miu2 = est3(a,length(a));

% create cell of function handles
HandF_ests = {est1,est2,est3};
b = HandF_ests{1}(a,length(a)); % only check access

% input example
miu = 10;
vals = 1000;
N_length = [3 6 12 24 48 96];
estimators_names = {'Spike est','Axon est','Axon fixed est'};
pd = makedist('Poisson','lambda',miu);
% call to Estimate param function
EstimateParam_ByDifferent_Estimators...
    (miu,pd,vals,N_length,estimators_names,HandF_ests)


randP = random(pd, [vals, 4]); %only check


function [miu_spike_est] = Estimator1 (x,length_samples_i)
    sum_row_Spike = sum(x);
    miu_spike_est = (1/length_samples_i)*sum_row_Spike;
end

function [miu_axon_est] = Estimator2 (x,length_samples_i)
    mean_row = mean(x);
    sum_row_Axon = sum((x-mean_row).^2);
    miu_axon_est = (1/length_samples_i)*sum_row_Axon;
end

function [miu_axon_fixed_est] = Estimator3 (x,length_samples_i)
    mean_row = mean(x);
    sum_row_Axon = sum((x-mean_row).^2);
    miu_axon_fixed_est = (1/(length_samples_i-1))*sum_row_Axon;
end