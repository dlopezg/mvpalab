function [] = plot_results( cfg, data, stats )
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here

%% Plot the results:
c = cfg.plot;
correct_rate = mean(data,3);
chance_level = zeros(1,length(correct_rate))+.5;

if exist('stats','var')
    clusters.r = stats.clusters_r.sig;
    clusters.l = stats.clusters_l.sig;
    for i = 1 : length(correct_rate)
        if ismember(i,clusters.r) || ismember(i,clusters.l)
            significance(i) = c.sigh;
%             significance(i) = correct_rate(i);

        else
            significance(i) = 0;
        end
    end
    scatter(cfg.analysis.times,significance,100,c.sigc,'filled','s');
%     a.FaceColor = [.95 .95 .95];
%     a.FaceAlpha = 1;

end

stdshade(squeeze(data)',c.shadealpha,c.linecolor,cfg.analysis.times,5);
plot(cfg.analysis.times,chance_level,'k','LineWidth',.5,'LineStyle','-');

end

