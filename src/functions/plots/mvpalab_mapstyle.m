function mvpalab_mapstyle(graph,map)
%% MVPALAB_MAPSTYLE
%
%  This function applies the appearance of a map plot to the current axes:
%  title, labels, limits, colorbar, colormap and axes style. The color
%  limits are graph.caxis, or the minimum and maximum of the map if
%  graph.caxis is zero. An empty graph.xlim keeps the limits of the data.
%
%%  INPUT:
%
%  - {struct} - graph:
%    Parameters of the plot (see mvpalab_plotinit).
%
%  - {matrix} - map:
%    Map drawn in the axes.

title(graph.title);
xlabel(graph.xlabel);
ylabel(graph.ylabel);
if ~isempty(graph.xlim), xlim(graph.xlim); end
ylim(graph.ylim);
colorbar('Eastoutside');
colormap(graph.colorMap);

set(gca,'XMinorTick','on','YMinorTick','on');
set(gca,'XTickLabelRotation',90);
set(gca,'YAxisLocation','origin');
set(gca,'XAxisLocation','origin');
set(gca,'YColor','k');
set(gca,'XColor','k');
set(gca,'FontSize',graph.fontsize);
set(gca,'Layer','top');

if any(graph.caxis)
    caxis(graph.caxis);
else
    caxis([min(map(:)) max(map(:))]);
end

end
