function [masked_data] = mvpalab_maskbetas(mask,betas)
%% MVPALAB_MASKBETAS
%
%   Detailed explanation goes here

%%

for i = 1 : size(betas,1)
    for j = 1 : size(betas,2)
        masked_data{i,j} = betas{i,j}.data(mask.idxs);
    end
end

end

