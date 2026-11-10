function [fv,classes] = mvpalab_splitclasses(dataset)
%% MVPALAB_SPLITCLASSES
%
%  This function separates the observations of each class of one dataset,
%  in the order of the categories of its labels.
%
%%  INPUT:
%
%  - {struct} - dataset:
%    Data matrix (X) [observations x channels x timepoints] and
%    categorical labels (Y) of the dataset.
%
%%  OUTPUT:
%
%  - {cell array} - fv:
%    Data of each class {1 x classes}, matrices
%    [observations x channels x timepoints].
%
%  - {cell array} - classes:
%    Name of each class, the categories of the labels.

classes = categories(dataset.Y);

fv = cell(1,numel(classes));
for condition = 1 : numel(classes)
    fv{condition} = dataset.X(dataset.Y == classes{condition},:,:);
end

end
