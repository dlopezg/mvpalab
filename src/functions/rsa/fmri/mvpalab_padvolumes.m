function padded_volumes = mvpalab_padvolumes(cfg,volumes)
%% MVPALAB_PADVOLUMES
%
%  This function adds cfg.sl.radius NaN voxels at both sides of each
%  dimension of one volume or of each volume of a cell array (see
%  mvpalab_padmatrix).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.sl.radius).
%
%  - {struct} or {cell array} - volumes:
%    One volume (see mvpalab_load_volumes), or a cell array of volumes
%    [conditions x runs] (see mvpalab_load_betas).
%
%%  OUTPUT:
%
%  - {struct} or {cell array} - padded_volumes:
%    Padded volume, or cell array of padded volumes of the same size as
%    the input (see mvpalab_padmatrix).

if isstruct(volumes)
    padded_volumes = mvpalab_padmatrix(cfg.sl.radius,volumes);
else
    for i = 1 : size(volumes,1)
        for j = 1 : size(volumes,2)
            volume = volumes{i,j};
            padded_volumes{i,j} = mvpalab_padmatrix(cfg.sl.radius,volume);
        end
    end
end

end

