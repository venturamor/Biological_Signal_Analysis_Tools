function [] = LevelSets_Hist2D (tau)
% brief: check statistical dependency of taus
% useful functions: hist3
% input:    
%           tau          -   gaps vector
% output:
%           2D Histogram         
% comments: possible - change hist3 to set nbins
figure;
hist3( [ tau(1:end-1) tau(2:end)],'FaceAlpha',.85); 
xlabel('Time interval i \tau1'); ylabel('Time interval i+1 \tau1'); title('2D histogram \tau1')
surfHandle = get(gca, 'child');
set(surfHandle,'FaceColor','interp', 'CdataMode', 'auto');
hold on;
x = tau(1:end-1);
y = tau(2:end);
N = hist3( [x y],'FaceAlpha',.85);
%Generate a grid to draw the 2-D projected view of intensities
% by using pcolor.

N_pcolor = N';
N_pcolor(size(N_pcolor,1)+1,size(N_pcolor,2)+1) = 0;
xl = linspace(min(x),max(x),size(N_pcolor,2)); % Columns of N_pcolor
yl = linspace(min(y),max(y),size(N_pcolor,1)); % Rows of N_pcolor
%Draw the intensity map by using pcolor. Set the z-level of the intensity map to view the histogram and the intensity map together.

h = pcolor(xl,yl,N_pcolor);
colormap('hot') % Change color scheme 
colorbar % Display colorbar
h.ZData = -max(N_pcolor(:))*ones(size(N_pcolor));
ax = gca;
ax.ZTick(ax.ZTick < 0) = [];
title('Gaps Histogram and Intensity Map');
end