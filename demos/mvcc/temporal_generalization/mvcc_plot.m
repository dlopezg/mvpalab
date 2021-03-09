%% Initialize and configure plots:

graph = mvpalab_plotinit();

%% Load results if needed: 

load results/temporal_generalization/acc/result.mat

%% Mean accuracy plot (no statistical significance)

% Colors:
graph.colorMap = graph.grads.earth;
graph.colors = graph.colors.earth;

% Axis limits:
graph.xlim = [-100 1500];
graph.ylim = [-100 1500];
graph.caxis = [.3 .7];
graph.onscreen = [0 190];

% Axes labels and titles:
graph.xlabel = 'Train (ms)';
graph.ylabel = 'Test (ms)';
graph.title = 'Demo plot A - B';


% Plot TG:
figure;
subplot(2,2,1);
hold on;
mvpalab_plottg(graph,cfg,result.ab);

subplot(2,2,2);
hold on;
mvpalab_plottg(graph,cfg,result.ba);
graph.title = 'Demo plot B - A';


%% Mean accuracy plot (statistical significance)

% Load results and and statistics if needed:
load results/temporal_generalization/acc/result.mat
load results/temporal_generalization/acc/stats.mat

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;

% Title:
graph.title = 'Demo plot  A- B (significant clusters)';

% Plot results:
subplot(2,2,3);
hold on;
mvpalab_plottg(graph,cfg,result.ab,stats.ab);

subplot(2,2,4);
hold on;
mvpalab_plottg(graph,cfg,result.ba,stats.ba);
graph.title = 'Demo plot  B - A (significant clusters)';