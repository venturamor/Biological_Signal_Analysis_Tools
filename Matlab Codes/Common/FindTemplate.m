function peak_times = FindTemplate(sig,template,fs,min_hight)
%input sig,template, fs, min hight of peak
%output corr times in sec
% put minheight empty [] unless doesnt work well
if isempty(min_hight)
    min_hight = 5;
end

dt=1/fs;
t = 0:dt:length(sig)*dt; t(end) = [];

[r1,r_t1] = xcorr(sig,template);
r1 = r1(round(length(r1)/2):end);
r_t1 = r_t1(round(length(r_t1)/2):end)*dt;
[hight,p_t] = findpeaks(r1,'MinPeakHeight',min_hight);
%peak_times = p_t*dt;
peak_times = (p_t)*dt - dt;
figure();
subplot(2,1,1); plot(r_t1,r1); hold on; 
%plot(peak_times,hight,'r*');
stem(peak_times,hight,'O');
xlabel('\tau[sec]'); ylabel('AMP'); 
title('Signal Template times (Xcorr Based)')

subplot(2,1,2); plot(t,sig); hold on;
plot(peak_times,sig(p_t),'r*');
xlabel('time[sec]'); ylabel('AMP'); 
title('Signal Template repetitionsCross')

end
