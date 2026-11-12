%% Initialize and configure plots:

graph = mvpalab_plotinit();

%% Load results if needed: 

load(fullfile('results','diffMaps',cfg.sf.metric,'result.mat'));

%% Mean accuracy plot (no statistical significance)

graph.xlim = [-100 1000];
graph.ylim = [0 20];

% Plot results:
figure;
subplot(1,2,1)
hold on
mvpalab_plotfreqcont(graph,cfg,result);

%% Mean accuracy plot (statistical significance)
%  Only if the permutation test was computed (cfg.stats.flag):

if cfg.stats.flag
    % Load results and statistics if needed:
    load(fullfile('results','diffMaps',cfg.sf.metric,'stats.mat'));

    % Plot below and above chance clusters:
    graph.stats.above = true;
    graph.stats.below = true;

    % Plot results:
    subplot(1,2,2)
    hold on
    mvpalab_plotfreqcont(graph,cfg,result,stats);
end
