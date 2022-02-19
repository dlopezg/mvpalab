function [X,Y,cfg] = mvpalab_datalabels(cfg,fv)
%% MVPALAB_DATALABELS 
%
%  This function generates and returns the label vector and the data matrix 
%  by concatenating data from all the classes included in the feature 
%  vector (fv).
%  
%  INPUT:
%
%  - cfg: (STRUCT) Configuration estructure. 
%
%  - fv : (CELL ARRAY) Feature vector array. Each position contains the 
%         data matrix of a single class. [trials x electrodes x timepoint]
%         The second row of this cell array is reserver for
%         cross-classification analysis.
%
%  OUTPUT:
%
%  - X  : (STRUCT) Data matrix for an individual subject containing 
%         observations all the classes. Data for decoding analyses or RSA  
%         is stored in X.a while data for cross-classification analyses is 
%         stored in X.b.
%
%  - Y  : (ARRAY OF LOGICALS) Label vector for an individual subject.
%
%  - cfg: (STRUCT) Label vector for an individual subject.

%%  Initialization:
X.a = []; Y.a = logical([]); nctxt = 1;

%%  Check MVPA or MVCC:
%   Data fields X.b and Y.b are reserved for cross-classification purposes.
%   Only if the size of the feature vector matrix is larger than two and
%   these cells are not empty we initialize X.b and Y.b fields and set the
%   number of context to two.

if (size(fv,1) > 1) && ~sum(cellfun(@isempty,fv{2,:}))
    nctxt = 2;
    X.b = []; Y.b = logical([]);
end

%% Generate data structure and labels:
%  For each context and class the label vector Y is generated. If the 
%  number of the class is even/odd the associated level will be true/false.
%  The data matrix is also generated concatenating data from different
%  conditions.

for ctxt = 1 : nctxt
    for class = 1 : size(fv,2)
        if mod(class,2) == 1
            labels = false(size(fv{ctxt,class},1),1);
        else
            labels = true(size(fv{ctxt,class},1),1);
        end
        if ctxt < 2
            X.a = [X.a; fv{ctxt,class}];
            Y.a = [Y.a; labels];
        else
            X.b = [X.b; fv{ctxt,class}];
            Y.b = [Y.b; labels];
        end
    end
end
