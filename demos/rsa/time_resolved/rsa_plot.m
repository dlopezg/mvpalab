%% Initialize and configure plots:

loaddir = 'results/time_resolved/regress/euclidean/tvalues';

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

plot(cfg.tm.times,result(:,:,1),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,2),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,3),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,4),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,5),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,6),'-.','Color',[.8 .8 .8])

load ([loaddir '/block_model/result.mat']);
load ([loaddir '/block_model/stats.mat']);

plot(cfg.tm.times,result(:,:,1),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,2),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,3),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,4),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,5),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,6),'-.','Color',[.8 .8 .8])

load ([loaddir '/validity_model/result.mat']);
load ([loaddir '/validity_model/stats.mat']);

plot(cfg.tm.times,result(:,:,1),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,2),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,3),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,4),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,5),'-.','Color',[.8 .8 .8])
plot(cfg.tm.times,result(:,:,6),'-.','Color',[.8 .8 .8])


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


%% Plot some DRMs

load results/nomatch/euclidean/rdms/result.mat

% Subject and timepoint:
graph.sub = 6;

graph.xlim = [cfg.tm.tpstart_ cfg.tm.tpend_];
graph.ylim = [cfg.tm.tpstart cfg.tm.tpend];
graph.caxis = [25 80];


% Colors:

graph.tmp = 10;
figure(3);
mvpalab_plotrdm(graph,cfg,result{graph.sub}(:,:,graph.tmp));


graph.tmp = 90;
figure(4);
mvpalab_plotrdm(graph,cfg,result{graph.sub}(:,:,graph.tmp));


graph.tmp = 109;
figure(5);
mvpalab_plotrdm(graph,cfg,result{graph.sub}(:,:,graph.tmp));


graph.tmp = 148;
figure(6);
mvpalab_plotrdm(graph,cfg,result{graph.sub}(:,:,graph.tmp));
colorbar
% figure(1);
% for i = 1 : size(rsa{3},1)
%     imagesc(squeeze(rsa{3}(i,:,:)),[-1 1]);
%     title(['T = ' num2str(cfg.tm.times(i)) 's'])
%     hline(bounds,'-k')
%     vline(bounds,'-k')
%
%     pause(0.00001);
% end

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
