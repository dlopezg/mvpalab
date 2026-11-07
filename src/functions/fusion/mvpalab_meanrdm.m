function [mean_rdm] = mvpalab_meanrdm(cellarray)
%% MVPALAB_MEANRDM
%
%  This function returns the mean RDM of a group of subjects.
%
%%  INPUT:
%
%  - {cell array} - cellarray:
%    RDM of each subject [conditions x conditions x timepoints], in a row
%    cell array [1 x subjects]. All the RDMs must have the same size.
%
%%  OUTPUT:
%
%  - {matrix} - mean_rdm:
%    Mean RDM [conditions x conditions x timepoints].

nsub = length(cellarray);
[ncond,~,ntp] = size(cellarray{1});

% Compute the mean RDM:
mean_rdm = squeeze(mean(reshape(cell2mat(cellarray),[ncond,ncond,nsub,ntp]),3));

end

