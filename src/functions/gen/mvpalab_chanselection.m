function X = mvpalab_chanselection(cfg,X)
%% MVPALAB_CHANSELECTION
%
%  This function returns the channels of cfg.channels.selected of a data
%  matrix, or all of them if the selection is empty. It gives an error if
%  the selection has a channel that the data does not have. The locations
%  of the selected channels are set by mvpalab_updatechanloc.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.channels.selected).
%
%  - {matrix} - X:
%    Data matrix [trials x channels x timepoints].
%
%%  OUTPUT:
%
%  - {matrix} - X:
%    Data matrix with the selected channels [trials x channels x
%    timepoints].

selected = cfg.channels.selected;
if isempty(selected), return; end

if max(selected) > size(X,2)
    error('mvpalab:chanselection',...
        'Channel selection fails: the data has %d channels.',size(X,2));
end

X = X(:,selected,:);

end
