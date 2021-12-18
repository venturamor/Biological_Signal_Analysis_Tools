function [sig_filtered] = FIR_Freq_Filter(Fs,signals,str_sig,order,cutoff_freq )
% brief: FIR freq filtering with blackman or rectwin
% useful functions: fir1, filter
% input: 
%           Fs                 freq sample
%           signals   {}       example:  signals = {coSig1, coSig2};
%           str_sig   {}       example:  str_sig = {'coSig1', 'coSig2'};
%           cutoff_freq []     example: cutoff_freq = [2*54/Fs, 2*57/Fs];% normalized freq by half sample freq
%           order (not cell)   example: 100
% output:
%           sig_filtered - cell (order by filter type and signal)
%           plot - time domain         
%           plot - freq domain         

% comments: add in input: sig1 - optional if need to compare this sig, gain diff            
%           and uncomment

sig_filtered = {};
coeff1 = {}; coeff2 = {};
filter_types = {'blackman','rectwin'};
for indSig=1:length(signals)
    coeff1{indSig,1} = fir1(order,cutoff_freq(indSig),'high',blackman(order+1));% blackamn
    %freqz(coeff1,1);
    sig_filtered{indSig,1} = filter(coeff1{indSig,1},1,signals{1,indSig});
    coeff2{indSig,1} = fir1(order,cutoff_freq(indSig),'high',rectwin(order+1)); % rectwin
    sig_filtered{indSig,2} = filter(coeff2{indSig,1},1,signals{1,indSig});
    figure();
    for indType=1:length(filter_types) % time domain plots
        subplot(length(filter_types)*2,1,indType);
        t = (0:(length(signals{1,indSig})-1))/Fs;
        plot(t,sig_filtered{indSig,indType}); 
        str_title = ['signal: ', str_sig{1,indSig},'. filter: ',filter_types{1,indType}]; 
        title(str_title); xlabel('time');ylabel('amplitude '); 
        
% uncomment: for diff gains view       
%         subplot(length(filter_types)*2,1,indType+2);
%         plot(t,(sig1));hold on;
%         plot(t,(sig_filtered{indSig,indType}),'LineWidth',2); hold on;
%         plot(t,(sig_filtered{indSig,indType}-sig1));
%         % option: plot the amplitude on db scale by adding mag2db
        
        str_title = ['signal: ', str_sig{1,indSig},'. filter: ',filter_types{1,indType}]; 
        title(str_title); xlabel('time');ylabel('amplitude  '); 
        legend(str_title, 'gain diff', 'original sig');
    end

    figure();
    for indType=1:length(filter_types) % freq domain plots
        subplot(length(filter_types),1,indType);
        l = linspace(-Fs/2,Fs/2,(length(signals{1,indSig})));
        plot(l,mag2db(abs(fftshift(fft(sig_filtered{indSig,indType})))));
        str_title = ['signal: ', str_sig{1,indSig},'. filter: ',filter_types{1,indType}]; 
        title(str_title); xlabel('freq[Hz]');ylabel('amplitude [db]');
        % option: plot the amplitude on/off db scale by adding/discarding
        % mag2db option
    end
end
end

