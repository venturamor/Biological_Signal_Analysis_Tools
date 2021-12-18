function [knots, measure] = AdaptiveSegmentation (eeg,S,deltaindex,M,Sthresh,winLen,L)
% Inputs
%   eeg:          eeg signal to segment
%   S:            measure function handle
%   deltaindex:   threshold passing minimal distance (for avoiding small time
%                                                     crossing)
%   M:            number of error(noise) autocorrelation samples
%   Sthresh:      threshold for the measure 
%   winLen:       window length
%   L:            order of the AR model
% Outpus:
%   knots:        knots where the segments starts/end
%   measure:      measure evaluation throughout the signal (autocorr deviations)

% init
N = length(eeg);
refpos = 1;                         % refrence position
testpos = refpos +1;                % test position
countThresh  = 0;                   % threshold counting 
SegIndicator = zeros (size(eeg));   % segmentaion indicator
done = false;                       % stop criteria
i = 1;                              % measure history

while ~done
    
    % refrence segment definition
    eegRef = eeg(refpos:refpos+winLen-1);
    a = AR_Coeffs (eegRef,L); % AR model - coeffs(cell)
    errorRef = filter (a{1,1},1,eegRef); % the noise created the refrence
    [Rfixed, taufixed] = xcorr(errorRef); % auto corr of the ref noise
    
    % test segment definition
    eegTest = eeg(testpos:testpos+winLen-1);
    errorTest = filter(a{1,1},1,eegTest); % the noise created the test
    [Rmoving, taumov] = xcorr(errorTest);% auto corr of the test noise
    
    % calculate the diss-similarity measure
    St = S(Rfixed, taufixed, Rmoving, taumov,M);
    measure(i) = St; % save measure history
    i = i+1;
    
    % check if crossed the threshold
    if St <= Sthresh %if not
        testpos = testpos +1 ;
        countThresh = 0;
        
    % suspected to be a different segment. check adjacent ones before
    % segmenting
    else
        testpos = testpos+1;
        countThresh = countThresh +1;
        
        % check if this threshold passing has lasted 100 msec
        if countThresh >= deltaindex
            SegIndicator(testpos - deltaindex +winLen) = 1; % mark seg. initial point
            refpos = testpos - deltaindex +winLen; % switch the refrence segment
            testpos = refpos + 1; % advance test position
            countThresh = 0; % zero threshold passing count
        end
    end
    %check if the whole signal is segmented
    if refpos >= (N - winLen) || testpos >= (N - winLen)
        done = true;
    end
end

% find the indices of thr knors
knots = find(SegIndicator==1);
    
end





