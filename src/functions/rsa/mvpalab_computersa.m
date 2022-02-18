function corrseries = mvpalab_computersa(mtx,mtx_)
%% MVPALAB_COMPUTERSA
%
% This function computes the second order representational similarity
% analysis between two RDMs in a time-resolverd way. If different
% theoretical models are defined this functions compute the correlation
% series for each one.

%  INPUT:
%
%  - mtx  : (2D - MATRIX) Data matrix including the empirical vectoriced 
%           RDMs for each timepoint: [timepoint x vectorized]
%
%  - mtx_ : (3D - MATRIX) Data matrix including the vectorized RDMs for 
%           each theoretical model and timepoint: 
%           [timepoint x vectorized x model]
%
%  OUTPUT:
%
%  - corrseries : (4D-MATRIX) - Time series including correlation values
%           for each timepoint and model. For data structure consistency:
%           [1 x timepoints x 1 x model]


for mdl = 1 : size(mtx_,3)
    
    %% Compute correlation:
    %  The Spearman correlation is computed for each timepoint and the
    %  time series is stored in r.
    
    r = [];
    
    parfor tp = 1 : size(mtx,1)
        
        trdm = mtx_(tp,:,mdl);
        rdm = mtx(tp,:);
        r(tp) = corr(rdm',trdm','Type','Spearman');
        
    end
    
    %% Search and correct extreme correlations:
    %  Force finite values for later z-transformation: +1/-1 correlation
    %  values should be corrected to +/-.999999 to avoid infinity for 
    %  z-transformed correlations.
    %  EPS corrects for rounding errors in r. EPS returns the distance from 
    %  1.0 to the next larger double-precision number.
    
    r_ = (abs(r) + eps) >= 1; 
    
    if any(r_(:))
        
        warning('Correlations of +1 or -1 found. Correcting to +/-0.9999');
        r(r_) = 0.99999*r(r_);
        
    end
    
    %% Fisher transformation:
    %  Translate to Fisher's z transformed values. When this
    %  transformation is applied the sampling distribution of the
    %  resulting variable is approximately normal, with a variance
    %  that is stable over different values of the underlying true
    % correlation.
    
    corrseries(1,:,1,mdl) = atanh(r);
    
end

end