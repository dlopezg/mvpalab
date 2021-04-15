function mvpalab_plotwanalysis(graph,cfg,weights,result)
if isempty(cfg.chanloc)
    
else
    % Check if EEGlab is installed:
    mvpalab_checkeeglab();
    
    if ~isfield(graph,'xlim')
        graph.xlim = [cfg.tm.times(1),cfg.tm.times(end)];
    end
    
    % Select subject, type and temporal window:
    subject = graph.weights.subject;
    type = graph.weights.type;
    start_time = graph.weights.start;
    end_time = graph.weights.end;
    
    %% Find closest points in the time vector:
    [~,startidx] = min(abs(cfg.tm.times-start_time));
    [~,endidx] = min(abs(cfg.tm.times-end_time));
    
    %% Select weights to plot:
    if ~subject
        for i = 1 : length(weights.(type))
            weights_to_plot(:,:,i) = weights.(type){i,1}(:,startidx:endidx);
        end
        weights_to_plot = mean(weights_to_plot,3);
    else
        weights_to_plot = weights.(type){subject,1}(:,startidx:endidx);
    end
    
    %% Check if plot performance:
    resultToPlot = [];
    if ~isempty(result)
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
    
    if graph.weights.animation
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
            topoplot(weights_to_plot(:,i),cfg.chanloc,...
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
        
        topoplot(weights_to_plot,cfg.chanloc,...
            'colormap', graph.colorMap,...
            'whitebk','on',...
            'electrodes','labels');
        title(['Decoding time: ' int2str(start_time) '-' int2str(end_time) ' ms'])
        
        % Sorted feature contribution plot:
        
        figure;
        [sorted,idx] = sort(weights_to_plot);
        labels = extractfield(cfg.chanloc,'labels');
        sortedLabels = labels(idx);
        features = categorical(sortedLabels);
        features = reordercats(features,sortedLabels);
        
        bar(features,sorted,1,'k');
        
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
