function [ correct_rate , cfg ] = mvcc_svm_classifier(Xa,Ya,Xb,Yb,tp,cfg,permute)
%MVCC_SVM_CLASSIFIER Summary of this function goes here
%   Detailed explanation goes here

%% Permute labels if needed:
if permute
    Ya = Ya(randperm(length(Ya)));
end

%% Train SVM model
Xatp = Xa(:,:,cfg.tpoints(tp));
Xbtp = Xb(:,:,cfg.tpoints(tp));
mdlSVM = compact(fitcsvm(Xatp,Ya));

%% Calculate acc:
if cfg.tempgen
    for tp2 = 1 : cfg.ntp
        Xbtp2 = Xb(:,:,cfg.tpoints(tp2));
        predicted_labels = predict(mdlSVM,Xbtp2);
        correct_rate(tp2) = sum(Yb == predicted_labels);
    end
else
    predicted_labels = predict(mdlSVM,Xbtp);
    correct_rate = sum(Yb == predicted_labels);
end

correct_rate = correct_rate/length(Yb);



end

