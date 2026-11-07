function projected_data = mvpalab_project(input_data,params,cfg)
%% MVPALAB_PROJECT
%
%  This function projects data in the principal component space computed
%  in the training set of a fold (see mvpalab_dimred) and keeps the first
%  cfg.dimred.ncomp components. In temporal generalization it projects the
%  test set of each test timepoint (see mvpalab_evalfolds).
%
%%  INPUT:
%
%  - {matrix} - input_data:
%    Data to project [trials x features].
%
%  - {struct} - params:
%    PCA parameters of the fold, coeff and mu (see mvpalab_dimred).
%
%  - {struct} - cfg:
%    Configuration structure (cfg.dimred.ncomp).
%
%%  OUTPUT:
%
%  - {matrix} - projected_data:
%    Projected data [trials x cfg.dimred.ncomp].

input_data = input_data - params.mu;  % Xcentered
projected_data = input_data/params.coeff';   % Projected scores
projected_data = projected_data(:,1:cfg.dimred.ncomp,:);
end

