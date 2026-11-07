function data_ = mvpalab_combineruns(cfg,data)
%% MVPALAB_COMBINERUNS
%
%  This function stacks the masked betas in one matrix, condition by
%  condition: all the runs of condition 1, then all the runs of condition
%  2...
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (not used).
%
%  - {cell array} - data:
%    Masked betas [conditions x runs], each one a vector with the value of
%    each voxel (see mvpalab_maskbetas).
%
%%  OUTPUT:
%
%  - {matrix} - data_:
%    Betas [betas x voxels], with betas = conditions x runs.

idx = 1;
for i = 1 : size(data,1)
    for j = 1 : size(data,2)
        data_(idx,:) = data{i,j};
        idx = idx + 1;
    end
end

end

