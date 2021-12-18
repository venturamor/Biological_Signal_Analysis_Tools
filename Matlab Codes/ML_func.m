function [ML,likeli] = ML_func(x,param,dist)
    % param:    range of values of param (same gap) (vector). example: miu = 0:0.001:5
    % x:        data, samples iid. example: x = [3.5377, 4.8339, 0.7412, 3.8622, 3.3188]
    % dist:     kind of x distrbution (list in mle function)
    % change expression(dist) in for loop as wanted
    
    N = length(x); % num of samples
    likeli= 1;
    for ind =1:N %iid dist
%         likeli =likeli*(2*pi)^(-1/2).*exp(-((x(ind)-param).^2)/2);
        if (x(ind)>1)
            likeli = likeli.*param.*exp(-param.*(x(ind)-1));
        end
    end

    figure();
    plot (param,likeli);
    xlabel('theta');
    ylabel('P(x|theta)');title('Likelihood');

%     [~,ml] = max(likeli);
    phat = mle(x,'dist',dist);
%     gaps = diff(param(2)-param(1));
%     ML = ml*gaps + param(1);
    ML = phat(1);
    txt_ML = ['ML for theta is ', num2str(ML)];
    disp(txt_ML);

    % theortical ML is the empirical average which eqyals to:
    theor_ML = mean(x);
    txt_ML_theor = ['Theoretical ML for theta is ', num2str(theor_ML)];
    disp(txt_ML_theor);
end
