function result = mvpalab_rdm_roi(cfg,sub_data,roi)

if 1
    
    idx = 1;
    for i = 1 : size(sub_data,1)
        for j = 1 : size(sub_data,2)
            selection = sub_data{i,j}.data(roi.idxs);
            data_to_coor(idx,:) = zscore(selection(~isnan(selection)));
            idx = idx + 1;
        end
    end
    
    if strcmp(cfg.rsa.distance,'euclidean')
        rdm = pdist2(data_to_coor,data_to_coor,'euclidean');
    elseif strcmp(cfg.rsa.distance,'pearson')
        rdm = 1 - corrcoef(data_to_coor');
    end
    
    %% Truco para igualar las matrices:
    
    offset = size(sub_data,2);
    offset_ = offset - 1; 
    xidx = 1;
    for i = 1 : offset : size(rdm,1)-offset_
        yidx = 1;
        for j = 1 : offset : size(rdm,1)-offset_
            if i == j
                result(xidx,yidx) = 0;
            else
                result(xidx,yidx) = mean(mean(rdm(i:i+offset_,j:j+offset_)));
            end
            yidx = yidx + 1;
        end
        xidx = xidx + 1;
    end
    
else
    
    for i = 1 : size(sub_data,1)
        for j = 1 : size(sub_data,2)
            selection = sub_data{i,j}.data(roi.idxs);
            data_run(j,:) = selection(~isnan(selection));
        end
        data_to_coor(i,:) = mean(data_run);
    end
    
    
    
    if strcmp(cfg.rsa.distance,'euclidean')
        result = pdist2(data_to_coor,data_to_coor,'euclidean');
    elseif strcmp(cfg.rsa.distance,'pearson')
        result = 1 - corrcoef(data_to_coor');
    end
    
    clear data_run data_to_coor;
    
end

end
