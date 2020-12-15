clc;
clear;

%% Plot configuration:
graph = mvpalab_plotinit();

%% Mean accuracy plot:

% Load results:
load results/macc/diag/result.mat
load results/macc/diag/stats.mat

% Axis limits:
graph.xlim = [-200 1500];
graph.ylim = [.3 .95];

% Axes labels and title:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'Classifier performance';
graph.title = 'Diagonal plot (mean accuracy)';

% Smooth results:
graph.smoothdata = 1; % (1 => no smoothing)

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;

% Plot results:
figure;
subplot(1,2,2)
hold on
mvpalab_plotcr(graph,cfg,result,stats);

%% Temporal generalization matrix:

% Load results:
load results/macc/result.mat
load results/macc/stats.mat

% Axis limits:
graph.xlim = [-200 1500];
graph.ylim = [-200 1500];

% Axes labels and title:
graph.title = 'Temporal generalization matrix';
graph.xlabel = 'Training time (ms)';
graph.ylabel = 'Test time (ms)';

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;

% Plot results:
subplot(1,2,1)
mvpalab_plottg(graph,cfg,result,stats);