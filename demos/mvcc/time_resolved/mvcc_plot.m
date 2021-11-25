%% Initialize and configure plots:

graph = mvpalab_plotinit();

%% Load results if needed: 

load results/time_resolved/acc/result.mat

%% Mean accuracy plot (no statistical significance)

% Axis limits:
graph.xlim = [-200 1500];
graph.ylim = [.3 .95];

% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'Classifier performance';
graph.title = 'Demo plot (no statistical significance)';

% Smooth results:
graph.smoothdata = 5; % (1 => no smoothing)

% Plot results:
figure;
subplot(1,2,1);
hold on
% Colors A - B:
graph.shadecolor = graph.colors.mvpalab{10};
mvpalab_plotdecoding(graph,cfg,result.ab);

% Colors B - A:
graph.shadecolor = graph.colors.mvpalab{1};
mvpalab_plotdecoding(graph,cfg,result.ba);

%% Mean accuracy plot (statistical significance)

% Load results and and statistics if needed:
load results/time_resolved/acc/result.mat
load results/time_resolved/acc/stats.mat

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;

% Significant indicator:
graph.sigh = .4;

% Title:
graph.title = 'Demo plot (statistical significance)';

% Plot results:
subplot(1,2,2);
hold on

% Colors A - B:
graph.shadecolor = graph.colors.mvpalab{10};
graph.sigc = graph.colors.mvpalab{10};
mvpalab_plotdecoding(graph,cfg,result.ab,stats.ab);

% Colors B - A:
graph.sigh = .45;
graph.shadecolor = graph.colors.mvpalab{1};
graph.sigc = graph.colors.mvpalab{1};
mvpalab_plotdecoding(graph,cfg,result.ba,stats.ba);