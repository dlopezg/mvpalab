function [] = plot_results_2d( cfg, data, stats )
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here


%% Plot the results:
% axes = [cfg.mvpa.tpstart cfg.mvpa.tpend];
axes = [cfg.analysis.tpstart cfg.analysis.tpend];
acc_map = mean(data,3);
clims = [min(min(acc_map)) max(max(acc_map))];
clims = [0.5 max(max(acc_map))];
imagesc(axes,axes,acc_map,clims);
hold on
set(gca, 'YDir','normal')
xlabel('Training time (s)');
ylabel('Test time (s)')
colorbar

if exist('stats','var')
    clusters_r = stats.clusters_r.sig;
    clusters_l = stats.clusters_l.sig;
    
    x = linspace(cfg.analysis.tpstart,cfg.analysis.tpend,size(data,1));
    y = x;
    if ~isempty(clusters_r)
        sig_clusters_r = mean(data,3);
        sig_clusters_r(clusters_r) = 1;
        sig_clusters_r(sig_clusters_r~=1) = 0;
        contour(x,y,sig_clusters_r,1,'linewidth',.5,'linecolor',[1 1 1]);
    end
    if ~isempty(clusters_l)
        sig_clusters_l = mean(data,3);
        sig_clusters_l(clusters_l) = 1;
        sig_clusters_l(sig_clusters_l~=1) = 0;
        contour(x,y,sig_clusters_l,1,'linewidth',.5,'linecolor','red');
    end
    title('Significance map')
end
end
