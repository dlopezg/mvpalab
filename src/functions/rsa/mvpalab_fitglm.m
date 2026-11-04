function [bvalues,tvalues] = mvpalab_fitglm(cfg,mtx,mtx_,permute)
%% MVPALAB_FITGLM
%
% This function returns the bata and t-values of a linear regression for
% each timepoint and model.

%%  INPUT:
%
%  - {struct} - cfg:
%    Description: Configuration structure.
%
%  - {2D-matrix} mtx
%    Description: Data matrix including the empirical vectoriced RDMs for
%    each timepoint: [timepoint x vectorized]
%
%  - {3D-matrix} mtx_
%    Description: Data matrix including the vectorized RDMs for each
%    theoretical model and timepoint: [timepoint x vectorized x model]
%
%  - {flag} permute
%    Description: This flag indicates if the data should be permuted. If
%    true, cfg.stats.nper permuted maps are computed permuting the
%    conditions of the empirical RDM (see mvpalab_permidx).
%
%%  OUTPUT:
%
%  - {5D-matrix} res.bvalues
%    Description: Time series including coefficients values (beta) for each
%    timepoint and model. For data structure consistency:
%       res.bvalues - [1 x timepoints x 1 x permutetions x model]
%
%  - {5D-matrix} res.tvalues
%    Description: Time series including t-values (statistics) for each
%    timepoint and model. For data structure consistency:
%       res.tvalues - [1 x timepoints x 1 x permutetions x model]

if permute
    fprintf('\n     <strong>- Computing permuted maps:</strong>\n');
else
    fprintf('\n     <strong>- Computing GLM analysis:</strong>\n');
end

%% Permute or not:
%  Calculate the number of permutations

if permute, nperm = cfg.stats.nper; else, nperm = 1; end
if permute,fprintf('        - Permutation: '); end

%% Permutation indexes:
%  The conditions of the empirical RDM (dependent variable) are permuted
%  (rows and columns together) and the same permutation is applied to all
%  the timepoints. The theoretical RDMs (regressors) remain fixed. Without
%  permutation the identity index is used.

if permute
    pidx = mvpalab_permidx(cfg,size(mtx,2),nperm);
else
    pidx = 1 : size(mtx,2);
end

%% Permutation loop:
%  Description:
for perm = 1 : nperm
    %% Fit GLM:
    % Description:
    idx = pidx(perm,:);
    if cfg.classmodel.parcomp
        
        parfor tp = 1 : size(mtx,1)
            
            trdm = squeeze(mtx_(tp,:,:));
            rdm = mtx(tp,idx);
            
            % Fit model and extract coefficients and t-values:
            mdl = fitlm(trdm,rdm);
            b(:,tp) = mdl.Coefficients.Estimate(2:end);
            t(:,tp) = mdl.Coefficients.tStat(2:end);
            
        end
        
    else
        
        for tp = 1 : size(mtx,1)
            
            trdm = squeeze(mtx_(tp,:,:));
            rdm = mtx(tp,idx);
            
            % Fit model and extract coefficients and t-values:
            mdl = fitlm(trdm,rdm);
            b(:,tp) = mdl.Coefficients.Estimate(2:end);
            t(:,tp) = mdl.Coefficients.tStat(2:end);
            
        end
        
    end
    
    tvalues(1,:,1,perm,:) = t';
    bvalues(1,:,1,perm,:) = b';
    
    if permute, mvpalab_pcounter(perm,nperm); end
    
end

fprintf('        - Done.\n');


end

