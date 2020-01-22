function [] = plot_results_sf( cfg, data, stats )
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here


%% Plot the results:

x = linspace(cfg.mvpa.tpstart,cfg.mvpa.tpend,size(data,2));
y = cfg.sf.freqvec+2;
acc_map = mean(-data,3);
contourf(x,y,acc_map,16,'LineStyle','none')

set(gca, 'YDir','normal')
set(gca,'YScale','log')

if exist('stats','var')
    x = linspace(cfg.mvpa.tpstart,cfg.mvpa.tpend,size(data,2));
    clusters_r = stats.clusters_r.sig;
    sig_clusters_r = mean(data,3);
    sig_clusters_r(clusters_r) = 1;
    sig_clusters_r(sig_clusters_r~=1) = 0;
    
    clusters_l = stats.clusters_l.sig;
    if ~isempty(clusters_l)
        sig_clusters_l = mean(data,3);
        sig_clusters_l(clusters_l) = 1;
        sig_clusters_l(sig_clusters_l~=1) = 0;
    end
    hold on
%     sig_clusters = logical(sig_clusters_r) | logical(sig_clusters_l);
    acc_map = acc_map.* sig_clusters_r;
    contourf(x,y,acc_map,16,'LineStyle','none')
    contour(x,y,sig_clusters_r,1,'LineColor',cfg.plot.sigrc,'LineWidth',1);
%     contour(x,y,sig_clusters_l,1,'LineColor',cfg.plot.siglc,'LineWidth',1);
    
end
end

