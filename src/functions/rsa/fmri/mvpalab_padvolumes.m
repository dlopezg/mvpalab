function padded_volumes = mvpalab_padvolumes(cfg,volumes)
%% MVPALAB_PADVOLUME
%   Detailed explanation goes here

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

