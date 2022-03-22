%% Initialize and configure plots:

graph = mvpalab_plotinit();

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
graph.title = 'Demo plot A - B';


% Plot TG:

load results/temporal_generalization/acc/ab/result.mat
figure;
subplot(2,3,1);
hold on;
mvpalab_plottempogen(graph,cfg,result);

load results/temporal_generalization/acc/ba/result.mat
subplot(2,3,2);
hold on;
mvpalab_plottempogen(graph,cfg,result);
graph.title = 'Demo plot B - A';

load results/temporal_generalization/acc/mean/result.mat
subplot(2,3,3);
hold on;
mvpalab_plottempogen(graph,cfg,result);
graph.title = 'Demo plot mean';

%% Mean accuracy plot (statistical significance)

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;

% Title:
graph.title = 'Demo plot  A- B (significant clusters)';

% Plot results:
load results/temporal_generalization/acc/ab/result.mat
load results/temporal_generalization/acc/ab/stats.mat
subplot(2,3,4);
hold on;
mvpalab_plottempogen(graph,cfg,result,stats);

load results/temporal_generalization/acc/ba/result.mat
load results/temporal_generalization/acc/ba/stats.mat
subplot(2,3,5);
hold on;
mvpalab_plottempogen(graph,cfg,result,stats);
graph.title = 'Demo plot  B - A (significant clusters)';

load results/temporal_generalization/acc/mean/result.mat
load results/temporal_generalization/acc/mean/stats.mat
subplot(2,3,6);
hold on;
mvpalab_plottempogen(graph,cfg,result,stats);
graph.title = 'Demo plot mean (significant clusters)';