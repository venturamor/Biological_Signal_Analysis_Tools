function [STA1] = STA(spikes,stim,Fs)
% input: stimulation and reaction of neuron (shooting time) 
% output: estimated most preferd stimulation by nueron
% comment: change STA1 to r for the xcorr version
indicesPeaks = find(spikes); % find indices (times) when neuron reacted
WindLength   = indicesPeaks(1); % first reaction time set window stim length

% the easy way:
[r,k] = xcorr(spikes,stim,WindLength);

% the full way:
STA1 = 0;

NumSpikes    = length(indicesPeaks);
N            = length(spikes);

for indPeak=1:NumSpikes
    STA1 = STA1 + stim(indicesPeaks(indPeak)-WindLength+1:indicesPeaks(indPeak));
end

STA1 = STA1*(1/NumSpikes);
dt = 1/Fs;
t = 0:dt:(length(STA1)*dt);  t(end)=[];

figure(); 
subplot(2,1,1); plot(t,STA1); hold on; plot(t,smoothdata(STA1));
legend('STA - manual','STA smooth - manual'); xlim([t(1),t(end)]);
title('STA - Spike Triggered Average');
xlabel('time [s]'); ylabel('Amplitude');
subplot(2,1,2); plot(k,r);  legend('STA - xcorr');
title('STA - Spike Triggered Average');
xlabel('time [s]'); ylabel('Amplitude');

end
