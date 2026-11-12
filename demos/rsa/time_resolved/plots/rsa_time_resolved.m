%% Initialize and configure plots:
%  run executes this script from the folder plots, so the results of the
%  demo are in ../results, in the folders of its cfg.

loaddir = fullfile('..','results',cfg.analysis,cfg.rsa.modality,...
    cfg.rsa.distance);

graph = mvpalab_plotinit();
 
color = 'aguamarine';

% Axis limits:
graph.xlim = [-100 1200];
graph.ylim = [-.3 1.5];

% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'Fisher z';

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = false;

graph.fontsize = 20;

graph.shadealpha = .9;
graph.linestyle = 'none';

% SEM or STD:
graph.stdsem = false;

% Indicate chance level:
graph.chanlvl = 0;

% Smooth results:
graph.smoothdata = 10; % (1 => no smoothing)

graph.colorSch = graph.colors.(color);
graph.colorMap = graph.grads.(color);

% Plot results:
figure(1);
hold on


% Load results model 1: 
load(fullfile(loaddir,'block_model','bvalues','result.mat'));
load(fullfile(loaddir,'block_model','bvalues','stats.mat'));

% Significant indicator:
graph.sigh = -0.1;
graph.shadecolor = graph.colorSch{1};
graph.sigc = graph.shadecolor;

mvpalab_plotdecoding(graph,cfg,result,stats);


% Load results model 2: 
load(fullfile(loaddir,'stimuli_model','bvalues','result.mat'));
load(fullfile(loaddir,'stimuli_model','bvalues','stats.mat'));

graph.sigh = -0.15;
graph.shadecolor = graph.colorSch{5};
graph.sigc = graph.shadecolor;

mvpalab_plotdecoding(graph,cfg,result,stats);

% for sub = 1 : size(result,3)
%     plot(cfg.tm.times,result(:,:,sub),'-.','Color',[.8 .8 .8])
% end

% Load results model 3:
load(fullfile(loaddir,'validity_model','bvalues','result.mat'));
load(fullfile(loaddir,'validity_model','bvalues','stats.mat'));

% Significant indicator:
graph.sigh = -0.2;
graph.shadecolor = graph.colorSch{10};
graph.sigc = graph.shadecolor;

mvpalab_plotdecoding(graph,cfg,result,stats);

% for sub = 1 : size(result,3)
%     plot(cfg.tm.times,result(:,:,sub),'-.','Color',[.8 .8 .8])
% end
