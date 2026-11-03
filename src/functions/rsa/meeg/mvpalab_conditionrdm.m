function rdm = mvpalab_conditionrdm(cfg,rdm,bounds)
%% MVPALAB_CONDITIONRDM
%
%  This function transforms a temporal series of trial-wise RDMs into
%  condition-wise RDMs. Each cell of the condition-wise RDM is the mean
%  dissimilarity between all the trials of the two conditions.
%
%%  INPUT:
%
%  - {struct} cfg
%    Description: Configuration structure.
%
%  - {3D-matrix} rdm
%    Description: Trial-wise Representational Dissimilarity Matrices for
%    each timepoint. - [trials x trials x timepoints]
%
%  - {struct} bounds
%    Description: Condition boundaries returned by mvpalab_findbound. The
%    field bounds.last contains the index of the last trial of each
%    condition in the data matrix.
%
%%  OUTPUT:
%
%  - {3D-matrix} rdm
%    Description: Condition-wise RDMs for each timepoint if
%    cfg.rsa.trialwise is false - [conditions x conditions x timepoints].
%    Otherwise the input trial-wise RDMs are returned unchanged.
%

%% Combine trials into conditions:
%  Trials of condition j are last(j)+1 : last(j+1). The leading zero
%  ensures that the first trial is included in the first condition and that
%  boundary trials are not shared between consecutive conditions.

last = [0 bounds.last];

if ~cfg.rsa.trialwise
    for j = 1 : length(last)-1
        for k = 1 : length(last)-1
            crdm(j,k,:)=mean(mean(...
                rdm(last(j)+1:last(j+1),last(k)+1:last(k+1),:)));
        end
    end
    rdm = crdm;
end

end
