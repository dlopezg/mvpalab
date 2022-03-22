%% Initialize and configure plots:

graph = mvpalab_plotinit();

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
load results/time_resolved/acc/ab/result.mat
graph.shadecolor = graph.colors.mvpalab{10};
mvpalab_plotdecoding(graph,cfg,result);

% Colors B - A:
load results/time_resolved/acc/ba/result.mat
graph.shadecolor = graph.colors.mvpalab{6};
mvpalab_plotdecoding(graph,cfg,result);

% Colors mean:
load results/time_resolved/acc/mean/result.mat
graph.shadecolor = graph.colors.mvpalab{1};
mvpalab_plotdecoding(graph,cfg,result);

%% Mean accuracy plot (statistical significance)

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
load results/time_resolved/acc/ab/result.mat
load results/time_resolved/acc/ab/stats.mat
graph.shadecolor = graph.colors.mvpalab{10};
graph.sigc = graph.colors.mvpalab{10};
mvpalab_plotdecoding(graph,cfg,result,stats);

% Colors B - A:
load results/time_resolved/acc/ba/result.mat
load results/time_resolved/acc/ba/stats.mat
graph.sigh = .42;
graph.shadecolor = graph.colors.mvpalab{6};
graph.sigc = graph.colors.mvpalab{6};
mvpalab_plotdecoding(graph,cfg,result,stats);

% Colors mean:
load results/time_resolved/acc/mean/result.mat
load results/time_resolved/acc/mean/stats.mat
graph.sigh = .44;
graph.shadecolor = graph.colors.mvpalab{1};
graph.sigc = graph.colors.mvpalab{1};
mvpalab_plotdecoding(graph,cfg,result,stats);