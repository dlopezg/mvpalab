%% MVPALAB_PLOTMASK 
%
% Detailed explanation goes here.
clear all
clc

cfg.study.maskFile = '/Users/David/Desktop/att-exp-fmri/roi/mask.nii';
mask = mvpalab_loadmask(cfg);
figure;

plot3(mask.coor(:,1),mask.coor(:,2),mask.coor(:,3),'o','Color','#A2142F','MarkerSize',.5,'MarkerFaceColor','#A2142F')
hold on


cfg.study.maskFile = '/Users/David/Desktop/att-exp-fmri/roi/rVVC_bilateral.nii';
mask = mvpalab_loadmask(cfg);
plot3(mask.coor(:,1),mask.coor(:,2),mask.coor(:,3),'o','Color','#A2142F','MarkerSize',5,'MarkerFaceColor','#A2142F')

xlim([0,mask.dim(1)])
ylim([0,mask.dim(2)])
zlim([0,mask.dim(3)])

