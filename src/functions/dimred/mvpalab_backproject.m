function weights = mvpalab_backproject(weights,params,cfg)
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
%
%%  INPUT:
%
%  - {1D-array} - weights:
%    Feature weights. [features x 1]
%
%  - {struct} - params:
%    PCA parameters of this fold (mvpalab_dimred).
%
%  - {struct} - cfg:
%    Configuration structure (cfg.dimred).
%
%%  OUTPUT:
%
%  - {1D-array} - weights:
%    Feature weights in the channel space. [channels x 1]

if ~strcmp(cfg.dimred.method,'none')
    weights = params.coeff(:,1:cfg.dimred.ncomp) * weights;
end

end
