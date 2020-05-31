function [] = mvpalab_svmvisualization( mdl, train_X_tp, test_X_tp, cfg, tp, train_Y, test_Y, acc )
%MVPALAB_SVMVISUALIZATION Summary of this function goes here
%   Detailed explanation goes here

% General plot conf:
plot_training = true;
plot_centroid = true;

% Colors:
color_a = [111 183 214]/255;
color_b = [204 236 239]/255;

%% Compute train and test data:
if plot_centroid
    class_a_train = mean(train_X_tp(train_Y,:));
    class_b_train = mean(train_X_tp(~train_Y,:));
    class_a_test = mean(test_X_tp(test_Y,:));
    class_b_test = mean(test_X_tp(~test_Y,:));
else
    class_a_train = train_X_tp(train_Y,:);
    class_b_train = train_X_tp(~train_Y,:);
    class_a_test = test_X_tp(test_Y,:);
    class_b_test = test_X_tp(~test_Y,:);
end

%% Plot decission boundaries:

% Plot conf:
dot_size = 10;
color_mtx = [color_b;color_a];

h1 = subplot(1,2,1);
cla(h1)
hold on

x = linspace(-3.5,3.5);
y = linspace(-3.5,3.5);
[XX,YY] = meshgrid(x,y);
pred = [XX(:),YY(:)];
p = predict(mdl,pred);
gscatter(pred(:,1),pred(:,2),p,color_mtx,[],dot_size)

%% Plot test and trainning data:

% Plot conf:
alpha = .3;
x_lim = [-3.5,3.5];
y_lim = [-3.5,3.5];

scatter(class_a_test(:,1),class_a_test(:,2),200,color_a,'filled','o','MarkerEdgeColor','k');
scatter(class_b_test(:,1),class_b_test(:,2),200,color_b,'filled','o','MarkerEdgeColor','k');

if plot_training
    scatter(class_a_train(:,1),class_a_train(:,2),200,color_a,...
        'filled','d','MarkerEdgeColor','k',...
        'MarkerFaceAlpha',alpha,'MarkerEdgeAlpha',alpha);
    scatter(class_b_train(:,1),class_b_train(:,2),200,color_b,...
        'filled','d','MarkerEdgeColor','k',...
        'MarkerFaceAlpha',alpha,'MarkerEdgeAlpha',alpha);
end

% Plot titles and axes configuration:
title('Feature space visualization')
xlabel(['Timepoint = ' int2str(cfg.tm.times(tp)) 'ms - Performance = ' num2str(acc)])
xlim (x_lim);
ylim (y_lim);
legend({'Class boundary: A','Class boundary: B','Test centroid: A',...
    'Test centroid: B','Training centroid: A','Training centroid: B'},...
    'Location','northwest');


%% Plot performance values:

h2 = subplot(1,2,2);
hold on
area(cfg.tm.times(tp),1,'EdgeColor',color_a,'LineWidth',3);
area(cfg.tm.times(tp),acc,'EdgeColor',color_b,'LineWidth',3);
title('Performance of the classifier')
xlabel('Time (ms)');
ylabel('Model performance');
ylim ([.2,.8]);
xlim ([-200,1500]);
pause(.5);


end

