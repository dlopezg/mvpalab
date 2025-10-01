%% Initialize and configure plots:

graph = mvpalab_plotinit();

%% Plot configuration:

% Axis limits:
graph.xlim = [-500 2000];
graph.ylim = [-.3 .5];

% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'Spearman correlation';
graph.title = 'EEG-fMRI fusion';

% Display configuration:
graph.chanlvl = 0;          % Indicate chance level
graph.smoothdata = 10;      % Smooth results
graph.fontsize = 20;        % Font size
graph.shadealpha = .9;      % Shade opacity
graph.linestyle = 'none';   % Line style

% Colors:
colormap = 'aguamarine';
graph.colorSch = graph.colors.(colormap);
graph.colorMap = graph.grads.(colormap);
  

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = true;

% Initialize figure:
figure(1); hold on;


%% ROI 1: VCC

% Load results:

load ('results/fusion_target/pearson/bin_rwVVC_bilateral/result.mat');
load ('results/fusion_target/pearson/bin_rwVVC_bilateral/stats.mat');

% Significant indicator:
graph.sigh = -.2;
graph.shadecolor = [0.5 0.5 0.5];
graph.sigc = graph.shadecolor;

% Load ROI mask:
mask_m1 = mvpalab_load_volumes('templates/bin_rwM1_bilateral.nii');
mask_vvc = mvpalab_load_volumes('templates/bin_rwVVC_bilateral.nii');
mask_brain = mvpalab_load_volumes('templates/mask.nii');

% Plot ROI:
subplot(2,3,3)
title('Ventral Visual Cortex (VVC)')
hold on
mvpalab_plotvolume(mask_vvc,5,graph.shadecolor);
mvpalab_plotvolume(mask_brain,.5,'#BBBBBB');

% Plot results:
subplot(2,3,[1 2 4 5])
hold on
mvpalab_plotdecoding(graph,cfg,result,stats);

%% ROI 2: M1

% Load results:
load ('results/fusion_target/pearson/bin_rwM1_bilateral/result.mat');
load ('results/fusion_target/pearson/bin_rwM1_bilateral/stats.mat');

% Significant indicator:
graph.sigh = -.25;
graph.shadecolor = graph.colorSch{10};
graph.sigc = graph.shadecolor;

% Plot ROI:
subplot(2,3,6)
hold on
title('Primary Motor Cortex (M1)')
mvpalab_plotvolume(mask_m1,5,graph.shadecolor);
mvpalab_plotvolume(mask_brain,.5,'#BBBBBB');


% Plot results:
subplot(2,3,[1 2 4 5])
hold on
mvpalab_plotdecoding(graph,cfg,result,stats);





