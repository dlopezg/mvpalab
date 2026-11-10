function weights = mvpalab_backproject(weights,fold)
%% MVPALAB_BACKPROJECT
%
%  This function returns the feature weights of a model trained in the
%  principal component space to the original channel space.
%
%  The principal components are computed in the training set of each fold,
%  so they are different in each fold and the weights can only be averaged
%  across folds in the channel space, which is also the space needed to
%  plot them. If X = scores * coeff', the weights of the channels are
%  coeff * weights, and the same applies to the Haufe corrected patterns.
%  Without PCA the weights do not change.
%
%%  INPUT:
%
%  - {matrix} - weights:
%    Feature weights [features x 1].
%
%  - {struct} - fold:
%    Transformation of the fold (see mvpalab_preparetrain).
%
%%  OUTPUT:
%
%  - {matrix} - weights:
%    Feature weights in the channel space [channels x 1].

if ~isempty(fold.pca)
    weights = fold.pca.coeff(:,1:fold.pca.ncomp) * weights;
end

end
