function [ clusters_data ] = stelzer_permtest( cfg, acc, permuted_maps )
%STELTZER_PERMTEST Summary of this function goes here
%   Detailed explanation goes here

%% Path for external libraries:
path(path,'../extlibs/');

%% Initilization - Generate permutation idx matrix:
% Here we determine the map of each subject that has to be selected in each
% permutation.

c = cfg.stats;
c.sub = length(cfg.subjects);
perm_idxs = randi(c.nper,c.sub,c.nperg);

%% Generate permuted maps at group level:
% One permuted map of each subject has to be randomly selected and group
% averaged. Here we are using the previously determined permutation
% indexes for each subject and permutation.

for i = 1 : c.nperg
    for j = 1 : c.sub
        per_maps(:,:,j) = permuted_maps(:,:,perm_idxs(j,i),j);
    end
    group_maps(:,:,i) = mean(per_maps,3);
end

%% Generate the null distribution and p-value thresholds
% Generate the null distribution for each timepoint using the permuted
% accuracy maps. Here we can define the accuracy level associated to a
% p-value of 0.001 (99.9th percentile) for each timepoint and generate a
% thresold mask.

for row = 1 : size(group_maps,1)
    for col = 1 : size(group_maps,2)
        pctval_mask(row,col) = prctile(group_maps(row,col,:),c.pgroup);
    end
end

%% Plot the null distribution of accuracy values:
figure;
subplot(1,3,[1 2]);
h = histogram(group_maps(row,col,:),'Normalization','probability');
h.FaceColor = [.5 .5 .5];
h.EdgeColor = [.5 .5 .5];
hold on
vl = vline(pctval_mask(row,col),'r-','Accuracy threshold (p<.001)');
xlabel('acc');
grid minor
title('Accuracy null distribution (group level)')
xlabel('Accuracy');
ylabel('Normalized histogram')

%% Look for clusters in permuted maps:

for map = 1 : size(group_maps,3)
    thresholded_maps(:,:,map) = group_maps(:,:,map) > pctval_mask;
    clustered_maps{map} = bwconncomp(thresholded_maps(:,:,map));
end

%% Generate cluster size distribution:
size_dist = [];
for map = 1 : size(group_maps,3)
    for cluster = 1 : clustered_maps{map}.NumObjects
        size_dist(end+1) = numel(clustered_maps{map}.PixelIdxList{cluster});
    end
end

%% Plot the null distribution of cluster sizes:
subplot(1,3,3);
h = histogram(size_dist,'Normalization','probability','BinMethod','integers');
h_norm = h.BinCounts/sum(h.BinCounts)';
set(gca, 'YScale', 'log')
h.FaceColor = [.5 .5 .5];
h.EdgeColor = [.5 .5 .5];
grid minor
xlabel('Cluster size');
ylabel('Normalized histogram (log scale)')
title('Cluster size null distribution')

%% Uncorrected cluster size threshold:
pval = (100 - c.pclust) / 100;
cluster_threshold_uncorr = find((h_norm < pval) & (h_norm ~= 0),1);

%% False Discovery Rate (FDR) correction at cluster level:
fdr = mafdr(h_norm,'bhfdr','true');
cluster_threshold_corr = find((fdr < pval) & (fdr ~= 0),1);
if isempty(cluster_threshold_corr)
    cluster_threshold_corr = length(fdr);
end

hold on
vl = vline(cluster_threshold_corr,'r-','Cluster size threshold (p<.001)');

%% Look for clusters in real data:
% Thresholded map:
thresholded_data = mean(acc,3) > pctval_mask;
clusters_data = bwconncomp(thresholded_data);

for cluster = 1 : clusters_data.NumObjects
    if numel(clusters_data.PixelIdxList{cluster}) <= cluster_threshold_corr
        clusters_data.PixelIdxList{cluster} = NaN;
    end
end


end

