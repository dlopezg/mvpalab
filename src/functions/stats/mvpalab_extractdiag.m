function [cr,permaps_] = mvpalab_extractdiag(tempgen,permaps)
%EXTRACT_CRATE Summary of this function goes here
%   Detailed explanation goes here

for i = 1 : size(tempgen,3)
    cr(1,:,i) = diag(tempgen(:,:,i));
end

for i = 1 : size(permaps,4)
    for j = 1 : size(permaps,3)
        permaps_(1,:,j,i) = diag(permaps(:,:,j,i));
    end
end

end

