%% Initialize and configure plots:

graph = mvpalab_plotinit();
graph.xlim = [-100 1000];
graph.ylim = [0 20];

%  The result of sfmvcc_demo has both directions and their mean (fields
%  ab, ba and mean, also saved in cfg.savefolder), drawn in one panel each
%  (see mvpalab_plotresult).

metric = cfg.sf.metric;

%% Mean accuracy plot (no statistical significance)

mvpalab_plotresult(graph,cfg,diffMap.(metric));

%% Mean accuracy plot (statistical significance)
%  Only if the permutation test was computed (cfg.stats.flag):

if cfg.stats.flag
    % Plot below and above chance clusters:
    graph.stats.above = true;
    graph.stats.below = true;

    mvpalab_plotresult(graph,cfg,diffMap.(metric),stats.(metric));
end
