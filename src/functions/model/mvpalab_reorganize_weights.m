function wvector = mvpalab_reorganize_weights(w)
    for tp = 1 : size(w,2)
        for sub = 1 : size(w,3)
            for freq = 1 : size(w,4)
                wvector.raw{sub,freq}(:,tp) = w{1,tp,sub,freq}.raw;
                wvector.haufe_corrected{sub,freq}(:,tp) = ...
                    w{1,tp,sub,freq}.haufe_corrected;
            end
        end
    end
end

