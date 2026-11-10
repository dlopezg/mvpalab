function X = mvpalab_preparetest(X,fold)
%% MVPALAB_PREPARETEST
%
%  This function applies the transformation fitted on the training set of a
%  fold (see mvpalab_preparetrain) to a test set: the normalization and,
%  with PCA, the projection on the principal components (see
%  mvpalab_project).
%
%%  INPUT:
%
%  - {matrix} - X:
%    Test set [trials x features].
%
%  - {struct} - fold:
%    Transformation of the fold (see mvpalab_preparetrain).
%
%%  OUTPUT:
%
%  - {matrix} - X:
%    Transformed test set [trials x features].

X = (X - fold.norm.u)./fold.norm.v;

if ~isempty(fold.pca), X = mvpalab_project(X,fold.pca); end

end
