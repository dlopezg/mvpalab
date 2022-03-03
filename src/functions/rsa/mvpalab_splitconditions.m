function [X_,Y_,idx] = mvpalab_splitconditions(X,bounds)
%% MVPALAB_SPLITCONDITIONS
%
%  This function splits and rearrange the imput dataset for cross-validated
%  distance measures such as the cross-validated Mahalanobis distance.
%
%  INPUT:
%
%  - X  : (STRUCT) Data matrix for an individual subject containing the
%         observations of all the classes. [trials x chanels x timepoints]
%
%  - bounds : (STRUCT) - (ARRAY OF INTEGERS) This vector contains the
%             indexes of the last and the middle trial of each condition in
%             the data matrix.
%
%  OUTPUT:
%
%  - X_ : (STRUCT) Splitted data matrix.
%
%  - Y_ : (ARRAY OF LOGICALS) Splitted label vector.
%
%  - idx: (INTEGER) Central trial index.

%% Initialize:

idxs  = [1 bounds.last];
idxs_ = bounds.middle;

trialset  = [];
trialset_ = [];

labelset  = [];
labelset_ = [];

%% Spliter and rearrange loop:

for i = 1 : length(idxs_)
    
    set = X(idxs(i)+1:idxs_(i),:,:);
    set_ =  X(idxs_(i)+1:idxs(i+1),:,:);
    
    trialset  = [trialset; set];
    trialset_ = [trialset_; set_];
    
    labelset  = [labelset; ones(size(set,1),1)*i];
    labelset_ = [labelset_; ones(size(set_,1),1)*i];
    
end

X_ = [trialset; trialset_];
Y_ = [labelset; labelset_];

idx = size(trialset,1);


end

