function LogLikelihood_func(PoissVec,PoissVecName)
% for Poiss Signal , returns the log likelihood function (of Poiss and Gauss) 
N = length(PoissVec);
lambda = linspace(0.1,20,N);
logFactorial = log(factorial(PoissVec));
logLhoodPoiss = log(lambda).*sum(PoissVec)...
                -N*lambda - sum(logFactorial);
            
% for Gauss assumption
logLhoodGauss = -0.5*N*log(2*pi)-0.5*N*log(lambda) - (1./(2.*lambda)).*(sum(PoissVec.^2)...
                -2.*lambda.*sum(PoissVec)+N*lambda.*lambda);
            
figure(); subplot(2,1,1);plot(lambda,logLhoodPoiss); xlabel ('lambda'); ylabel('LogLikelihood');
str = ['Log Likelihood Poiss of ', PoissVecName];
title(str);
subplot(2,1,2); plot(lambda,logLhoodGauss); xlabel ('lambda'); ylabel('LogLikelihood');
str = ['Log Likelihood Gauss of ', PoissVecName];
title(str);
end