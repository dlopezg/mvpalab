function mvpalab_plotfeatcont(graph,cfg,weights,result)
%% MVPALAB_PLOTFEATCONT
%
%  This function plots the feature contribution analysis: the topography
%  of the feature weights with topoplot from EEGLAB and, next to it, the
%  decoding performance with the selected temporal window. It opens new
%  figures and does nothing if cfg.channels.selectedchanloc is empty.
%  EEGLAB is checked with mvpalab_checkeeglab.
%
%  The weights are averaged across subjects, or one subject is selected
%  (graph.weights.sub), between graph.weights.start and
%  graph.weights.end. With graph.weights.anim, one topography per
%  timepoint is shown as an animation (graph.weights.speed), which
%  starts when a key is pressed; otherwise the mean topography of the
%  window is shown, and a second figure shows the weights of the features
%  sorted. The chance level line is at 0.5.
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
%    Feature weights of each subject {subjects,1}, with matrices
%    [channels x ntp] (see mvpalab_storemap).
%
%  - {matrix} - result:
%    Decoding performance [1 x ntp x subjects] or, in temporal
%    generalization, [ntp x ntp_ x subjects], where the diagonal is
%    used. If it is empty or a struct, the performance is not plotted.

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

if isempty(cfg.channels.selectedchanloc)
    
else
    
    % Check if EEGlab is installed:
    mvpalab_checkeeglab();
    
    if ~isfield(graph,'xlim')
        graph.xlim = [cfg.tm.times(1),cfg.tm.times(end)];
    end
    
    % Select subject, type and temporal window:
    subject = graph.weights.sub;
    start_time = graph.weights.start;
    end_time = graph.weights.end;
    
    %% Find closest points in the time vector:
    [~,startidx] = min(abs(cfg.tm.times-start_time));
    [~,endidx] = min(abs(cfg.tm.times-end_time));
    
    %% Select weights to plot:
    if ~subject
        for i = 1 : length(weights)
            weights_to_plot(:,:,i) = weights{i,1}(:,startidx:endidx);
        end
        weights_to_plot = mean(weights_to_plot,3);
    else
        weights_to_plot = weights{subject,1}(:,startidx:endidx);
    end
    
    %% Check if plot performance:
    resultToPlot = [];
    if ~isempty(result) && ~isstruct(result)
        if size(result,1) > 1
            if ~subject
                for i = 1 : size(result,3)
                    resultToPlot(1,:,i) = diag(result(:,:,i));
                end
                resultToPlot = mean(resultToPlot,3);
            else
                resultToPlot = diag(result(:,:,subject));
            end
        else
            if ~subject
                resultToPlot = mean(result,3);
            else
                resultToPlot = result(:,:,subject);
            end
        end
        
        if max(resultToPlot)+.1 > 1
            ylimit = [min(resultToPlot)-.1,1];
        else
            ylimit = [min(resultToPlot)-.1, max(resultToPlot)+.1];
        end
        windowToPlot = zeros(1,length(cfg.tm.times));
        windowToPlot(1,startidx:endidx) = 1;
    end
    
    %% Plot the weight analysis:
    chancelevel = zeros(1,length(resultToPlot))+.5;
    
    if graph.weights.anim
        figure;
        disp('Please, press any key to start animation.');
        pause
        for i = 1 : size(weights_to_plot,2)-1
            clf;
            set(gca,'FontSize',graph.fontsize)
            if ~isempty(resultToPlot)
                subplot(1,2,1);
                vline(cfg.tm.times(startidx+i),'r-');
                hold on;
                
                plot(cfg.tm.times,chancelevel,'k','LineWidth',.5,'LineStyle',':');
                plot(cfg.tm.times,resultToPlot,'k');
                set(gca,'Color','w')
                set(gca,'XGrid','on');
                set(gca,'YAxisLocation','origin');
                set(gca,'XMinorTick','on','YMinorTick','on')
                title('Decoding performance');
                xlabel('Time (ms)');
                ylabel('Performance');
                xlim(graph.xlim);
                ylim(ylimit);
                set(gca,'Layer','top')
                
                subplot(1,2,2);
            end
            
            title(['Decoding time: ' int2str(cfg.tm.times(startidx+i)) ' ms'])
            topoplot(weights_to_plot(:,i),cfg.channels.selectedchanloc,...
                'colormap', graph.colorMap,...
                'whitebk','on',...
                'electrodes','labels');
            pause(1/(graph.weights.speed*1000));
        end
    else
        % Compute the mean and plot it:
        weights_to_plot = mean(weights_to_plot,2);
        
        figure;
        set(gca,'FontSize',graph.fontsize)
        
        if ~isempty(resultToPlot)
            subplot(1,2,1);
            h = area(cfg.tm.times,windowToPlot,'LineStyle','none');
            h(1).FaceColor = [.8,.8,.8];
            hold on;
            plot(cfg.tm.times,chancelevel,'k','LineWidth',.5,'LineStyle',':');
            plot(cfg.tm.times,resultToPlot,'k');
            set(gca,'Color','w')
            set(gca,'XGrid','on');
            set(gca,'YAxisLocation','origin');
            set(gca,'XMinorTick','on','YMinorTick','on')
            title('Decoding performance');
            xlabel('Time (ms)');
            ylabel('Performance');
            xlim(graph.xlim);
            ylim(ylimit);
            set(gca,'Layer','top')
            
            subplot(1,2,2);
        end
        
        topoplot(weights_to_plot,cfg.channels.selectedchanloc,...
            'colormap', graph.colorMap,...
            'whitebk','on',...
            'electrodes','labels');
        title(['Decoding time: ' int2str(start_time) '-' int2str(end_time) ' ms'])
        
        % Sorted feature contribution plot:
        
        figure;
        hold on;
        [sorted,idx] = sort(weights_to_plot);
        labels = extractfield(cfg.channels.selectedchanloc,'labels');
        sortedLabels = labels(idx);
        features = categorical(sortedLabels);
        features = reordercats(features,sortedLabels);

        b = bar(features,sorted,1,'FaceColor','flat');
        
        shift = floor(size(graph.colorMap,1)/length(sorted));
        idx = 1;
        for i = 1 : length(sorted)
            b.CData(i,:) = graph.colorMap(idx,:);
            idx = idx + shift;
        end
        
        xlabel('List of features');
        ylabel('Feature weights (a.u.)');
        title('Feature contribution analysis');
        
        set(gca,'FontSize',graph.fontsize)
        set(gca,'Color','w')
        set(gca,'XGrid','on');
        set(gca,'YAxisLocation','origin');
        set(gca,'XMinorTick','on','YMinorTick','on')
    end
end
end
