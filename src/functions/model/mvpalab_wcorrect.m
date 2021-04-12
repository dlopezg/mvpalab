function [wcorrected] = mvpalab_wcorrect(train_X,w)
% Weight correction proposed by Haufe in:
%﻿S. Haufe et al., “On the interpretation of weight vectors of linear model 
% in multivariate neuroimaging,” Neuroimage, vol. 87, pp. 96–110, 2014.
train_X = (train_X - repmat(mean(train_X), size(train_X,1),1)) ./ sqrt(size(train_X,1)-1);
wcorrected = train_X' * (train_X * w);
end


