function mvpalab_refreshplot(graph)
    xlabel(graph.xlabel);
    xlim(graph.xlim);
    title(graph.title);
    ylabel(graph.ylabel);
    ylim(graph.ylim);
    caxis(graph.caxis);
    colormap(graph.colorMap);
end

