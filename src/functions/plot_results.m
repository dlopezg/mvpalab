function [] = plot_results( cfg, data, clusters )
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here

%% Path for external libraries:
path(path,'../extlibs/hline_vline/');
path(path,'../extlibs/stdshade/');

%% Plot the results:
figure;
xlabel('Time (s)');
ylabel('Classifier performance (acc)')
grid minor
ylim([.45 .8])
hold on

correct_rate = mean(data,3);
chance_level = zeros(1,length(correct_rate))+.5;

if exist('clusters')
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
    
    a = area(cfg.mvpa.times,significance,'LineStyle','-', 'EdgeAlpha',0);
    a.FaceColor = [.95 .95 .95];
    a.FaceAlpha = 1;
    
end

stdshade(squeeze(data)',.2,[.3 .3 .3],cfg.mvpa.times);
plot(cfg.mvpa.times,chance_level,'LineWidth',2,'LineStyle',':');
hl = vline(0,'k-','Cue onset timeeee');

end

