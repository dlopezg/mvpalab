function mvpalab_plotwanalysis(graph,cfg,weights)
if isempty(cfg.chanloc)
    
else
    % Check if EEGlab is installed:
    mvpalab_checkeeglab();
    
    % Select subject, type and temporal window:
    subject = graph.weights.subject;
    type = graph.weights.type;
    start_time = graph.weights.start;
    end_time = graph.weights.end;
    
    %% Find closest points in the time vector:
    [~,startidx] = min(abs(cfg.tm.times-start_time));
    [~,endidx] = min(abs(cfg.tm.times-end_time));
    
    if strcmp(type,'raw')
        weights_to_plot = weights.raw{subject,1}(:,startidx:endidx);
    elseif strcmp(type,'corrected')
        weights_to_plot = weights.haufe_corrected{subject,1}(:,startidx:endidx);
    end
    
    if graph.weights.animation
        for i = 1 : size(weights_to_plot,2)-1
            clf;
            title(['Decoding time: ' int2str(cfg.tm.times(startidx+i)) ' ms'])
            topoplot(weights_to_plot(:,i),cfg.chanloc,...
                'colormap', graph.colorMap,...
                'whitebk','on',...
                'electrodes','labels');
            pause(1/(graph.weights.speed*100));
        end
    else
        % Compute the mean and plot it:
        weights_to_plot = mean(weights_to_plot,2);
        
        figure;
        topoplot(weights_to_plot,cfg.chanloc,...
            'colormap', graph.colorMap,...
            'whitebk','on',...
            'electrodes','labels');
        title(['Decoding time: ' int2str(start_time) '-' int2str(end_time) ' ms'])
        
        % Sorted feature contribution plot:
        [sorted,idx] = sort(weights_to_plot);
        labels = extractfield(cfg.chanloc,'labels');
        sortedLabels = labels(idx);
        features = categorical(sortedLabels);
        features = reordercats(features,sortedLabels);
        
        figure; bar(features,sorted,1,'k');
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
