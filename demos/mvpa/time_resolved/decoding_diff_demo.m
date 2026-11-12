%% Initialize the configuration files:

cfg = mvpalab_init();
run cfg_file
% The permutation test is computed below on the difference, not inside
% each analysis:
cfg.stats.flag = false;
cfg.stats.nper = 10;
cfg.stats.nperg = 1000;

% Modify cfg_a and cfg_b to compute two different decoding analyses. Each
% one saves its results in its own folder (cfg.analysis):
cfg_a = cfg;
cfg_a.analysis = 'decoding_a';
cfg_b = cfg;
cfg_b.analysis = 'decoding_b';

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
%  The difference and its statistics are saved in their own folder:
cfg_diff = cfg_a;
cfg_diff.savefolder = fullfile(cfg.location,'results','decoding_diff','time_resolved');
mvpalab_save(cfg_diff,result,'res');
stats = mvpalab_permtest(cfg_diff,result,permaps);

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