function [ acc ] = acc_analysis( cfg, inputvec )
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('      <strong>> Calculating correct rate...</strong>\n');
tic
%% Data and true labels:
class_a = inputvec{1};
class_b = inputvec{2};

size_a = size(class_a,1);
size_b = size(class_b,1);

X = [class_a;class_b];
Y = logical([zeros(size_a,1);ones(size_b,1)]);

%% Train and test de classifier with original labels:
strpar = cvpartition(Y,'KFold',cfg.mvpa.nfolds);

if cfg.mvpa.parcomp
    %% Timepoints loop
    c = cfg.mvpa;
    parfor tp = 1 : cfg.mvpa.ntp
        correct_rate(tp,:) = svm_classifier_2(X,Y,c,strpar,tp);
    end
else
    for tp = 1 : cfg.mvpa.ntp
        correct_rate(tp,:) = svm_classifier_2(X,Y,cfg.mvpa,strpar,tp);
    end
end

if isrow(correct_rate)
    acc(:,:) = correct_rate;
else
    acc(:,:) = correct_rate';
end
fprintf('\n       - Done! > '); toc; fprintf('\n\n');

% acc(:,:) = svm_classifier(X,Y,cfg.mvpa);

end

