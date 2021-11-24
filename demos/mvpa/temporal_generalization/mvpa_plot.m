%% Initialize and configure plots:

graph = mvpalab_plotinit();

%% Load results if needed: 

load results/temporal_generalization/acc/result.mat

%% Mean accuracy plot (no statistical significance)

% Colors:
graph.colorMap = graph.grads.earth;
graph.colors = graph.colors.earth;

% Axis limits:
graph.xlim = [cfg.tm.tpstart_ cfg.tm.tpend_];
graph.ylim = [cfg.tm.tpstart cfg.tm.tpend];
graph.caxis = [.3 .7];
graph.onscreen = [0 190];

% Axes labels and titles:
graph.xlabel = 'Test (ms)';
graph.ylabel = 'Train (ms)';
graph.title = 'Demo plot (no statistical significance)';


% Plot TG:
figure;
subplot(1,2,1);
hold on;
mvpalab_plottempogen(graph,cfg,result);


%% Mean accuracy plot (statistical significance)

% Load results and and statistics if needed:
load results/temporal_generalization/acc/result.mat
load results/temporal_generalization/acc/stats.mat

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;

% Significant indicator:
graph.sigh = .4;

% Title:
graph.title = 'Demo plot (statistical significance)';

% Plot results:
subplot(1,2,2);
hold on;
mvpalab_plottempogen(graph,cfg,result,stats);