function [ correct_rate, cfg] = svm_classifier( X, Y, cfg )
%SVM_CLASSIFIER This function returns the accuracy of the classifier in a
%time-resolved way.

strpar = cvpartition(Y,'KFold',cfg.cv.nfolds);

%% Timepoints loop:
fprintf('       - Timepoints: ');
n = numel(num2str(cfg.mvpa.ntp)) + 1;
for tp = 1 : cfg.mvpa.ntp
    cp{tp} = classperf(Y);
    %% Cross-validation loop:
    for k = 1 : strpar.NumTestSets
        %% Train and test datasets:
        test_X = X(strpar.test(k),:,cfg.mvpa.tpoints(tp));
        train_X = X(strpar.training(k),:,cfg.mvpa.tpoints(tp));
        train_Y = Y(strpar.training(k));
        
        %% Train SVM model
        mdlSVM = fitcsvm(train_X,train_Y);
        
        %% Test
        predictedlabels = predict(mdlSVM,test_X);
        classperf(cp{tp},predictedlabels,strpar.test(k));
        correct_rate(tp) = cp{tp}.CorrectRate;
    end
    
    % Print state:
    if tp>1
          for j=0:log10(tp-1)+n
              fprintf('\b'); % delete previous counter display
          end
    end
      
     fprintf([int2str(cfg.mvpa.ntp) '/' int2str(tp)]);
end

end

