function [X,Y] = mvpalab_datalabels(fv)
%% MVPALAB_DATALABELS
%
%  This function concatenates the classes of each dataset in one data
%  matrix and returns the label of each observation: the index of its
%  class, as a categorical array. The first row of fv is dataset A and the
%  second one, in MVCC, dataset B.
%
%%  INPUT:
%
%  - {cell array} - fv:
%    Data of each class {datasets x classes}, matrices
%    [observations x channels x timepoints].
%
%%  OUTPUT:
%
%  - {struct} - X:
%    Data matrix of each dataset (fields a and, in MVCC, b),
%    [observations x channels x timepoints].
%
%  - {struct} - Y:
%    Labels of each dataset (fields a and, in MVCC, b), categorical
%    [observations x 1].

sets = {'a','b'};

for ctxt = 1 : size(fv,1)
    nobs = cellfun(@(class) size(class,1),fv(ctxt,:));
    X.(sets{ctxt}) = cat(1,fv{ctxt,:});
    Y.(sets{ctxt}) = categorical(repelem(1:size(fv,2),nobs)');
end

end
