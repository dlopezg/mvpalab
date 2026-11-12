function [mdl,w] = mvpalab_train(cfg,train_X,train_Y)
%% MVPALAB_TRAIN
%
%  This function trains the classifier selected in cfg.classmodel.method
%  and returns its feature weights:
%
%  - 'svm': support vector machine (fitcsvm) with the kernel in
%    cfg.classmodel.kernel. With the 'rbf' or 'gaussian' kernel, unless
%    the hyperparameter search covers the kernel scale, the kernel scale
%    is sqrt(features * var(train_X(:))), the same as gamma = 'scale' in
%    scikit-learn. With more than two classes, one binary SVM per pair of
%    classes is combined by fitcecoc.
%  - 'da': discriminant analysis (fitcdiscr) with the discriminant type in
%    cfg.classmodel.kernel.
%
%  Any other method gives an error. If cfg.classmodel.optimize.flag is
%  enabled, the hyperparameters in cfg.classmodel.optimize.params are
%  optimized with the options in cfg.classmodel.optimize.opt. The feature
%  weights are only defined for the linear SVM of two classes and the
%  discriminant type 'linear'; otherwise they are NaN. With more than two
%  classes, the weights of the linear discriminant are those between the
%  first two classes (mdl.Coeffs(2,1)), and the analysis does not use them
%  (see mvpalab_validateclasses).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.classmodel).
%
%  - {matrix} - train_X:
%    Training data [trials x features].
%
%  - {matrix} - train_Y:
%    Categorical labels of the training trials [trials x 1].
%
%%  OUTPUT:
%
%  - {object} - mdl:
%    Trained model, returned by fitcsvm, fitcecoc or fitcdiscr.
%
%  - {matrix} - w:
%    Feature weights [features x 1], NaN when they are not defined.

% Hyperparameter search if needed:
optimize = {};
if cfg.classmodel.optimize.flag
    optimize = {'OptimizeHyperparameters',cfg.classmodel.optimize.params,...
        'HyperparameterOptimizationOptions',cfg.classmodel.optimize.opt};
end

if strcmp(cfg.classmodel.method,'svm')
    kernel = {'KernelFunction',cfg.classmodel.kernel};
    % The search covers the kernel scale with 'KernelScale', 'auto' or
    % 'all', given by name or as an optimizableVariable named KernelScale:
    params = cfg.classmodel.optimize.params;
    if isa(params,'optimizableVariable')
        names = {params.Name};
    else
        names = cellstr(params);
    end
    searched = cfg.classmodel.optimize.flag && ...
        any(ismember(names,{'KernelScale','auto','all'}));
    if ~searched && any(strcmp(cfg.classmodel.kernel,{'rbf','gaussian'}))
        % Same kernel scale as gamma = 'scale' in scikit-learn. It depends
        % on the number of features, unlike the default value of fitcsvm:
        scale = sqrt(size(train_X,2)*var(train_X(:)));
        kernel = [kernel {'KernelScale',scale}];
    end
    
    if numel(unique(train_Y)) > 2
        % One binary SVM per pair of classes, combined by fitcecoc. There
        % are no feature weights (see mvpalab_validateclasses):
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
    mdl = fitcdiscr(train_X,train_Y,'DiscrimType',cfg.classmodel.kernel,...
        optimize{:});
    
    % Linear coefficients, with the same sign as mdl.Beta in the SVM.
    % Feature weights are only defined for the linear discriminant:
    if strcmp(cfg.classmodel.kernel,'linear')
        w = mdl.Coeffs(2,1).Linear;
    else
        w = NaN(size(train_X,2),1);
    end
    
else
    error('mvpalab:train',...
        'Unknown classifier: cfg.classmodel.method must be ''svm'' or ''da''.');
end

