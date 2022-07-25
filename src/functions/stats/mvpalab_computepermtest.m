function stats = mvpalab_computepermtest(cfg,performance,permuted_maps)

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

%% Initilization - Generate permutation idx matrix:
% Here we determine the map of each subject that has to be selected in each
% permutation.
nSubjects = size(performance,3);
cfg.stats.sub = nSubjects;
perm_idxs = randi(cfg.stats.nper,cfg.stats.sub,cfg.stats.nperg,'single');

%% Generate permuted maps at group level:
% One permuted map of each subject has to be randomly selected and group
% averaged. Here we are using the previously determined permutation
% indexes for each subject and permutation.

fprintf('   - Generating permuted maps at group level: ');
for i = 1 : cfg.stats.nperg
    for j = 1 : cfg.stats.sub
        permaps(:,:,j) = squeeze(permuted_maps(:,:,j,perm_idxs(j,i)));
    end
    gpermaps(:,:,i) = mean(permaps,3);
end
fprintf(' - Done!\n');

%% Generate the null distribution and p-value thresholds:
% Generate the null distribution for each timepoint using the permuted
% performanceuracy maps. Here we can define the performance level 
% associated to a p-value of 0.05 (95th percentile) for each timepoint and 
% generate a threshold mask.

% Check the cfg structure
mvpalab_checkcfg(cfg); 

% Define the distribution threshold
threshold = cfg.stats.pgroup; 

% Update de distribution threshold for two tail test.
if (cfg.stats.tails == 2)
    tail = ( 100 - cfg.stats.pgroup ) / 2;
    threshold = cfg.stats.pgroup + tail;  
end

fprintf('   - Generating the null distribution and p-value thresholds:');
for i = 1 : size(gpermaps,1)
    for j = 1 : size(gpermaps,2)
        if (cfg.stats.tails == 1) % One tail - above chance
            pctval(i,j) = prctile(gpermaps(i,j,:),threshold);
        elseif (cfg.stats.tails == -1)  % One tail - below chance   
            pctval_(i,j) = prctile(gpermaps(i,j,:),100-threshold);
        else % Two tails - above and below chance
            pctval(i,j) = prctile(gpermaps(i,j,:),threshold);
            pctval_(i,j) = prctile(gpermaps(i,j,:),100-threshold);
        end
    end
end
fprintf(' - Done!\n');

%% Plot the null distribution of performance values:
% Plot the null distribution of performance values for a specific timepoint
% (i) and permuted map (j).
pvg = num2str((100 - cfg.stats.pgroup ) / 100);
f1 = figure;
subplot(2,2,[1 2]);
h = histogram(gpermaps(i,j,:),'Normalization','probability');
h.FaceColor = [.5 .5 .5];
h.EdgeColor = [.5 .5 .5];
hold on
if (cfg.stats.tails == 1) % One tail - above chance
    vl = vline(double(pctval(i,j)),'r-',['Above chance threshold (p<' pvg ')']);
elseif (cfg.stats.tails == -1) % One tail - below chance  
    vl = vline(double(pctval_(i,j)),'r-',['Below chance threshold (p<' pvg ')']);
else % Two tails - above and below chance
    vl = vline(double(pctval(i,j)),'r-',['Above chance threshold (p<' pvg ')']);
    vl = vline(double(pctval_(i,j)),'r-',['Below chance threshold (p<' pvg ')']);
end
grid minor
title('Permuted distribution (group level)')
xlabel('Data distribution');
ylabel('Normalized histogram')


%% Search clusters in permuted maps:
% Clusters are defined using the pctval mask previously calculated.

fprintf('   - Searching clusters in permuted maps:');
for map = 1 : size(gpermaps,3)
    if (cfg.stats.tails == 1) % One tail - above chance
        thresmaps(:,:,map) = gpermaps(:,:,map) > pctval;
        clustmaps{map} = bwconncomp(thresmaps(:,:,map));
    elseif (cfg.stats.tails == -1) % One tail - below chance
        thresmaps_(:,:,map) = gpermaps(:,:,map) < pctval_;
        clustmaps_{map} = bwconncomp(thresmaps_(:,:,map));
    else % Two tails - above and below chance
        thresmaps(:,:,map) = gpermaps(:,:,map) > pctval;
        clustmaps{map} = bwconncomp(thresmaps(:,:,map));
        thresmaps_(:,:,map) = gpermaps(:,:,map) < pctval_;
        clustmaps_{map} = bwconncomp(thresmaps_(:,:,map));
    end
end

fprintf(' - Done!\n');

%% Generate cluster size distribution:
fprintf('   - Generating cluster size distribution:');
sizedist = [];
sizedist_ = [];

for map = 1 : size(gpermaps,3)
    if (cfg.stats.tails == 1)
        for i = 1 : clustmaps{map}.NumObjects
            sizedist(end+1) = numel(clustmaps{map}.PixelIdxList{i});
        end
    elseif (cfg.stats.tails == -1)
        for i = 1 : clustmaps_{map}.NumObjects
            sizedist_(end+1) = numel(clustmaps_{map}.PixelIdxList{i});
        end
    else
        for i = 1 : clustmaps{map}.NumObjects
            sizedist(end+1) = numel(clustmaps{map}.PixelIdxList{i});
        end
        for i = 1 : clustmaps_{map}.NumObjects
            sizedist_(end+1) = numel(clustmaps_{map}.PixelIdxList{i});
        end
    end
end
fprintf(' - Done!\n');

%% Plot the null distribution of cluster sizes:
% This code sholud be optimized...

if (cfg.stats.tails == 1)
    % Cluster size distribution - above chance level.
    subplot(2,2,3);
    hold on
    h = histogram(...
        sizedist,'Normalization','probability','BinMethod','integers');
    hnorm = h.BinCounts/sum(h.BinCounts)';

    set(gca, 'YScale', 'log')
    h.FaceColor = [.5 .5 .5];
    h.EdgeColor = [.5 .5 .5];
    grid minor
    xlabel('Cluster size');
    ylabel('Normalized histogram (log scale)')
    title('Cluster size null distribution (above chance)')
elseif (cfg.stats.tails == - 1)
    % Cluster size distribution - below chance level.
    subplot(2,2,4);
    hold on
    h_ = histogram(...
        sizedist_,'Normalization','probability','BinMethod','integers');
    hnorm_ = h_.BinCounts/sum(h_.BinCounts)';
    set(gca, 'YScale', 'log')
    h_.FaceColor = [.5 .5 .5];
    h_.EdgeColor = [.5 .5 .5];
    grid minor
    xlabel('Cluster size');
    ylabel('Normalized histogram (log scale)')
    title('Cluster size null distribution (below chance)')
else
    % Cluster size distribution - above chance level.
    subplot(2,2,3);
    hold on
    h = histogram(...
        sizedist,'Normalization','probability','BinMethod','integers');
    hnorm = h.BinCounts/sum(h.BinCounts)';

    set(gca, 'YScale', 'log')
    h.FaceColor = [.5 .5 .5];
    h.EdgeColor = [.5 .5 .5];
    grid minor
    xlabel('Cluster size');
    ylabel('Normalized histogram (log scale)')
    title('Cluster size null distribution (above chance)')
    
    % Cluster size distribution - below chance level.
    subplot(2,2,4);
    hold on
    h_ = histogram(...
        sizedist_,'Normalization','probability','BinMethod','integers');
    hnorm_ = h_.BinCounts/sum(h_.BinCounts)';
    set(gca, 'YScale', 'log')
    h_.FaceColor = [.5 .5 .5];
    h_.EdgeColor = [.5 .5 .5];
    grid minor
    xlabel('Cluster size');
    ylabel('Normalized histogram (log scale)')
    title('Cluster size null distribution (below chance)')
end

%% Uncorrected cluster size threshold:
% stats.uncorrcsize = prctile(sizedist,cfg.stats.pclust);
% stats.uncorrcsize_ = prctile(sizedist_,cfg.stats.pclust);

%% False Discovery Rate (FDR) correction at cluster level:

% Initialization:
pval = (100 - cfg.stats.pclust) / 100;
pv = num2str(pval);
corrcsize  = 0;
corrcsize_ = 0;

if (cfg.stats.tails == 1)
    fdr = mafdr(hnorm,'bhfdr','true');
    corrcsize = find((fdr < pval) & (fdr ~= 0),1);
    if isempty(corrcsize); corrcsize = length(fdr); end
    subplot(2,2,3);
    vl = vline(corrcsize,'r-',['Cluster size threshold (p<' pv ')']);
elseif (cfg.stats.tails == -1)
    fdr_ = mafdr(hnorm_,'bhfdr','true');
    corrcsize_ = find((fdr_ < pval) & (fdr_ ~= 0),1);
    if isempty(corrcsize_); corrcsize_ = length(fdr_); end
    subplot(2,2,4);
    vl = vline(corrcsize_,'r-',['Cluster size threshold (p<' pv ')']);
else
    fdr = mafdr(hnorm,'bhfdr','true');
    corrcsize = find((fdr < pval) & (fdr ~= 0),1);
    if isempty(corrcsize); corrcsize = length(fdr); end
    fdr_ = mafdr(hnorm_,'bhfdr','true');
    corrcsize_ = find((fdr_ < pval) & (fdr_ ~= 0),1);
    if isempty(corrcsize_); corrcsize_ = length(fdr_); end
    subplot(2,2,3);
    vl = vline(corrcsize,'r-',['Cluster size threshold (p<' pv ')']);
    subplot(2,2,4);
    vl = vline(corrcsize_,'r-',['Cluster size threshold (p<' pv ')']);
end

%% Search clusters in real data:
fprintf('   - Searching clusters in real data:');

% Initialization:
thresdata = [];
thresdata_ = [];

% Thresholded performance map - above chance level:
if (cfg.stats.tails == 1)
    
    thresdata = mean(performance,3) > pctval;
    clusters = bwconncomp(thresdata);
    clusters.sig = [];
    clusters_.sig = [];
    
    % Significant clusters - above chance level.
    for i = 1 : clusters.NumObjects
        if numel(clusters.PixelIdxList{i}) > corrcsize
            clusters.sig = [clusters.sig; clusters.PixelIdxList{i}];
        end
    end
    
elseif (cfg.stats.tails == -1)
    
    thresdata_ = mean(performance,3) < pctval_;
    clusters_ = bwconncomp(thresdata_);
    clusters.sig = [];
    clusters_.sig = [];
    
    % Significant clusters - below chance level.
    for i = 1 : clusters_.NumObjects
        if numel(clusters_.PixelIdxList{i}) > corrcsize_
            clusters_.sig = [clusters_.sig; clusters_.PixelIdxList{i}];
        end
    end
    
else
    
    thresdata = mean(performance,3) > pctval;
    clusters = bwconncomp(thresdata);
    
    thresdata_ = mean(performance,3) < pctval_;
    clusters_ = bwconncomp(thresdata_);
    
    clusters.sig = [];
    clusters_.sig = [];
    
    for i = 1 : clusters.NumObjects
        if numel(clusters.PixelIdxList{i}) > corrcsize
            clusters.sig = [clusters.sig; clusters.PixelIdxList{i}];
        end
    end
    
    for i = 1 : clusters_.NumObjects
        if numel(clusters_.PixelIdxList{i}) > corrcsize_
            clusters_.sig = [clusters_.sig; clusters_.PixelIdxList{i}];
        end
    end
end

% Significant clusters mask for representation.
sigmask = ones(size(gpermaps,1),size(gpermaps,2));
sigmask(clusters.sig) = 0;

sigmask_ = ones(size(gpermaps,1),size(gpermaps,2));
sigmask_(clusters_.sig) = 0;

% Store results:
stats.corrcsize = corrcsize;
stats.corrcsize_ = corrcsize_;

stats.thresdata = thresdata;
stats.thresdata_ = thresdata_;

stats.clusters = clusters;
stats.clusters_ = clusters_;

stats.sigmask = sigmask;
stats.sigmask_ = sigmask_;

if ~cfg.stats.shownulldis
    close(f1);
end

fprintf(' - Done!\n');

end

