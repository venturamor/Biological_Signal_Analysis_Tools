function [MAP,posterior] = MAP_func(x,param,prior,likeli)
% MAP - maximum a-posterior
% prior: dist of theta. example: = (2*pi)^(-1/2).*exp(-((param-4).^2)/2);
posterior = prior.*likeli;
figure();
plot (param,posterior);xlabel('theta');ylabel('P(theta|x)');title('Posterior');

[~,map] = max(posterior);
MAP = param(map);% fix
txt_MAP = ['MAP for theta is ', num2str(MAP)];
disp(txt_MAP);
end