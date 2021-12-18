function [L1,logL1]=ML_LambdasComparison(lamModel,tauVec)
% brief: compare given models of intesity functiond (lambdas)
% useful functions: 
% input:    
%          lamModel          -   existing model (@ func handle .of taus)
%          t                 -   t axis
%          tau               -   gaps intervals vector
%          res               -   resolution (delta between t)
% output:
%           likelihood          
%           log_likelihood         
% comments: 

tspikes=cumsum(tauVec);
Ttot = tspikes(end);
% likelihood
% integral = trapz(t,lambda1(t))
L1 = prod(lamModel(tspikes))*exp(-integral(lamModel,0,Ttot)); 

% log-likelihood
logL1 = sum(log(lamModel(tspikes)))-integral(lamModel,0,Ttot); % log(L1);



% EliasVersion:
%     tspikes=cumsum(tauVec);
%     wont_happen=exp(-trapz(t,lamModel));
%     for indWi=1:length(tspikes)
%         num=find(t-res<=tspikes(indWi) & t+res>=tspikes(indWi));
%         vec(indWi)=num(1);
%     end
%     will_happen=prod(lamModel(vec));
% 
%     likelihood=will_happen*wont_happen;
%     log_likelihood=log(likelihood);
    

end