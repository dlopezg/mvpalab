%% Initialize and configure plots:

graph = mvpalab_plotinit();

%% Load results if needed: 

load results/diffMaps/result.mat

%% Mean accuracy plot (no statistical significance)

graph.xlim = [-100 1000];
graph.ylim = [0 20];

% Plot results:
figure;
subplot(1,2,1)
hold on
mvpalab_plotfreqcont(graph,cfg,result);

%% Mean accuracy plot (statistical significance)

% Load results and and statistics if needed:
load results/diffMaps/stats.mat

% Plot below and above chance clusters:
graph.stats.above = true;
graph.stats.below = true;

% Plot results:
subplot(1,2,2)
hold on
mvpalab_plotfreqcont(graph,cfg,result,stats);