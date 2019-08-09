function [ correct_rate, cfg] = svm_classifier( X, Y, cfg )
%SVM_CLASSIFIER This function returns the accuracy of the classifier in a
%time-resolved way.

strpar = cvpartition(Y,'KFold',cfg.cv.nfolds);

%% Timepoints loop:
fprintf('       - Timepoints: ');
n = numel(num2str(cfg.ntp)) + 1;

%% Classperf initialization:
if isfield(cfg,'tempgen')
    tempgen = cfg.tempgen;
    if cfg.tempgen
        for i = 1 : cfg.ntp
            for j = 1 : cfg.ntp
                cpmtx{i,j} = classperf(Y);
            end
        end
    end
end


%% Timepoints loop
for tp = 1 : cfg.ntp
    cp{tp} = classperf(Y);
    %% Cross-validation loop:
    for k = 1 : strpar.NumTestSets
        %% Train and test datasets:
        test_X = X(strpar.test(k),:,cfg.tpoints(tp));
        train_X = X(strpar.training(k),:,cfg.tpoints(tp));
        train_Y = Y(strpar.training(k));
        
        %% Train SVM model
        mdlSVM = fitcsvm(train_X,train_Y);
        
        %% Test - Temporal generalization matrix:
        if tempgen
            for tp2 = 1 : cfg.ntp
                test_X = X(strpar.test(k),:,cfg.tpoints(tp2));
                predictedlabels = predict(mdlSVM,test_X);
                cpmtx{tp,tp2} = classperf(cpmtx{tp,tp2},predictedlabels,...
                    strpar.test(k));
                correct_rate(tp,tp2) = cpmtx{tp,tp2}.CorrectRate;
            end
        else
            predictedlabels = predict(mdlSVM,test_X);
            classperf(cp{tp},predictedlabels,strpar.test(k));
            correct_rate(tp) = cp{tp}.CorrectRate;
        end
    end
    
    %% Print state:
    if tp > 1
        for j = 0 : log10(tp-1) + n
            fprintf('\b'); % delete previous counter display
        end
    end
    
    fprintf([int2str(cfg.ntp) '/' int2str(tp)]);
end

end

