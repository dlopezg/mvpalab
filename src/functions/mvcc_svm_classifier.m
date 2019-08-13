function [ correct_rate , cfg ] = mvcc_svm_classifier(Xa,Ya,Xb,Yb,tp,cfg,permute)
%MVCC_SVM_CLASSIFIER Summary of this function goes here
%   Detailed explanation goes here

%% Permute labels if needed:
if permute
    Ya = Ya(randperm(length(Ya)));
end

%% Train SVM model
mdlSVM = compact(fitcsvm(Xa(:,:,cfg.tpoints(tp)),Ya));

%% Calculate acc:
if cfg.tempgen
    for tp2 = 1 : cfg.ntp
        correct_rate(tp2) = sum(Yb == predict(mdlSVM,Xb(:,:,cfg.tpoints(tp))));
    end
else
    correct_rate = sum(Yb == predict(mdlSVM,Xb(:,:,cfg.tpoints(tp))));
end

correct_rate = correct_rate/length(Yb);



end

