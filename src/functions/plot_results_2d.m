function [] = plot_results_2d( cfg, data, clusters_r, clusters_l )
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here

%% Path for external libraries:
path(path,'../extlibs/hline_vline/');

%% Plot the results:
axes = [cfg.mvpa.tpstart cfg.mvpa.tpend];
acc_map = mean(data,3);
clims = [min(min(acc_map)) max(max(acc_map))];
clims = [.3 .7];
imagesc(axes, axes, acc_map, clims);
set(gca, 'YDir','normal')
xlabel('Training time (s)');
ylabel('Test time (s)')
colorbar

if ~isempty(clusters_r)
    x = linspace(cfg.mvpa.tpstart,cfg.mvpa.tpend,size(data,1));
    y = x;
    sig_clusters = mean(data,3);
    sig_clusters(clusters_r) = 1;
    
    if ~isempty(clusters_l)
        sig_clusters(clusters_l) = 1;
    end
    
    sig_clusters(sig_clusters~=1) = 0;
    hold on
    contour(x,y,sig_clusters);
    title('Significance map')
end
end

