function graph = mvpalab_plotinit(cfg)
%MVPALAB_PLOTINIT Summary of this function goes here
%   Detailed explanation goes here

load mvpalab_colorschemes.mat
graph.grads = grd;
graph.colors = sch;

%% Temporal generalization plots:
graph.clusterLineColor  = [0 0 0];	% Cluster contour color.
graph.clusterLineColor_ = [0 0 0];	% Cluster contour color.
graph.clusterLineWidth  = 1;       % Cluster contour width.
graph.clusterLineWidth_ = 1;       % Cluster contour width.

%% Color scheme:
graph.colorMap = grd.mvpalab;       % Default gradient colormap.
graph.colorSch = sch.mvpalab;       % Default color scheme. 

%% General:
graph.fontsize = 14;
graph.smoothdata = 5; % (ODD) | 1 - No smooth

%% Correct rate:
graph.plotmean = 0;
graph.stdsem = 0;  % 1 - STD | 0 - SEM
graph.sigmode.shade = 1;
graph.sigmode.points = 1;

graph.ylim = [0 1];
if nargin > 0
    graph.xlim = [cfg.tm.tpstart cfg.tm.tpend];
end

% Colors:
graph.shadecolor = graph.colors.mvpalab{1};
graph.shadealpha = .5;
graph.sigh = 0.5;
graph.sigc = graph.colors.mvpalab{1};


%% Plot parameters:
graph.stats.above = false;
graph.stats.below = false;


end


