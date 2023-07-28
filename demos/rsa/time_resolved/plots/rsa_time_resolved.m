%% Initialize and configure plots:

loaddir = 'results/PRUEBA-NEW-RSA/corr/pearson';

graph = mvpalab_plotinit();
 
color = 'aguamarine';

% Axis limits:
graph.xlim = [-200 1100];
graph.ylim = [-.1 1.01];

% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'Dissimilarity value';

% Plot significant clusters (above and below chance):
graph.stats.above = true;
graph.stats.below = false;

graph.fontsize = 20;

graph.shadealpha = .9;
graph.linestyle = 'none';

% SEM or STD:
graph.stdsem = false;

% Indicate chance level:
graph.chanlvl = 0;

% Smooth results:
graph.smoothdata = 4; % (1 => no smoothing)

graph.colorSch = graph.colors.(color);
graph.colorMap = graph.grads.(color);


% Load results model 1: 

load ([loaddir '/stimuli_model/result.mat']);
load ([loaddir '/stimuli_model/stats.mat']);

% Significant indicator:
graph.sigh = -0.07;
graph.shadecolor = graph.colorSch{1};
graph.sigc = graph.shadecolor;

% On screen

graph.onscreen = [0 100];

% Plot results:
figure(1);
hold on
mvpalab_plotonscreen(graph)

for sub = 1 : size(result,3)
    plot(cfg.tm.times,result(:,:,sub),'-.','Color',[.8 .8 .8])
end

load ([loaddir '/block_model/result.mat']);
load ([loaddir '/block_model/stats.mat']);

for sub = 1 : size(result,3)
    plot(cfg.tm.times,result(:,:,sub),'-.','Color',[.8 .8 .8])
end

load ([loaddir '/validity_model/result.mat']);
load ([loaddir '/validity_model/stats.mat']);

for sub = 1 : size(result,3)
    plot(cfg.tm.times,result(:,:,sub),'-.','Color',[.8 .8 .8])
end

load ([loaddir '/stimuli_model/result.mat']);
load ([loaddir '/stimuli_model/stats.mat']);

mvpalab_plotdecoding(graph,cfg,result,stats);

% Load results model 2: 

load ([loaddir '/block_model/result.mat']);
load ([loaddir '/block_model/stats.mat']);

% Significant indicator:
graph.sigh = -0.05;
graph.shadecolor = graph.colorSch{3};
graph.sigc = graph.shadecolor;

% Plot results:
mvpalab_plotdecoding(graph,cfg,result,stats);

figure(2)
hold on
graph.sigh = -0.02;
mvpalab_plotdecoding(graph,cfg,result,stats);

% Load results model 2: 

load ([loaddir '/validity_model/result.mat']);
load ([loaddir '/validity_model/stats.mat']);

% Significant indicator:
graph.sigh = -0.03;
graph.shadecolor = graph.colorSch{8};
graph.sigc = graph.shadecolor;

% Plot results:
figure(1)
mvpalab_plotdecoding(graph,cfg,result,stats);

figure(2)
graph.sigh = -0.025;
graph.xlim = [200 800];
graph.ylim = [-.03 .08];
mvpalab_plotdecoding(graph,cfg,result,stats);




%%

load results/nostnomatch/euclidean/theo/result.mat

%%

figure(7);
graph.tmp = 1;
graph.caxis = [-.1 1];
graph.sub = 6;

subplot(1,3,1)
mvpalab_plotrdm(graph,cfg,result{graph.sub}(:,:,:,3));

graph.tmp = 1;

subplot(1,3,2)
mvpalab_plotrdm(graph,cfg,result{graph.sub}(:,:,1,1));

graph.tmp = 1;

subplot(1,3,3)
mvpalab_plotrdm(graph,cfg,result{graph.sub}(:,:,1,2));
