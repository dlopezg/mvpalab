function [ mdl , w ] = mvpalab_train(train_X,train_Y,cfg)
%MVPALAB_TRAINCLASS Summary of this function goes here
%   Detailed explanation goes here

if strcmp(cfg.classmodel.method,'svm')
    if cfg.classmodel.optimize.flag
        mdl = fitcsvm(train_X,train_Y,...
            'KernelFunction',cfg.classmodel.kernel,...
            'OptimizeHyperparameters',cfg.classmodel.optimize.params,...
            'HyperparameterOptimizationOptions',cfg.classmodel.optimize.opt);
    else
        mdl = fitcsvm(train_X,train_Y,...
            'KernelFunction',cfg.classmodel.kernel);
    end
    
    w = mdl.Beta; 
    
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
    
    w = mdl.DeltaPredictor'; 
    
else
    mdl = fitcsvm(train_X,train_Y);
    w = mdl.Beta; 
end

