function rdm_ = mvpalab_mergerunsrdm(cfg,data,rdm)
%MVPALAB_MERGERUNS Summary of this function goes here
%   Detailed explanation goes here

offset = size(data,2);
offset_ = offset - 1;
xidx = 1;

if offset > 1
    for i = 1 : offset : size(rdm,1)-offset_
        yidx = 1;
        for j = 1 : offset : size(rdm,1)-offset_
            if i == j
                rdm_(xidx,yidx) = 0;
            else
                rdm_(xidx,yidx) = mean(mean(rdm(i:i+offset_,j:j+offset_)));
            end
            yidx = yidx + 1;
        end
        xidx = xidx + 1;
    end
else
    rdm_ = rdm;
end

