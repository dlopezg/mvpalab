function [ permuted_maps ] = permutation_maps( cfg, inputvec )
%PERMUTATION_MAPS This function generates permutation maps at a subject
%level for future statistical analyses.
fprintf('      <strong>> Generating permutation maps...</strong>\n');

%% Data and true labels:
class_a = inputvec{1};      
class_b = inputvec{2};

size_a = size(class_a,1);   
size_b = size(class_b,1);

X = [class_a;class_b];
Y = logical([zeros(size_a,1);ones(size_b,1)]);

%% Generate permuted labels
per_Y = repmat(Y,1,cfg.stats.nper);

for i = 1 : cfg.stats.nper
    per_Y(:,i) = Y(randperm(length(Y)));
end

%% Train and test de classifier with permuted labels:
for i = 1 : cfg.stats.nper
    tic
    permuted_maps(:,:,i) = svm_classifier(X,per_Y(:,i),cfg.mvpa);
    fprintf([' - Permutation: ' int2str(i) ' > ']);
    toc
end

end

