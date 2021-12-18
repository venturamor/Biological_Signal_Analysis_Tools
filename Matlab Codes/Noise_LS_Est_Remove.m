function [cleanSig] = Noise_LS_Est_Remove(NoisedSig,TopPolyOrder)

% brief: estimating noise and removing (getting rid of
%        mean(E) if mean != 0
% useful functions: polyfit, polyval
% input:    
%           NoisedSig          -   Signal mesurement containing noise
%           TopPolyOrder       -   Top order to check match
% output:
%           cleanSig          -   clean Signal (noise removed)
%           plot

% comments: fill chosenOrder
p = {}; s={}; y_fit = {}; delta={};
x = (1:length(NoisedSig))';
figure();
k = 0; % help for arrange subplots in cols
for indOrder=1:TopPolyOrder
    [p{1,indOrder},s{1,indOrder}] = polyfit(x,NoisedSig,indOrder); %coeffs second order
    [y_fit{1,indOrder},delta{1,indOrder}] = polyval(p{1,indOrder},x,s{1,indOrder});

    subplot(TopPolyOrder,2,indOrder+k);
    plot(x,NoisedSig); hold on ;plot(x,y_fit{1,indOrder},'LineWidth',1.5);
    str = ['polyfit order: ', num2str(indOrder)];
    title(str); legend('NoisedSig','polyFit');
    ylabel('');xlabel('measurements');

    cleaned_sig{1,indOrder} = NoisedSig - y_fit{1,indOrder};
    
    subplot(TopPolyOrder,2,indOrder+k+1); 
    strClean = ['cleaned Sig(LS) ',str];
    plot(x,cleaned_sig{1,indOrder}); title(strClean);
    ylabel('');xlabel('measurements'); axis on; grid on;
    
    k = k+1;
end

% fill chosen order ([1,TopPolyOrder])
chosenOrder = 4;
cleanSig = cleaned_sig{1,chosenOrder};
figure();
strClean = ['cleaned Sig(LS) ','polyfit order: ', num2str(chosenOrder)];
plot(x,cleaned_sig{1,chosenOrder}); title(strClean);
ylabel('');xlabel('measurements');

end

