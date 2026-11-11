function mvpalab_validateweights(cfg)
%% MVPALAB_VALIDATEWEIGHTS
%
%  This function warns the user at the beginning of the analysis if the
%  feature weights are requested with a non-linear model. Each feature has
%  a weight only in the linear models, so with the other kernels the
%  analysis runs normally but the feature weights are NaN (mvpalab_train).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.classmodel).

if cfg.classmodel.wvector && ~strcmp(cfg.classmodel.kernel,'linear')
    warning(['Feature weights are only available for linear models. ' ...
        'With the ''%s'' kernel they will be NaN.'],cfg.classmodel.kernel);
end

end
