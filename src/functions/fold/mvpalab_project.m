function X = mvpalab_project(X,pca)
%% MVPALAB_PROJECT
%
%  This function projects a test set on the principal components of the
%  training set of a fold (see mvpalab_preparetrain): the data is centered
%  with the mean of the training set, solved for the coefficients,
%  X / coeff', as the reconstruction rule X = scores * coeff', and the
%  first ncomp components are kept.
%
%%  INPUT:
%
%  - {matrix} - X:
%    Test set [trials x features].
%
%  - {struct} - pca:
%    Principal components of the fold: mean (mu), coefficients (coeff) and
%    number of components (ncomp).
%
%%  OUTPUT:
%
%  - {matrix} - X:
%    Projected test set [trials x ncomp].

scores = (X - pca.mu)/pca.coeff';
X = scores(:,1:pca.ncomp);

end
