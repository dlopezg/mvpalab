function [b,t] = mvpalab_glm(vrdm,vmodels,pidx,nworkers)
%% MVPALAB_GLM
%
%  This function fits a general linear model at each timepoint, with the
%  empirical RDM as the dependent variable and the theoretical RDMs as
%  regressors (fitlm, with an intercept), for each row of pidx: the
%  identity for the observed map and one permutation of the conditions for
%  each permuted map (see mvpalab_rsapermidx). The empirical RDM is the
%  one permuted and the regressors stay fixed.
%
%%  INPUT:
%
%  - {matrix} - vrdm:
%    Vectorized empirical RDM [timepoints x pairs].
%
%  - {matrix} - vmodels:
%    Vectorized theoretical RDMs, the regressors [pairs x models].
%
%  - {matrix} - pidx:
%    Order of the pairs of each map [maps x pairs].
%
%  - {int} - nworkers:
%    Maximum number of workers of the parfor over timepoints: 0 runs it
%    in the client.
%
%%  OUTPUT:
%
%  - {matrix} - b:
%    Coefficient of each regressor [timepoints x maps x models].
%
%  - {matrix} - t:
%    t-value of each coefficient [timepoints x maps x models].

ntp = size(vrdm,1);
nmodels = size(vmodels,2);
b = zeros(ntp,size(pidx,1),nmodels);
t = b;

for map = 1 : size(pidx,1)
    idx = pidx(map,:);
    bmap = zeros(nmodels,ntp);
    tmap = bmap;
    parfor (tp = 1 : ntp, nworkers)
        mdl = fitlm(vmodels,vrdm(tp,idx)');
        bmap(:,tp) = mdl.Coefficients.Estimate(2:end);
        tmap(:,tp) = mdl.Coefficients.tStat(2:end);
    end
    b(:,map,:) = permute(bmap,[2 3 1]);
    t(:,map,:) = permute(tmap,[2 3 1]);
end

end
