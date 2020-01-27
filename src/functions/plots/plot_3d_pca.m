function [] = plot_3d_pca( X_train, Y_train )
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here

class_a = X_train(Y_train,:);
class_b = X_train(~Y_train,:);

figure;
hold on

scatter3(class_a(:,1),class_a(:,2),class_a(:,3));
scatter3(class_b(:,1),class_b(:,2),class_b(:,3));




end

