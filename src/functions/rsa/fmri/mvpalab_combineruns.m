function data_ = mvpalab_combineruns(cfg,data)
%MVPALAB_COMBINERUNS Summary of this function goes here
%   Detailed explanation goes here

idx = 1;
for i = 1 : size(data,1)
    for j = 1 : size(data,2)
        data_(idx,:) = data{i,j};
        idx = idx + 1;
    end
end

end

