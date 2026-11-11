function mvpalab_plotclusters(graph,x,y,stats)
%% MVPALAB_PLOTCLUSTERS
%
%  This function draws in the current axes the contours of the significant
%  clusters of a map, above chance (graph.stats.above) and below chance
%  (graph.stats.below). A tail is drawn only if it has a significant
%  cluster and not every point is significant, because the contour of a
%  constant mask is not defined.
%
%%  INPUT:
%
%  - {struct} - graph:
%    Parameters of the plot (see mvpalab_plotinit).
%
%  - {matrix} - x:
%    Coordinates of the columns of the map.
%
%  - {matrix} - y:
%    Coordinates of the rows of the map.
%
%  - {struct} - stats:
%    Statistics of the map, with stats.sigmask and stats.sigmask_ (see
%    mvpalab_computepermtest), or empty.

if isempty(stats), return; end

tails = {stats.sigmask,graph.stats.above,graph.clusterLineWidth,graph.clusterLineColor;
    stats.sigmask_,graph.stats.below,graph.clusterLineWidth_,graph.clusterLineColor_};

for tail = 1 : size(tails,1)
    [mask,selected,width,color] = tails{tail,:};
    if selected && any(~mask(:)) && any(mask(:))
        contour(x,y,mask,1,'LineWidth',width,'LineColor',color);
    end
end

end
