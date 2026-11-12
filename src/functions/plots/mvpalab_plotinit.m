function graph = mvpalab_plotinit(cfg)
%% MVPALAB_PLOTINIT
%
%  This function returns the graph structure with the default parameters
%  of the MVPAlab plots: color schemes and gradients (loaded from
%  mvpalab_colorschemes.mat), labels, limits, chance level, smoothing,
%  cluster contours, statistics and feature weights.
%
%  With cfg, graph.chanlvl is the chance level of the classifiers,
%  1/number of classes (the plots of RSA and fusion set their own, 0), and
%  the limits and labels of the axes follow the analysis, from the time
%  vectors of the import (as the GUI does):
%  - Time-resolved: the time in x and [0 1] in y.
%  - Temporal generalization: the testing time (cfg.tm.times_) in x and
%    the training time (cfg.tm.times) in y.
%  - Sliding filter: the time in x and the frequencies of the bands
%    (cfg.sf.freqvec + cfg.sf.hbw, as mvpalab_plotfreqcont) in y.
%  Without cfg, or with a cfg that has not been imported yet, graph.xlim is
%  empty, so the plots keep the limits of the data, and graph.chanlvl
%  stays at 0.5 without cfg.
%
%%  INPUT:
%
%  - {struct} - cfg (optional):
%    Configuration structure (cfg.tm, cfg.study, cfg.classmodel.tempgen
%    and cfg.sf).
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
graph.subject = 0;     % Subject of every plot, 0 for the mean of all subjects.
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
graph.xlim = [];

if nargin > 0
    graph = analysisaxes(graph,cfg);
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
graph.sigc = graph.colors.mvpalab{1};   % Above chance.
graph.sigc_ = [1 0 0];                  % Below chance.

%% Weights:
graph.weights.anim = 0;
graph.weights.type = 'raw';
graph.weights.start = 0;
graph.weights.end = 0;
graph.weights.speed = 0.1;




end

function graph = analysisaxes(graph,cfg)
%% Limits and labels of the axes of the analysis, once it is imported.

if ~isfield(cfg.tm,'times'), return; end

graph.xlim = cfg.tm.times([1 end]);
if cfg.classmodel.tempgen
    graph.xlim = cfg.tm.times_([1 end]);
    graph.ylim = cfg.tm.times([1 end]);
    graph.xlabel = 'Test time (ms)';
    graph.ylabel = 'Training time (ms)';
elseif cfg.sf.flag
    graph.ylim = cfg.sf.freqvec([1 end]) + cfg.sf.hbw;
    graph.ylabel = 'Frequency (Hz)';
end

end
