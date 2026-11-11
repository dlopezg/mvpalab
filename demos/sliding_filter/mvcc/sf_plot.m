%% Initialize and configure plots:

graph = mvpalab_plotinit();

%% Mean accuracy plot (no statistical significance)
%  The diffMaps of each direction are saved in their own folder.

graph.xlim = [-100 1000];
graph.ylim = [0 20];

folder = fullfile('results','diffMaps',cfg.sf.metric);

% Plot results:
figure;
subplot(2,2,1)
hold on
load(fullfile(folder,'ab','result.mat'));
mvpalab_plotfreqcont(graph,cfg,result);
subplot(2,2,2)
hold on
load(fullfile(folder,'ba','result.mat'));
mvpalab_plotfreqcont(graph,cfg,result);

%% Mean accuracy plot (statistical significance)
%  Only if the permutation test was computed (cfg.stats.flag):

if cfg.stats.flag
    % Plot below and above chance clusters:
    graph.stats.above = true;
    graph.stats.below = true;

    % Plot results:
    subplot(2,2,3)
    hold on
    load(fullfile(folder,'ab','result.mat'));
    load(fullfile(folder,'ab','stats.mat'));
    mvpalab_plotfreqcont(graph,cfg,result,stats);
    subplot(2,2,4)
    hold on
    load(fullfile(folder,'ba','result.mat'));
    load(fullfile(folder,'ba','stats.mat'));
    mvpalab_plotfreqcont(graph,cfg,result,stats);
end
