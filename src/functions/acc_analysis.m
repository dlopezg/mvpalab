function [ acc ] = acc_analysis( cfg, inputvec )
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('      <strong>> Calculating correct rate...</strong>\n');

%% Data and true labels:
class_a = inputvec{1};      
class_b = inputvec{2};

size_a = size(class_a,1);   
size_b = size(class_b,1);

X = [class_a;class_b];
Y = logical([zeros(size_a,1);ones(size_b,1)]);

%% Configure MVPA timming and CV:
cfg.acc.cv = cfg.cv;
cfg.acc.times = cfg.times;
cfg.acc = mvpa_timming(cfg.acc);

%% Train and test de classifier with original labels:
acc(:,:) = svm_classifier(X,Y,cfg.acc);
fprintf(['\n       - Done! \n\n']);
end

