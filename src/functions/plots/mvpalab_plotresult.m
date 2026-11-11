function mvpalab_plotresult(graph,cfg,result,stats)
%% MVPALAB_PLOTRESULT
%
%  This function plots the result of a decoding analysis with the plot of
%  its type: the frequency contribution map in a sliding filter analysis
%  (see mvpalab_plotfreqcont), the temporal generalization matrix (see
%  mvpalab_plottempogen) or the time-resolved result (see
%  mvpalab_plotdecoding). It opens a new figure unless graph.add is set.
%
%  The sliding filter analysis of an MVCC saves both directions in one
%  result (fields ab and ba, see mvpalab_sfilter), so they are drawn in two
%  panels of the figure, each one with its statistics.
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
%    Result of one metric, or a structure with the fields ab and ba in the
%    sliding filter analysis of an MVCC.
%
%  - {struct} - stats (optional):
%    Statistics of the result, or empty.

if nargin < 4, stats = []; end

if ~graph.add, figure; end
hold on;

if cfg.sf.flag && isstruct(result)
    directions = {'ab','Train A, test B';'ba','Train B, test A'};
    for d = 1 : 2
        subplot(1,2,d);
        hold on;
        dirstats = [];
        if ~isempty(stats), dirstats = stats.(directions{d,1}); end
        mvpalab_plotfreqcont(graph,cfg,result.(directions{d,1}),dirstats);
        title(directions{d,2});
    end
elseif cfg.sf.flag
    mvpalab_plotfreqcont(graph,cfg,result,stats);
elseif cfg.classmodel.tempgen
    mvpalab_plottempogen(graph,cfg,result,stats);
else
    mvpalab_plotdecoding(graph,cfg,result,stats);
end

end
