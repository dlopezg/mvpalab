clc;
clear;

%% Plot configuration:
graph = mvpalab_plotinit();

%% Mean accuracy plot and significant clusters:

% Load results:
load results/macc/diag/result.mat
load results/macc/diag/stats.mat

% Axis limits:
graph.xlim = [-200 1500];
graph.ylim = [.3 .95];

% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'Classifier performance';
graph.title = 'Mean accuracy (diagonal, both directions)';

% Smooth results:
graph.smoothdata = 1; % (1 => no smoothing)

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;

% Plot results:
figure;
subplot(2,2,[1 2]);
hold on

% Direction: A -> B
graph.sigh = .4;
graph.sigc = graph.colors.mvpalab{10};
graph.shadecolor = graph.colors.mvpalab{10};
mvpalab_plotcr(graph,cfg,result.ab,stats.ab);

% Direction: B -> A
graph.sigh = .45;
graph.sigc = graph.colors.mvpalab{1};
graph.shadecolor = graph.colors.mvpalab{1};
mvpalab_plotcr(graph,cfg,result.ba,stats.ba);


%% Temporal generalization matrix and significant clusters:

% Load results and and statistics:
load results/macc/result.mat
load results/macc/stats.mat

% Axes labels and title:
graph.title = 'Temporal generalization matrix (A -> B)';
graph.xlabel = 'Training time (ms)';
graph.ylabel = 'Test time (ms)';

% Axis limits:
graph.xlim = [-200 1500];
graph.ylim = [-200 1500];

% Plot results:
% Direction: A -> B
subplot(2,2,3)
mvpalab_plottg(graph,cfg,result.ab,stats.ab);

% Direction: B -> A
subplot(2,2,4)
graph.title = 'Temporal generalization matrix (B -> A)';
mvpalab_plottg(graph,cfg,result.ba,stats.ba);