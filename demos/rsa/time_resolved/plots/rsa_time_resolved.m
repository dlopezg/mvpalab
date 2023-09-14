%% Initialize and configure plots:

loaddir = '/Users/David/Sourcecode/mvpalab/demos/rsa/time_resolved/results/demo-rsa/corr/pearson';

graph = mvpalab_plotinit();
 
color = 'aguamarine';

% Axis limits:
graph.xlim = [-200 7000];
graph.ylim = [-.3 .3];

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
graph.smoothdata = 10; % (1 => no smoothing)

graph.colorSch = graph.colors.(color);
graph.colorMap = graph.grads.(color);

% Plot results:
figure(1);
hold on


% Load results model 1: 
load ([loaddir '/target_category_model/result.mat']);
load ([loaddir '/target_category_model/stats.mat']);

% Significant indicator:
graph.sigh = -0.1;
graph.shadecolor = graph.colorSch{1};
graph.sigc = graph.shadecolor;

mvpalab_plotdecoding(graph,cfg,result,stats);


% Load results model 2: 
load ([loaddir '/task_demand_model/result.mat']);
load ([loaddir '/task_demand_model/stats.mat']);

graph.sigh = -0.15;
graph.shadecolor = graph.colorSch{5};
graph.sigc = graph.shadecolor;

mvpalab_plotdecoding(graph,cfg,result,stats);

% for sub = 1 : size(result,3)
%     plot(cfg.tm.times,result(:,:,sub),'-.','Color',[.8 .8 .8])
% end

% Load results model 3:
load ([loaddir '/target_relevant_feature/result.mat']);
load ([loaddir '/target_relevant_feature/stats.mat']);

% Significant indicator:
graph.sigh = -0.2;
graph.shadecolor = graph.colorSch{10};
graph.sigc = graph.shadecolor;

mvpalab_plotdecoding(graph,cfg,result,stats);

% for sub = 1 : size(result,3)
%     plot(cfg.tm.times,result(:,:,sub),'-.','Color',[.8 .8 .8])
% end




%%

% load results/nostnomatch/euclidean/theo/result.mat

%%

% figure(7);
% graph.tmp = 1;
% graph.caxis = [-.1 1];
% graph.sub = 6;
% 
% subplot(1,3,1)
% mvpalab_plotrdm(graph,cfg,result{graph.sub}(:,:,:,3));
% 
% graph.tmp = 1;
% 
% subplot(1,3,2)
% mvpalab_plotrdm(graph,cfg,result{graph.sub}(:,:,1,1));
% 
% graph.tmp = 1;
% 
% subplot(1,3,3)
% mvpalab_plotrdm(graph,cfg,result{graph.sub}(:,:,1,2));
