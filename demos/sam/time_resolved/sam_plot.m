%% Initialize and configure plots:

graph = mvpalab_plotinit();

%% Load results if needed: 

load results/time_resolved/acc/result.mat

%% Mean accuracy plot (no statistical significance)

% Axis limits:
graph.xlim = [-140 1400];
graph.ylim = [.3 .95];

% Axes labels and titles:
graph.xlabel = 'Time (ms)';
graph.ylabel = 'Classifier performance';
graph.title = 'Demo plot (no statistical significance)';

% Smooth results:
graph.smoothdata = 5; % (1 => no smoothing)

% Plot results:

acc = mean(result,3) + cfg.sam.bound;
acc = smooth(acc,graph.smoothdata);
bound =  mean(result,3);
bound = smooth(bound,graph.smoothdata);
figure;
hold on



h1 = area(cfg.tm.times,acc,0,'LineStyle','none');
h2 = area(cfg.tm.times,bound,0,'LineStyle','none');
plot(cfg.tm.times,bound,'k');
hline(.5,'k:')

h1(1).FaceColor = [.95 .95 .95];
h2(1).FaceColor = [1 1 1];

legend('Resubstitution error','','Proposed bound for the error')

xlim([-105 1495]);
ylim([0.45,0.65]);
xlabel('Time (ms)');
ylabel('Accuracy = 1 - Resub_{error}')


