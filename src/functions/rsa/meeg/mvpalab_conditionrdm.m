function rdm = mvpalab_conditionrdm(cfg,rdm,bounds)
%MVPALAB_CONDITIONRDM Summary of this function goes here
%   Detailed explanation goes here

%% Combine trials into conditions

last = [1 bounds.last];

if ~cfg.rsa.trialwise
    for j = 1 : length(last)-1
        for k = 1 : length(last)-1
            crdm(j,k,:)=mean(mean(...
                rdm(last(j):last(j+1),last(k):last(k+1),:)));
        end
    end
    rdm = crdm;
end

