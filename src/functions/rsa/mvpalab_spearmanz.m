function z = mvpalab_spearmanz(vrdm,vmodel,pidx,nworkers)
%% MVPALAB_SPEARMANZ
%
%  This function computes the Spearman correlation between the empirical
%  RDM at each timepoint and one theoretical RDM, Fisher z-transformed,
%  for each row of pidx: the identity for the observed map and one
%  permutation of the conditions for each permuted map (see
%  mvpalab_rsapermidx). The empirical RDM is the one permuted.
%
%  Correlations of +1 or -1 are multiplied by 0.99999, with a warning, so
%  the Fisher transformation stays finite.
%
%%  INPUT:
%
%  - {matrix} - vrdm:
%    Vectorized empirical RDM [timepoints x pairs].
%
%  - {matrix} - vmodel:
%    Vectorized theoretical RDM [pairs x 1].
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
%  - {matrix} - z:
%    Fisher z-transformed correlations [timepoints x maps].

ntp = size(vrdm,1);
z = zeros(ntp,size(pidx,1));

for map = 1 : size(pidx,1)
    idx = pidx(map,:);
    r = zeros(1,ntp);
    parfor (tp = 1 : ntp, nworkers)
        r(tp) = corr(vrdm(tp,idx)',vmodel,'Type','Spearman');
    end

    % EPS corrects for rounding errors in r:
    extreme = (abs(r) + eps) >= 1;
    if any(extreme)
        warning('Correlations of +1 or -1 found. Correcting to +/-0.99999');
        r(extreme) = 0.99999*r(extreme);
    end

    z(:,map) = atanh(r)';
end

end
