function graph = mvpalab_plotinit(cfg)
%% MVPALAB_PLOTINIT
%
%  This function returns the graph structure with the default parameters
%  of the MVPAlab plots: color schemes and gradients (loaded from
%  mvpalab_colorschemes.mat), labels, limits, chance level, smoothing,
%  cluster contours, statistics and feature weights.
%
%  With cfg, graph.xlim is set to [cfg.tm.tpstart cfg.tm.tpend] and
%  graph.chanlvl to the chance level of the classifiers, 1/number of
%  classes; the plots of RSA and fusion set their own (0). Without cfg,
%  graph.xlim is not set and graph.chanlvl stays at 0.5.
%
%%  INPUT:
%
%  - {struct} - cfg (optional):
%    Configuration structure (cfg.tm and cfg.study).
%
%%  OUTPUT:
%
%  - {struct} - graph:
%    Default parameters of the plots.

load mvpalab_colorschemes.mat
graph.grads = grd;
graph.colors = sch;

%% Color scheme:
graph.colorMap = grd.mvpalab;       % Default gradient colormap.
graph.colorSch = sch.mvpalab;       % Default color scheme. 

%% General:
graph.fontsize = 14;
graph.add = false;     % True to plot in the current figure (see mvpalab_plotresult).
graph.subject = 0;
graph.chanlvl = .5;

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
    graph.chanlvl = 1/size(cfg.study.dataFiles,2);
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


