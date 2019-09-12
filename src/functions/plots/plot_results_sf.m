function [] = plot_results_sf( cfg, data, stats )
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here


%% Plot the results:

x = [cfg.mvpa.tpstart cfg.mvpa.tpend];
y = 1 : length(cfg.sf.freqvec);
acc_map = mean(-data,3);
clims = [min(min(acc_map)) max(max(acc_map))];
clims = [min(min(acc_map)) 0];
% clims = [-.2 .2];
imagesc(x,y,acc_map,clims);
set(gca, 'YDir','normal')
set(gca,'YScale','log')
xlabel('Training time (s)');
ylabel('Test time (s)');
colorbar

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
    
%     imagesc(x,y,sig_clusters_r);
    
    yyaxis right
    lfreq = cfg.sf.lfreq;
    hfreq = cfg.sf.hfreq;
    
%     contour(x,y,sig_clusters_l,1,'LineColor','r');
    contour(x,y,sig_clusters_r,1,'LineColor','w','LineWidth',1);
    title('Significance map')
end
end

