function [X,Y,cfg] = mvpalab_datalabels(cfg,fv)
%MVPALAB_DATALABELS Summary of this function goes here
%   Detailed explanation goes here

[nctxt,nclass] = size(fv);
X.a = []; Y.a = [];
if nctxt > 1; X.b = []; Y.b = []; end

% MVPA or MVCC:
for ctxt = 1 : nctxt
    for class = 1 : nclass
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
