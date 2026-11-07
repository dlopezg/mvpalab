function mean_rdm = mvpalab_meanrdm(rdms)
%% MVPALAB_MEANRDM
%
%  This function returns the mean RDM of a group of subjects.
%
%%  INPUT:
%
%  - {cell array} - rdms:
%    RDM of each subject [conditions x conditions x timepoints], in a cell
%    array of any shape. All the RDMs must have the same size.
%
%%  OUTPUT:
%
%  - {matrix} - mean_rdm:
%    Mean RDM [conditions x conditions x timepoints].

mean_rdm = mean(cat(4,rdms{:}),4);

end
