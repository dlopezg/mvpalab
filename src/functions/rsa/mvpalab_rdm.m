function [rdm, bounds] = mvpalab_rdm(cfg,X,Y)
%% MVPALAB_RDM
%
%  This function returns the Representational Dissimilarity Matrices for
%  in a time resolved way.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration estructure.
%
%  - {3D-matrix} X
%    Data matrix for an individual subject containing all thevtrials and 
%    conditions. [trials x chanels x timepoints]
%
%  - {array of logicals} Y
%    Description: This vector contains logical labels for an individual 
%    subject.
%
%%  OUTPUT:
%
%  - {3D-matrix} - rdm:
%    Representational Dissimilarity Matrices for each timepoint:
%    [trials x trials x timepoints]
%
%  - {struct.array} bounds
%    Description: This vector contains the indexes of the last and the 
%    middle trial of each condition in the data matrix.

fprintf('     <strong>- Computing empirical RDMs...</strong> ');

%% Preallocate the RDM matrices:
ntrial = size(X,1);
rdm = NaN(ntrial,ntrial,cfg.tm.ntp);

%% Construct RDMs using Pearson correlation:
if strcmp(cfg.rsa.method,'pearson')
    if cfg.classmodel.parcomp
        parfor tp = 1 : cfg.tm.ntp
            X_tp = X(:,:,tp);
            rdm(:,:,tp) = 1 - corrcoef(X_tp');
        end
    else
        for tp = 1 : cfg.tm.ntp
            X_tp = X(:,:,tp);
            rdm(:,:,tp) = 1 - corrcoef(X_tp');
        end
    end
end

%% Construct RDMs using the euclidean distance:
if strcmp(cfg.rsa.method,'euclidean')
    if cfg.classmodel.parcomp
        parfor tp = 1 : cfg.tm.ntp
            X_tp = X(:,:,tp);
            rdm(:,:,tp) = pdist2(X_tp,X_tp,'euclidean');
        end
    else
        for tp = 1 : cfg.tm.ntp
            X_tp = X(:,:,tp);
            rdm(:,:,tp) = pdist2(X_tp,X_tp,'euclidean');
        end
    end
end

%%  Find condition's boundaries for each subject:
%   This functions returns the indexes of the last trials for each
%   condition. This indexes can be used to plot conditions boundaries
%   or to split the data.

bounds = mvpalab_findbound(Y);
last = [1 bounds.last];

%% Combine trials into conditions

if ~cfg.rsa.trialwise
    for j = 1 : length(last)-1
        for k = 1 : length(last)-1
            crdm(j,k,:)=mean(mean(...
                rdm(last(j):last(j+1),last(k):last(k+1),:)));
        end
    end
    
    rdm = crdm;
    
end

fprintf('- Done.\n\n');

end

