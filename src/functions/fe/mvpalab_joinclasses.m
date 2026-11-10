function dataset = mvpalab_joinclasses(fv,classes)
%% MVPALAB_JOINCLASSES
%
%  This function concatenates the classes of one dataset in one data
%  matrix, class by class, and labels each observation with the name of
%  its class (see mvpalab_splitclasses).
%
%%  INPUT:
%
%  - {cell array} - fv:
%    Data of each class {1 x classes}, matrices
%    [observations x channels x timepoints].
%
%  - {cell array} - classes:
%    Name of each class, in the same order.
%
%%  OUTPUT:
%
%  - {struct} - dataset:
%    Data matrix (X) [observations x channels x timepoints] and
%    categorical labels (Y) [observations x 1], with the classes as
%    categories in the same order.

nobs = cellfun(@(x) size(x,1),fv);

dataset.X = cat(1,fv{:});
dataset.Y = categorical(repelem(classes(:),nobs(:)),classes);

end
