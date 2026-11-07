function bounds = mvpalab_findbound(Y)
%% MVPALAB_FINDBOUND
%
%  This function returns the indexes of the last trial and of the middle
%  trial of each condition. The trials of each condition must be together:
%  each change of label starts a new condition.
%
%%  INPUT:
%
%  - {matrix} - Y:
%    Categorical labels of each trial or condition [trials x 1]
%    (rdm.labels of mvpalab_rdm).
%
%%  OUTPUT:
%
%  - {struct} - bounds:
%    Indexes of each condition in the RDM:
%    - last: Index of the last trial [1 x conditions].
%    - middle: Index of the middle trial [conditions x 1].

%% Find boundaries:
%  Find first and last element of each condition:

changes = find(Y(1:end-1) ~= Y(2:end));
last = [changes; length(Y)];
first = [1; changes + 1];
middle = round((first + last) / 2);

%% Return boundaries:

bounds.last = last';
bounds.middle = middle;

end

