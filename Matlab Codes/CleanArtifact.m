function [Clean_Sig, relative_Energy] = CleanArtifact(x,Artifacts,L,M,Fs,Plot)

% brief: clearing Artifacts (additive Noises*Unknown filters) by 
%        finding weights (L = 0) or linear h filters
% useful funcs: xcorr, filter, toeplitz
% input:    
%           x               -   measurement, noised signal
%           Artifacts {}    -   different channels blended to measure
%           L               -   filter order
%           M               -   number of Artifacts
%           Fs              -   freq sample
%           Plot            -   plot -1, don't plot - 0
% output:
%           Clean_Sig          -   the cleaned signal
%           relative_Energy    -   %ratio between clean and original energy

% comments: Hadas Code

Ts = 1/Fs;
N = length(x);
t = (0:1:N-1)*Ts;

% % create cell of Artifact
% Artifacts{M} = 0; 
% for i = 1:M
%     Artifacts{i} = Artifacts_mat(:,i);
% end


% Build all cross-corrletion
R_cell_vivj{M,M}   = 0;
tau_cell_vivj{M,M} = 0;

R_cell_xvi{1,M}    = 0;
tau_cell_xvi{1,M}  = 0;

for i = 1:M 
    [R_cell_xvi{1,i},tau_cell_xvi{1,i}] = xcorr(x,Artifacts{i});
        for j = 1:M
            [R_cell_vivj{i,j},tau_cell_vivj{i,j}] = xcorr(Artifacts{i},Artifacts{j});
        end
end

if L ==0 
    Rvi_vj = zeros(M,M);
    rx_vi  = zeros(M,1);
    for i = 1:M
        temp_Rxvi    =  R_cell_xvi{1,i};
        temp_tauxvi  =  tau_cell_xvi{1,i};
        rx_vi(i,1)   =  temp_Rxvi(temp_tauxvi == 0);
        for j = 1:M
            temp_Rvivj   =  R_cell_vivj{i,j};
            temp_tauvivj =  tau_cell_vivj{i,j};
            Rvi_vj(i,j)  =  temp_Rvivj(temp_tauvivj == 0);
        end
    end
  % find the weigthed vector 
    w=Rvi_vj\rx_vi;
  % find the estimated v vector
  v0_hat = zeros(size(Artifacts{1}));
  for i = 1:M
      v0_hat = w(i)*Artifacts{i} + v0_hat;
  end
  
  % get the filtered signal: S(n) = x(n) - sum(wi*vi)
    Clean_Sig = x-v0_hat;
    energy_x = sum(x.^2);
    energy_filtered_signal = sum(Clean_Sig.^2);

    relative_Energy = (energy_filtered_signal./energy_x)*100;
    if Plot
        figure;
        plot(t,x);
        hold on;
        plot(t,Clean_Sig);
        hold off;
        xlabel('$time[sec]$', 'Interpreter','latex')
        ylabel ('$Amplitude$','Interpreter','latex')
        title('$Original \ EEG \  Vs. \ Filtered \ EEG \ order = 0$',...
            'Interpreter','latex')
        legend('$Original \ EEG$','$Filtered \ EEG$','Interpreter','latex')
    end

else %filter order > 0

    rx_vi_cell{M,1} = 0;
    Rvi_vj_cell{M,M} = 0;
    for i = 1:M
        for l = 1:L
            temp_Rxvi     =  R_cell_xvi{1,i};
            temp_tauxvi   =  tau_cell_xvi{1,i};
            rxvi_row(l,1) =  temp_Rxvi(temp_tauxvi == l-1);
        end
        rx_vi_cell{i,1} = rxvi_row;
        for j = 1:M
            for l=1:L
                temp_Rvivj     =  R_cell_vivj{i,j};
                temp_tauvivj   =  tau_cell_vivj{i,j};
                Rvivj_row_temp(l) = temp_Rvivj(temp_tauvivj == l-1);
                Rvivj_col_temp(l) = temp_Rvivj(temp_tauvivj == 1-l);
 
            end
           
            Rvi_vj_cell{i,j} = toeplitz(Rvivj_col_temp',Rvivj_row_temp);
        end
    end
    
    rx_vi_mat  = cell2mat(rx_vi_cell);
    Rvi_vj_mat = cell2mat(Rvi_vj_cell);
    
    h = Rvi_vj_mat \ rx_vi_mat ; 
    
    h = reshape(h,L,[]);
    v0_hat = zeros(size(Artifacts{1}));
    for m = 1:M
        v0_hat = filter(h(:,m)',1,Artifacts{m}) + v0_hat;
    end
    
    Clean_Sig = x-v0_hat;
    energy_x = sum(x.^2);
    energy_filtered_signal = sum(Clean_Sig.^2);
    % possible: rel = norm(Clean_Sig)/norm(x)
    relative_Energy = (energy_filtered_signal./energy_x)*100;
    if Plot
        figure;
        plot(t,x);
        hold on;
        plot(t,Clean_Sig);
        hold off;
        xlabel('$time[sec]$', 'Interpreter','latex')
        ylabel ('$Amplitude$','Interpreter','latex')
        title(['$Original \ EEG \  Vs. \ Filtered \ EEG  \ order = $' num2str(L)],...
            'Interpreter','latex')
        legend('$Original \ EEG$','$Filtered \ EEG$','Interpreter','latex')
    end
    
end

end