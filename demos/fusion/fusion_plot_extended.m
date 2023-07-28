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
graph.shadecolor = graph.colorSch{1};
graph.sigc = graph.shadecolor;

% Load ROI mask:
mask_m1 = mvpalab_load_volumes('templates/bin_rwM1_bilateral.nii');
mask_vvc = mvpalab_load_volumes('templates/bin_rwVVC_bilateral.nii');
mask_a1 = mvpalab_load_volumes('templates/bin_rwA1_bilateral.nii');
mask_psl = mvpalab_load_volumes('templates/bin_rwPSL_bilateral.nii');
mask_rsc = mvpalab_load_volumes('templates/bin_rwRSC_bilateral.nii');
mask_sfl = mvpalab_load_volumes('templates/bin_rwSFL_bilateral.nii');
mask_brain = mvpalab_load_volumes('templates/mask.nii');

% Plot ROI:
subplot(2,5,3)
title('Ventral Visual Cortex (VVC)')
hold on
mvpalab_plotvolume(mask_m1,5,graph.shadecolor);
mvpalab_plotvolume(mask_brain,.5,'#BBBBBB');

% Plot results:
subplot(2,5,[1 2 6 7])
hold on
mvpalab_plotdecoding(graph,cfg,result,stats);

%% ROI 2: M1

% Load results:
load ('results/fusion_target/pearson/bin_rwM1_bilateral/result.mat');
load ('results/fusion_target/pearson/bin_rwM1_bilateral/stats.mat');

% Significant indicator:
graph.sigh = -.25;
graph.shadecolor = [193,86,104]/255;
graph.sigc = graph.shadecolor;

% Plot ROI:
subplot(2,5,8)
hold on
title('Primary Motor Cortex (M1)')
mvpalab_plotvolume(mask_m1,5,graph.shadecolor);
mvpalab_plotvolume(mask_brain,.5,'#BBBBBB');


% Plot results:
subplot(2,5,[1 2 6 7])
hold on
mvpalab_plotdecoding(graph,cfg,result,stats);

%% ROI 3: A1

% Load results:
load ('results/fusion_target/pearson/bin_rwA1_bilateral/result.mat');
load ('results/fusion_target/pearson/bin_rwA1_bilateral/stats.mat');

% Significant indicator:
graph.sigh = -.26;
graph.shadecolor = [192,135,185]/255;
graph.sigc = graph.shadecolor;

% Plot ROI:
subplot(2,5,4)
hold on
title('Early Auditory Cortex (A1)')
mvpalab_plotvolume(mask_a1,5,graph.shadecolor);
mvpalab_plotvolume(mask_brain,.5,'#BBBBBB');


% Plot results:
subplot(2,5,[1 2 6 7])
hold on
mvpalab_plotdecoding(graph,cfg,result,stats);

%% ROI 4: PSL

% Load results:
load ('results/fusion_target/pearson/bin_rwPSL_bilateral/result.mat');
load ('results/fusion_target/pearson/bin_rwPSL_bilateral/stats.mat');

% Significant indicator:
graph.sigh = -.27;
graph.shadecolor = [67,195,186]/255;
graph.sigc = graph.shadecolor;

% Plot ROI:
subplot(2,5,9)
hold on
title('tempo-parieto-occipital junction (PSL)')
mvpalab_plotvolume(mask_psl,5,graph.shadecolor);
mvpalab_plotvolume(mask_brain,.5,'#BBBBBB');


% Plot results:
subplot(2,5,[1 2 6 7])
hold on
mvpalab_plotdecoding(graph,cfg,result,stats);

%% ROI 5: SFL

% Load results:
load ('results/fusion_target/pearson/bin_rwSFL_bilateral/result.mat');
load ('results/fusion_target/pearson/bin_rwSFL_bilateral/stats.mat');

% Significant indicator:
graph.sigh = -.28;
graph.shadecolor = [224,32,76]/255;
graph.sigc = graph.shadecolor;

% Plot ROI:
subplot(2,5,5)
hold on
title('dorsolateral prefrontal cortex (SFL)')
mvpalab_plotvolume(mask_sfl,5,graph.shadecolor);
mvpalab_plotvolume(mask_brain,.5,'#BBBBBB');


% Plot results:
subplot(2,5,[1 2 6 7])
hold on
mvpalab_plotdecoding(graph,cfg,result,stats);

%% ROI 2: RSC

% Load results:
load ('results/fusion_target/pearson/bin_rwRSC_bilateral/result.mat');
load ('results/fusion_target/pearson/bin_rwRSC_bilateral/stats.mat');

% Significant indicator:
graph.sigh = -.29;
graph.shadecolor = [199,165,148]/255;
graph.sigc = graph.shadecolor;

% Plot ROI:
subplot(2,5,10)
hold on
title('Posterior Cingulate Cortex (RSC)')
mvpalab_plotvolume(mask_rsc,5,graph.shadecolor);
mvpalab_plotvolume(mask_brain,.5,'#BBBBBB');


% Plot results:
subplot(2,5,[1 2 6 7])
hold on
mvpalab_plotdecoding(graph,cfg,result,stats);





