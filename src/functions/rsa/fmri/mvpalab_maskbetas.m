function [masked_data] = mvpalab_maskbetas(mask,betas)
%% MVPALAB_MASKBETAS
%
%  This function selects the voxels of each beta inside a mask. The voxels
%  with NaN values are removed.
%
%%  INPUT:
%
%  - {struct} - mask:
%    Mask or region of interest, with the indexes of its voxels in idxs
%    (see mvpalab_load_volumes).
%
%  - {cell array} - betas:
%    Beta images [conditions x runs] (see mvpalab_load_betas).
%
%%  OUTPUT:
%
%  - {cell array} - masked_data:
%    Masked betas [conditions x runs], each one a vector with the value of
%    each selected voxel.

%%

for i = 1 : size(betas,1)
    for j = 1 : size(betas,2)
        selection = betas{i,j}.data(mask.idxs);
        masked_data{i,j} = selection(~isnan(selection));
    end
end

end

