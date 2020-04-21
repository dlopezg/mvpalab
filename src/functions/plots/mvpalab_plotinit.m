function graph = mvpalab_plotinit()
%MVPALAB_PLOTINIT Summary of this function goes here
%   Detailed explanation goes here

load mvpalab_colorschemes.mat
graph.grads = grd;
graph.colors = sch;

%% Temporal generalization plots:
graph.clusterLineColor  = [0 0 0];	% Cluster contour color.
graph.clusterLineColor_ = [0 0 0];	% Cluster contour color.
graph.clusterLineWidth  = .5;       % Cluster contour width.
graph.clusterLineWidth_ = .5;       % Cluster contour width.

graph.colorMap = grd.mvpalab;       % Default gradient colormap.
graph.colorSch = sch.mvpalab;       % Default color scheme. 

% General:
graph.fontsize = 14;
graph.smoothdata = 5; % (ODD) | 1 - No smooth

% Correct rate:
graph.plotmean = 0;
graph.stdsem = 0;  % 1 - STD | 0 - SEM
graph.sigmode.shade = 1;
graph.sigmode.points = 1;


end


