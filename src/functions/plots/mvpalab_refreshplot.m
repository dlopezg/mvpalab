function mvpalab_refreshplot(graph)
    xlabel(graph.xlabel);
    xlim(graph.xlim);
    title(graph.title);
    ylabel(graph.ylabel);
    ylim(graph.ylim);
    if any(graph.caxis), caxis(graph.caxis); end
    colormap(graph.colorMap);
end

