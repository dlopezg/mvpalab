function mvpalab_refreshplot(graph)
%% MVPALAB_REFRESHPLOT
%
%  This function applies the labels, title, limits, color limits and
%  colormap of the graph structure to the current axes. graph.caxis is
%  applied only when it is not zero, and graph.xlim only when it is not
%  empty. The ticks that a plot set evenly spaced (every 100 ms in time,
%  every 0.05 in performance) are drawn again with the same spacing in the
%  new limits.
%
%%  INPUT:
%
%  - {struct} - graph:
%    Parameters of the plot (see mvpalab_plotinit): graph.xlabel,
%    graph.ylabel, graph.title, graph.xlim, graph.ylim, graph.caxis and
%    graph.colorMap.

    xlabel(graph.xlabel);
    if ~isempty(graph.xlim), xlim(graph.xlim); end
    title(graph.title);
    ylabel(graph.ylabel);
    ylim(graph.ylim);
    if any(graph.caxis), caxis(graph.caxis); end
    colormap(graph.colorMap);
    retick(gca,'X');
    retick(gca,'Y');
end

function retick(ax,name)
%% Ticks of one axis again in its limits, if a plot set them evenly
%  spaced.

ticks = get(ax,[name 'Tick']);
if strcmp(get(ax,[name 'TickMode']),'auto') || numel(ticks) < 2, return; end

step = ticks(2) - ticks(1);
if any(abs(diff(ticks) - step) > 1e-9*abs(step)), return; end

limits = get(ax,[name 'Lim']);
k = ceil((limits(1) - ticks(1))/step - 1e-9) : ...
    floor((limits(2) - ticks(1))/step + 1e-9);
set(ax,[name 'Tick'],ticks(1) + k*step);

end
