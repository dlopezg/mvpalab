%% Plot MVPA and MVCC results:
%  The GUI leaves the statistics in the workspace only if they were loaded.

if ~exist('stats','var'), stats = []; end
mvpalab_plotresult(graph,cfg,result,stats);
