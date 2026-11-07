function [ mdl , w ] = mvpalab_train(train_X,train_Y,cfg)
%% MVPALAB_TRAIN
%
%  This function trains the classifier selected in cfg.classmodel.method
%  and returns its feature weights:
%
%  - 'svm': support vector machine (fitcsvm) with the kernel in
%    cfg.classmodel.kernel. With the 'rbf' or 'gaussian' kernel and
%    without hyperparameter optimization, the kernel scale is
%    sqrt(features * var(train_X(:))), the same as gamma = 'scale' in
%    scikit-learn. With more than two classes, one binary SVM per pair of
%    classes is combined by fitcecoc.
%  - 'da': discriminant analysis (fitcdiscr) with the discriminant type in
%    cfg.classmodel.kernel.
%
%  Any other method gives an error. If cfg.classmodel.optimize.flag is
%  enabled, the hyperparameters in cfg.classmodel.optimize.params are
%  optimized with the options in cfg.classmodel.optimize.opt. The feature
%  weights are only defined for the linear SVM of two classes and the
%  discriminant type 'linear'; otherwise they are NaN.
%
%%  INPUT:
%
%  - {matrix} - train_X:
%    Training data [trials x features].
%
%  - {matrix} - train_Y:
%    Categorical labels of the training trials [trials x 1].
%
%  - {struct} - cfg:
%    Configuration structure (cfg.classmodel).
%
%%  OUTPUT:
%
%  - {object} - mdl:
%    Trained model, returned by fitcsvm, fitcecoc or fitcdiscr.
%
%  - {matrix} - w:
%    Feature weights [features x 1], NaN when they are not defined.

if strcmp(cfg.classmodel.method,'svm')
    kernel = {'KernelFunction',cfg.classmodel.kernel};
    optimize = {};
    if cfg.classmodel.optimize.flag
        optimize = {'OptimizeHyperparameters',cfg.classmodel.optimize.params,...
            'HyperparameterOptimizationOptions',cfg.classmodel.optimize.opt};
    elseif any(strcmp(cfg.classmodel.kernel,{'rbf','gaussian'}))
        % Same kernel scale as gamma = 'scale' in scikit-learn. It depends
        % on the number of features, unlike the default value of fitcsvm:
        scale = sqrt(size(train_X,2)*var(train_X(:)));
        kernel = [kernel {'KernelScale',scale}];
    end
    
    if numel(unique(train_Y)) > 2
        % One binary SVM per pair of classes, combined by fitcecoc. There
        % are no feature weights (see mvpalab_checkclasses):
        mdl = fitcecoc(train_X,train_Y,'Learners',templateSVM(kernel{:}),...
            'Coding','onevsone',optimize{:});
        w = NaN(size(train_X,2),1);
    else
        mdl = fitcsvm(train_X,train_Y,kernel{:},optimize{:});
        
        % Feature weights are only defined for the linear kernel:
        w = mdl.Beta; 
        if isempty(w), w = NaN(size(train_X,2),1); end
    end
    
elseif strcmp(cfg.classmodel.method,'da')
    if cfg.classmodel.optimize.flag
        mdl = fitcdiscr(train_X,train_Y,...
            'DiscrimType',cfg.classmodel.kernel,...
            'OptimizeHyperparameters',cfg.classmodel.optimize.params,...
            'HyperparameterOptimizationOptions',cfg.classmodel.optimize.opt);
    else
        mdl = fitcdiscr(train_X,train_Y,...
            'DiscrimType',cfg.classmodel.kernel);
    end
    
    % Linear coefficients, with the same sign as mdl.Beta in the SVM.
    % Feature weights are only defined for the linear discriminant:
    if strcmp(cfg.classmodel.kernel,'linear')
        w = mdl.Coeffs(2,1).Linear;
    else
        w = NaN(size(train_X,2),1);
    end
    
else
    error('Unknown classifier: cfg.classmodel.method must be ''svm'' or ''da''.');
end

