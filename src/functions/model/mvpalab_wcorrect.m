function [wcorrected] = mvpalab_wcorrect(train_X,w)
%% MVPALAB_WCORRECT
%
%  This function corrects the feature weights of a linear model with the
%  method proposed in:
%
%  S. Haufe et al., "On the interpretation of weight vectors of linear
%  models in multivariate neuroimaging," Neuroimage, vol. 87, pp. 96-110,
%  2014.
%
%  The corrected weights are the covariance matrix of the training data
%  multiplied by the weights, cov(train_X) * w.
%
%%  INPUT:
%
%  - {matrix} - train_X:
%    Training data [trials x features].
%
%  - {matrix} - w:
%    Feature weights [features x 1] (see mvpalab_train).
%
%%  OUTPUT:
%
%  - {matrix} - wcorrected:
%    Corrected feature weights [features x 1].

train_X = (train_X - mean(train_X,1)) ./ sqrt(size(train_X,1)-1);
wcorrected = train_X' * (train_X * w);
end


