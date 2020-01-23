function [] = plot_results_2d( cfg, data, stats )
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here


%% Plot the results:
% axes = [cfg.mvpa.tpstart cfg.mvpa.tpend];
x = linspace(cfg.analysis.tpstart,cfg.analysis.tpend,size(data,1));
y = x;
acc_map = mean(data,3);
contourf(x,y,acc_map,16,'LineStyle','none')
% 
% imagesc(axes,axes,acc_map,clims);
hold on
set(gca, 'YDir','normal')

if exist('stats','var')
    clusters_r = stats.clusters_r.sig;
    clusters_l = stats.clusters_l.sig;
    
    if ~isempty(clusters_r)
        sig_clusters_r = mean(data,3);
        sig_clusters_r(clusters_r) = 0;
        sig_clusters_r(sig_clusters_r~=0) = 1;
        contour(x,y,sig_clusters_r,1,'linewidth',.5,'linecolor',cfg.plot.sigc);
    end
    if ~isempty(clusters_l)
        sig_clusters_l = mean(data,3);
        sig_clusters_l(clusters_l) = 0;
        sig_clusters_l(sig_clusters_l~=0) = 1;
        contour(x,y,sig_clusters_l,1,'linewidth',1,'linecolor','red');
    end
end
end

