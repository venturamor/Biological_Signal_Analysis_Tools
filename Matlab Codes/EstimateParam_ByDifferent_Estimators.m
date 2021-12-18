function [] = EstimateParam_ByDifferent_Estimators(param,pd,vals,length_samples,estimators_names,EstimHandles)
% brief: 
% useful matlab funcs: poissrnd
% input:    
%           param    (scalar)    -   the paramter we want to estimate
%           vals     (scalar)    -   number of observation in 1 sample
%           length_samples []    -   vec of samples sizes (ex:[3 6
%                                                          12 24 48 96])
%           estimators_names{}   -   estimators names {'Mom', 'Spike', 'Esti'}
%           EstimHandles{}       -   cells of function handles of
%                                    estimators (ex: HandF_ests =
%                                    {est1,est2,est3})
%           pd                   -   probaility disturbution object
%                    (makedist)(ex: pd = makedist('Poisson','lambda',miu);

% output:
%           histograms per estimator for different sizes N
%           comparison between estimators in: bias, var, MSE


% comments: change pdf random param 
% explained in FunHandleMainTry.m

samples.data = {};
samples.param_est.data = {};


for indLength=1:length(length_samples)
   % random n for each size N, 1000 times.
   samples.data{1,indLength} =  random(pd,[vals, length_samples(indLength)]);
   % estimator for each experiment
   for ind=1:vals
       for indEst=1:length(EstimHandles)
            % calc each estimator per experiment
             samples.param_est.data{1,indEst}(ind,1) = EstimHandles{indEst}...
                (samples.data{1,indLength}(ind,:),length_samples(indLength));  
       end
    end
   
   % convinient data store per N (window size)
   field_N_txt = ['N_',num2str(indLength)];
   samples.(field_N_txt)= samples.param_est.data;
   
   % final estimator (mean of all estimator kind)
   % calc more characteristics as: bias, var, MSE
   for i=1:length(estimators_names) % i - kind of estimator: 1- est1, 2 - est2, 3 - est3
       samples.param_est.final(i,indLength) = mean(samples.param_est.data{1,i});
       samples.param_est.bias(i,indLength) = param - samples.param_est.final(i,indLength);
       samples.param_est.var(i,indLength) = var(samples.param_est.data{1,i});
       samples.param_est.MSE(i,indLength) = mean(samples.param_est.bias(i,indLength)^2);
   end
  
end

% plot: histograms per estimator (for each time window size N)
N_txt = {'N_1','N_2','N_3','N_4','N_5','N_6'};
for indEst=1:length(estimators_names)
    figure('name',cell2mat(estimators_names(indEst)));    
    cols = 2;
    rows = length(N_txt)/cols;
    for indN=1:length(N_txt)
        subplot(rows,cols,indN); 
        hist(samples.(N_txt{indN}){1,indEst});
        txt_hist = ['window size N = ',num2str(length_samples(indN))];
        xlabel(txt_hist);
    end
end

%% section 4,5 
% plot: compared characteristics between estimators
char_field = {'bias','var','MSE'};
x = length_samples;
param_x = param./x;
for indChar=1:length(char_field)
    figure();
    % by samples
    stem(x,samples.param_est.(char_field{indChar})(1,:),'o');
    hold on; stem(x,samples.param_est.(char_field{indChar})(2,:),'*');
    stem(x,samples.param_est.(char_field{indChar})(3,:),'x');
    xlabel('number of time windows: N');
    title_str = ['compared ', char_field{indChar}, ' between different estimators'];
    title(title_str);
    
    % theotretical
    switch char_field{indChar}
        case 'bias'
            plot(x,0); hold on;
            plot(x,param_x);
            plot(x,0);
            legend(estimators_names);
        case 'var'
            plot(x,param_x); hold on;
            axon_var = ((x*param)./((x-1).^2))+2*((param*x).^2)./((x-1).^3);
            plot(x,axon_var);
            axon_fixed_var = param_x + 2*(param^2)./(x-1);
            plot(x,axon_fixed_var);
            legend(estimators_names);
        case 'MSE'
            plot(x,param_x); hold on;
            plot(x,axon_var+(param_x).^2);
            plot(x,axon_fixed_var);
            legend(estimators_names);
    end
    theor_names = strcat(estimators_names, ' theoretical');
    theor_names = [estimators_names theor_names];
    legend(theor_names);
end


end

