function [compAligned] = AlignQRS(complexes)
% brief:  align QRS complexes by cross correlation with first complex
%         and afterwards shifting the complexes according to the first one,
%         and padding with zeros outside the support
% input:    
%           complexes          -   shifted complexes

% output:
%           compAligned        -   complexes aligned to the first one

% number of complexes and samples in each complex
[K,N] = size(complexes);

% calc offsets
compAligned = zeros (size(complexes));
compAligned(1,:) = complexes (1,:);
for i=2:K
    [Rli,tau] = xcorr(complexes(1,:), complexes(i,:));
    [~,maxind] = max(Rli); % max index
    offset = tau(maxind);
    % check if it's positive or negative and expand accordingly
    if offset == 0
        compAligned(i,1:N) = complexes(i,:);
    elseif offset < 0
        compAligned(i,1:N+offset) = complexes(i,1-offset:end);
    else
        compAligned(i,1+offset:N) = complexes (i,1:end-offset);
    end
end
end

