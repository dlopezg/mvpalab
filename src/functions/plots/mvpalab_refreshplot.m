function mvpalab_refreshplot(graph)
%% MVPALAB_REFRESHPLOT
%
%  This function applies the labels, title, limits, color limits and
%  colormap of the graph structure to the current axes. graph.caxis is
%  applied only when it is not zero.
%
%%  INPUT:
%
%  - {struct} - graph:
%    Parameters of the plot (see mvpalab_plotinit): graph.xlabel,
%    graph.ylabel, graph.title, graph.xlim, graph.ylim, graph.caxis and
%    graph.colorMap.

    xlabel(graph.xlabel);
    xlim(graph.xlim);
    title(graph.title);
    ylabel(graph.ylabel);
    ylim(graph.ylim);
    if any(graph.caxis), caxis(graph.caxis); end
    colormap(graph.colorMap);
end

