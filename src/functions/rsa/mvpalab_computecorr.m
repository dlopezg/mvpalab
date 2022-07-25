function corrseries = mvpalab_computecorr(cfg,mtx,mtx_,permute)
%% MVPALAB_COMPUTECORR
%
% This function computes the second order representational similarity
% analysis between two RDMs in a time-resolverd way. If different
% theoretical models are defined this functions compute the correlation
% series for each one.


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
%    theoretical model and timepoint: [timepoint x vectorized]
%
%  - {flag} permute
%    Description: This flag indicates if the data should be permuted.
%
%%  OUTPUT:
%
%  - {4D-matrix} corrseries
%    Description: Time series including correlation values for each
%    timepoint and model. For data structure consistency:
%    [1 x timepoints x 1 x permutetions]

if permute
    fprintf('\n        - Computing permuted maps:');
else
    fprintf('\n        - Computing second order RSA:');
end

%% Permute or not.
%  Calculate the number of permutations

if permute, nperm = cfg.stats.nper; else, nperm = 1; end

%% Model loop:
%  Description:
if permute,fprintf('- Permutation: '); end

%% Permutation loop:
%  Description:
for perm = 1 : nperm
    %% Compute correlation:
    %  The Spearman correlation is computed for each timepoint and the
    %  time series is stored in r.
    
    r = [];
    
    if cfg.classmodel.parcomp
        
        parfor tp = 1 : size(mtx,1)
            
            trdm = mtx_(tp,:);
            rdm = mtx(tp,:);
            if permute, rdm = rdm(randperm(length(rdm))); end
            r(tp) = corr(rdm',trdm','Type','Spearman');
            
        end
        
    else
        
        for tp = 1 : size(mtx,1)
            
            trdm = mtx_(tp,:);
            rdm = mtx(tp,:);
            if permute, rdm = rdm(randperm(length(rdm))); end
            r(tp) = corr(rdm',trdm','Type','Spearman');
            
        end
        
    end
    
    %% Search and correct extreme correlations:
    %  Force finite values for later z-transformation: +1/-1
    %  correlation values should be corrected to +/-.999999 to avoid
    %  infinity for z-transformed correlations.
    %  EPS corrects for rounding errors in r. EPS returns the distance
    %  from 1.0 to the next larger double-precision number.
    
    r_ = (abs(r) + eps) >= 1;
    
    if any(r_(:))
        warning(...
            'Correlations of +1 or -1 found. Correcting to +/-0.9999');
        r(r_) = 0.99999*r(r_);
    end
    
    %% Fisher transformation:
    %  Translate to Fisher's z transformed values. When this
    %  transformation is applied the sampling distribution of the
    %  resulting variable is approximately normal, with a variance
    %  that is stable over different values of the underlying true
    %  correlation.
    
    corrseries(1,:,1,perm) = atanh(r);
    
    if permute, mvpalab_pcounter(perm,nperm); end
    
end

fprintf(' - Done.\n');

end