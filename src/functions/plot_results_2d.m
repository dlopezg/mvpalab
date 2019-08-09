function [] = plot_results_2d( cfg, data, clusters )
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here
%% Plot the results:

figure;
axes = [cfg.mvpa.tpstart cfg.mvpa.tpend];
imagesc(axes, axes, mean(data,3));
set(gca, 'YDir','normal')
xlabel('Training time (s)');
ylabel('Test time (s)')

if cfg.plots.stats
    for cluster = 1 : clusters.NumObjects
        if ~isnan(clusters.PixelIdxList{cluster})
            for i = 1 : length(correct_rate)
                if ismember(i,clusters.PixelIdxList{cluster})
                    significance(i) = correct_rate(i);
                else
                    significance(i) = 0;
                end
            end
        end
    end
    
    a = area(cfg.times(1:cfg.mvpa.tpsteps:end),significance,'LineStyle','-', 'EdgeAlpha',0);
    a.FaceColor = [.95 .95 .95];
    a.FaceAlpha = 1;
    
end

end

