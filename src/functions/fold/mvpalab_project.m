function X = mvpalab_project(X,pca)
%% MVPALAB_PROJECT
%
%  This function projects a test set on the principal components of the
%  training set of a fold (see mvpalab_preparetrain): the data is centered
%  with the mean of the training set and multiplied by the coefficients of
%  the first ncomp components. The coefficients are orthonormal, so this
%  is the inverse of the reconstruction rule X = scores * coeff'.
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

X = (X - pca.mu)*pca.coeff(:,1:pca.ncomp);

end
