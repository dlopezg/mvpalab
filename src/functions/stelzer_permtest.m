function [ stats ] = stelzer_permtest( cfg, acc, permuted_maps )
%STELTZER_PERMTEST Summary of this function goes here
%   Detailed explanation goes here

%% Path for external libraries:
path(path,'../extlibs/hline_vline');
path(path,'../extlibs/');
fprintf('<strong> > Stelzer permutation test: </strong>\n');
%% Initilization - Generate permutation idx matrix:
% Here we determine the map of each subject that has to be selected in each
% permutation.

c = cfg.stats;
c.sub = length(cfg.subjects);
perm_idxs = randi(c.nper,c.sub,c.nperg,'single');

%% Generate permuted maps at group level:
% One permuted map of each subject has to be randomly selected and group
% averaged. Here we are using the previously determined permutation
% indexes for each subject and permutation.
fprintf('   - Generating permuted maps at group level: \n');
fprintf('      # Permuted maps >> ');
c.nperg = 1e4;
for i = 1 : c.nperg
    for j = 1 : c.sub
        per_maps(:,:,j) = permuted_maps(:,:,perm_idxs(j,i),j);
    end
    group_maps(:,:,i) = mean(per_maps,3);
    print_counter(i,c.nperg);
end
fprintf(' - Done!\n');

%% Generate the null distribution and p-value thresholds
% Generate the null distribution for each timepoint using the permuted
% accuracy maps. Here we can define the accuracy level associated to a
% p-value of 0.001 (99.9th percentile) for each timepoint and generate a
% thresold mask.
fprintf('   - Generating the null distribution and p-value thresholds:');
for row = 1 : size(group_maps,1)
    for col = 1 : size(group_maps,2)
        pctval_mask_r(row,col) = prctile(group_maps(row,col,:),c.pgroup);
        pctval_mask_l(row,col) = prctile(group_maps(row,col,:),100-c.pgroup);
    end
end
fprintf(' - Done!\n');

%% Plot the null distribution of accuracy values:
figure;
subplot(1,3,[1 2]);
h = histogram(group_maps(row,col,:),'Normalization','probability');
h.FaceColor = [.5 .5 .5];
h.EdgeColor = [.5 .5 .5];
hold on
vl = vline(double(pctval_mask_r(row,col)),'r-','Accuracy threshold (p<.001)');
xlabel('acc');
grid minor
title('Accuracy null distribution (group level)')
xlabel('Accuracy');
ylabel('Normalized histogram')

%% Search clusters in permuted maps:
fprintf('   - Searching clusters in permuted maps:');
for map = 1 : size(group_maps,3)
    thresholded_maps_r(:,:,map) = group_maps(:,:,map) > pctval_mask_r;
    thresholded_maps_l(:,:,map) = group_maps(:,:,map) < pctval_mask_l;
    clustered_maps_r{map} = bwconncomp(thresholded_maps_r(:,:,map));
    clustered_maps_l{map} = bwconncomp(thresholded_maps_l(:,:,map));
end
fprintf(' - Done!\n');

%% Generate cluster size distribution:
fprintf('   - Generating cluster size distribution:');
size_dist_r = [];
size_dist_l = [];
for map = 1 : size(group_maps,3)
    for cluster = 1 : clustered_maps_r{map}.NumObjects
        size_dist_r(end+1) = numel(clustered_maps_r{map}.PixelIdxList{cluster});
    end
    for cluster = 1 : clustered_maps_l{map}.NumObjects
        size_dist_l(end+1) = numel(clustered_maps_l{map}.PixelIdxList{cluster});
    end
end
fprintf(' - Done!\n');

%% Plot the null distribution of cluster sizes:
subplot(1,3,3);
hl = histogram(size_dist_r,'Normalization','probability','BinMethod','integers');
hl_norm = hl.BinCounts/sum(hl.BinCounts)';
hr = histogram(size_dist_r,'Normalization','probability','BinMethod','integers');
hr_norm = hr.BinCounts/sum(hr.BinCounts)';
set(gca, 'YScale', 'log')
hr.FaceColor = [.5 .5 .5];
hr.EdgeColor = [.5 .5 .5];
grid minor
xlabel('Cluster size');
ylabel('Normalized histogram (log scale)')
title('Cluster size null distribution')

%% Uncorrected cluster size threshold:
pval = (100 - c.pclust) / 100;
cluster_threshold_uncorr_r = find((hr_norm < pval) & (hr_norm ~= 0),1);
cluster_threshold_uncorr_l = find((hl_norm < pval) & (hl_norm ~= 0),1);

%% False Discovery Rate (FDR) correction at cluster level:
fdr_r = mafdr(hr_norm,'bhfdr','true');
fdr_l = mafdr(hl_norm,'bhfdr','true');

cluster_threshold_corr_r = find((fdr_r < pval) & (fdr_r ~= 0),1);
cluster_threshold_corr_l = find((fdr_l < pval) & (fdr_l ~= 0),1);

if isempty(cluster_threshold_corr_r)
    cluster_threshold_corr_r = length(fdr_r);
end

if isempty(cluster_threshold_corr_l)
    cluster_threshold_corr_l = length(fdr_l);
end

hold on
vl = vline(cluster_threshold_corr_r,'r-','Cluster size threshold (p<.001)');

%% Search clusters in real data:
fprintf('   - Searching clusters in real data:');
% Thresholded map:
thresholded_data_r = mean(acc,3) > pctval_mask_r;
clusters_data_r = bwconncomp(thresholded_data_r);
clusters_data_r.sig = [];

thresholded_data_l = mean(acc,3) < pctval_mask_l;
clusters_data_l = bwconncomp(thresholded_data_l);
clusters_data_l.sig = [];

for cluster = 1 : clusters_data_r.NumObjects
    if numel(clusters_data_r.PixelIdxList{cluster}) > cluster_threshold_corr_r
        clusters_data_r.sig = [clusters_data_r.sig;...
            clusters_data_r.PixelIdxList{cluster}];
    end
end

for cluster = 1 : clusters_data_l.NumObjects
    if numel(clusters_data_l.PixelIdxList{cluster}) > cluster_threshold_corr_l
        clusters_data_l.sig = [clusters_data_l.sig;...
            clusters_data_l.PixelIdxList{cluster}];
    end
end

%% Generate output:
stats.cluster_threshold_corr_r = cluster_threshold_corr_r;
stats.cluster_threshold_uncorr_r = cluster_threshold_uncorr_r;
stats.clusters_r = clusters_data_r;
stats.thresholded_data_r = thresholded_data_r;

stats.cluster_threshold_corr_l = cluster_threshold_corr_l;
stats.cluster_threshold_uncorr_l = cluster_threshold_uncorr_l;
stats.clusters_l = clusters_data_l;
stats.thresholded_data_l = thresholded_data_l;

fprintf(' - Done!\n');
fprintf('<strong> > Stelzer permutation test finished!</strong>\n');
end

