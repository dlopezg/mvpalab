function mvpalab_plotresult(graph,cfg,result,stats)
%% MVPALAB_PLOTRESULT
%
%  This function plots the result of a decoding analysis with the plot of
%  its type: the frequency contribution map in a sliding filter analysis
%  (see mvpalab_plotfreqcont), the temporal generalization matrix (see
%  mvpalab_plottempogen) or the time-resolved result (see
%  mvpalab_plotdecoding). It opens a new figure unless graph.add is set.
%
%%  INPUT:
%
%  - {struct} - graph:
%    Parameters of the plot (see mvpalab_plotinit).
%
%  - {struct} - cfg:
%    Configuration structure of the analysis.
%
%  - {matrix} - result:
%    Result of one metric.
%
%  - {struct} - stats (optional):
%    Statistics of the result, or empty.

if nargin < 4, stats = []; end

if ~graph.add, figure; end
hold on;

if cfg.sf.flag
    mvpalab_plotfreqcont(graph,cfg,result,stats);
elseif cfg.classmodel.tempgen
    mvpalab_plottempogen(graph,cfg,result,stats);
else
    mvpalab_plotdecoding(graph,cfg,result,stats);
end

end
