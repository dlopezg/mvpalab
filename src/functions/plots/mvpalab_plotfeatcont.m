function mvpalab_plotfeatcont(graph,cfg,weights,result)
%% MVPALAB_PLOTFEATCONT
%
%  This function plots the feature contribution analysis: the topography
%  of the feature weights with topoplot from EEGLAB and, next to it, the
%  decoding performance with the selected temporal window. It opens new
%  figures, and shows a warning without plotting if
%  cfg.channels.selectedchanloc is empty. EEGLAB is checked with
%  mvpalab_checkeeglab.
%
%  The weights are averaged across subjects, or one subject is selected
%  (graph.weights.sub), between graph.weights.start and
%  graph.weights.end. In a sliding filter analysis the first band is
%  used. With graph.weights.anim, one topography per timepoint of the
%  window is shown as an animation (graph.weights.speed), which starts
%  when a key is pressed; otherwise the mean topography of the window is
%  shown, and a second figure shows the weights of the features sorted.
%  The chance level line is at graph.chanlvl.
%
%%  INPUT:
%
%  - {struct} - graph:
%    Parameters of the plot (see mvpalab_plotinit).
%
%  - {struct} - cfg:
%    Configuration structure (cfg.channels.selectedchanloc and cfg.tm).
%
%  - {cell array} - weights:
%    Feature weights of each subject and band {subjects,bands}, with
%    matrices [channels x ntp] (see mvpalab_storemap).
%
%  - {matrix} - result:
%    Decoding performance [1 x ntp x subjects] or, in temporal
%    generalization, [ntp x ntp_ x subjects], where the diagonal is
%    used. If it is empty, the performance is not plotted.

% Check cfg structure:
cfg = mvpalab_updatecfg(cfg);

if isempty(cfg.channels.selectedchanloc)
    warning('The feature weights need the channel locations (cfg.channels.selectedchanloc) to be plotted.');
    return
end

% Check if EEGlab is installed:
mvpalab_checkeeglab();

if ~isfield(graph,'xlim'), graph.xlim = cfg.tm.times([1 end]); end

%% Temporal window, weights and performance:
[~,startidx] = min(abs(cfg.tm.times - graph.weights.start));
[~,endidx] = min(abs(cfg.tm.times - graph.weights.end));
window = startidx : endidx;

w = selectweights(graph,weights,window);
perf = performance(graph,result);

%% Plot the weight analysis:
if graph.weights.anim
    figure;
    disp('Please, press any key to start animation.');
    pause
    for i = 1 : numel(window)
        clf;
        t = cfg.tm.times(window(i));
        plotpanels(graph,cfg,perf,w(:,i),@() vline(t,'r-'),...
            ['Decoding time: ' int2str(t) ' ms']);
        pause(1/(graph.weights.speed*1000));
    end
else
    w = mean(w,2);
    marker = zeros(size(cfg.tm.times));
    marker(window) = 1;

    figure;
    plotpanels(graph,cfg,perf,w,@() area(cfg.tm.times,marker,...
        'LineStyle','none','FaceColor',[.8 .8 .8]),...
        ['Decoding time: ' int2str(graph.weights.start) '-' ...
        int2str(graph.weights.end) ' ms']);

    plotsorted(graph,cfg,w);
end

end

function w = selectweights(graph,weights,window)
%% Weights of the selected subject, or their mean, in the window
%  [channels x timepoints]. The first band of a sliding filter analysis.

w = cat(3,weights{:,1});
if graph.weights.sub
    w = w(:,:,graph.weights.sub);
else
    w = mean(w,3);
end
w = w(:,window);

end

function perf = performance(graph,result)
%% Performance of the selected subject, or their mean [1 x ntp]: the
%  diagonal in temporal generalization. Empty without a result.

perf = [];
if isempty(result), return; end

result = result(:,:,:,1);
if size(result,1) > 1
    for sub = 1 : size(result,3)
        perf(1,:,sub) = diag(result(:,:,sub));
    end
else
    perf = result;
end

if graph.weights.sub
    perf = perf(:,:,graph.weights.sub);
else
    perf = mean(perf,3);
end

end

function plotpanels(graph,cfg,perf,w,marker,label)
%% Topography of the weights and, if there is a performance, the
%  performance with the temporal window on the left.

if ~isempty(perf)
    subplot(1,2,1);
    marker();
    hold on;
    times = cfg.tm.times(1:numel(perf));
    plot(times,zeros(size(times)) + graph.chanlvl,'k','LineWidth',.5,'LineStyle',':');
    plot(times,perf,'k');
    set(gca,'Color','w')
    set(gca,'XGrid','on');
    set(gca,'YAxisLocation','origin');
    set(gca,'XMinorTick','on','YMinorTick','on')
    set(gca,'FontSize',graph.fontsize)
    title('Decoding performance');
    xlabel('Time (ms)');
    ylabel('Performance');
    xlim(graph.xlim);
    ylim([min(perf) - .1, min(max(perf) + .1,1)]);
    set(gca,'Layer','top')

    subplot(1,2,2);
end

topoplot(w,cfg.channels.selectedchanloc,...
    'colormap', graph.colorMap,...
    'whitebk','on',...
    'electrodes','labels');
set(gca,'FontSize',graph.fontsize)
title(label)

end

function plotsorted(graph,cfg,w)
%% Weights of the features sorted, in a new figure.

figure;
hold on;
[sorted,idx] = sort(w);
labels = {cfg.channels.selectedchanloc.labels};
features = reordercats(categorical(labels(idx)),labels(idx));

b = bar(features,sorted,1,'FaceColor','flat');
shift = floor(size(graph.colorMap,1)/numel(sorted));
b.CData = graph.colorMap(1 + (0:numel(sorted)-1)*shift,:);

xlabel('List of features');
ylabel('Feature weights (a.u.)');
title('Feature contribution analysis');

set(gca,'FontSize',graph.fontsize)
set(gca,'Color','w')
set(gca,'XGrid','on');
set(gca,'YAxisLocation','origin');
set(gca,'XMinorTick','on','YMinorTick','on')

end
