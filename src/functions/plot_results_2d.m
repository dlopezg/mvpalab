function [] = plot_results_2d( cfg, data, clusters )
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here

%% Path for external libraries:
path(path,'../extlibs/hline_vline/');

%% Plot the results:
figure;
axes = [cfg.mvpa.tpstart cfg.mvpa.tpend];
imagesc(axes, axes, mean(data,3));
set(gca, 'YDir','normal')
xlabel('Training time (s)');
ylabel('Test time (s)')
colorbar

if ~isempty(clusters)
    x = linspace(cfg.mvpa.tpstart,cfg.mvpa.tpend,129);
    y = x;
    acc_sig = mean(data,3);
    acc_sig(clusters) = 1;
    acc_sig(acc_sig~=1) = 0;
    hold on
    contour(x,y,acc_sig);
    title('Significance map')
end

end

