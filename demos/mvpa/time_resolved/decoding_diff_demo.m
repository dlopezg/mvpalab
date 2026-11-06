%% Initialize the configuration files:

cfg = mvpalab_init();
run cfg_file
cfg.stats.nper = 10;
cfg.stats.nperg = 1000;
% Here you shoud modify the configuration files to compute different 
% decoding analyses.

cfg_a = cfg;
cfg_b = cfg;

%% Load data, generate conditions and feature extraction:

[cfg_a,data_a,fv_a] = mvpalab_import(cfg_a);
[cfg_b,data_b,fv_b] = mvpalab_import(cfg_b);

%% Compute MVPA analyses:

[result_a,cfg_a] = mvpalab_decoding(cfg_a,fv_a);
[result_b,cfg_b] = mvpalab_decoding(cfg_b,fv_b);

%% Compute permutation maps:

[permaps_a,cfg_a] = mvpalab_decoding(cfg_a,fv_a,'permuted');
[permaps_b,cfg_b] = mvpalab_decoding(cfg_b,fv_b,'permuted');


%% Calculate the difference:
result.acc = result_a.acc - result_b.acc;
permaps.acc = permaps_a.acc - permaps_b.acc;


%% Compute the statistical analysis:
stats = mvpalab_permtest(cfg_a,result,permaps);

%% Plot the results:

graph = mvpalab_plotinit();

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;

% Significant indicator:
graph.sigh = .4;

% Axis limits:
graph.xlim = [-200 1500];
graph.ylim = [-.3 .3];

% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'Classifier performance';
graph.title = 'Demo plot (statistical significance)';

% Smooth results:
graph.smoothdata = 5;

% Plot results:
figure;
hold on
mvpalab_plotdecoding(graph,cfg_a,result.acc,stats.acc);