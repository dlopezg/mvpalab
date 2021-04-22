function graph = mvpalab_plotinit(cfg)
load mvpalab_colorschemes.mat
graph.grads = grd;
graph.colors = sch;

%% Color scheme:
graph.colorMap = grd.mvpalab;       % Default gradient colormap.
graph.colorSch = sch.mvpalab;       % Default color scheme. 

%% General:
graph.fontsize = 14;

%% Axes configuration:
% Title and labels:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'Classifier performance';
graph.title = 'MVPAlab - default figure';

% Colors:
graph.shadecolor = graph.colors.mvpalab{1};
graph.shadealpha = .7;

% Limits:
graph.ylim = [0 1];

if nargin > 0
    graph.xlim = [cfg.tm.tpstart cfg.tm.tpend];
end

%% Diagonal plots:
graph.plotmean = 1;
graph.smoothdata = 1; % (ODD) | 1 - No smooth
graph.stdsem = 0;  % 1 - STD | 0 - SEM
graph.linestyle = '-';
graph.linewidth = 1;

%% Temporal generalization plots:
graph.clusterLineColor  = [0 0 0];	% Cluster contour color.
graph.clusterLineColor_ = [1 0 0];	% Cluster contour color.
graph.clusterLineWidth  = 1;        % Cluster contour width.
graph.clusterLineWidth_ = 1;        % Cluster contour width.
graph.caxis = [0 0];

%% Statistics parameters:
graph.sigmode.shade = 0;
graph.sigmode.points = 1;

graph.stats.above = false;
graph.stats.below = false;

graph.sigh = 0.5;
graph.sigc = graph.colors.mvpalab{1};

%% Weights:
graph.weights.anim = 0;
graph.weights.type = 'raw';
graph.weights.start = 0;
graph.weights.end = 0;
graph.weights.speed = 0.1;
graph.weights.sub = 0;




end


