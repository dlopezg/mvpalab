function rdms = mvpalab_rdm(cfg,X)
%% MVPALAB_RDM
%
%  This function returns the trial-wise Representational Dissimilarity
%  Matrices for each timepoint.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {3D-matrix} - X:
%    Data matrix for an individual subject containing all the trials and
%    conditions. [trials x chanels x timepoints]
%
%%  OUTPUT:
%
%  - {3D-matrix} - rdm:
%    Representational Dissimilarity Matrices for each timepoint:
%    [trials x trials x timepoints]
%

fprintf('   - Computing neural RDMs:');

%% Preallocate the RDM matrices:
ntrial = size(X,1);
ntp = size(X,3);
rdms = NaN(ntrial,ntrial,ntp);

%% Construct RDMs using the specified distance measure:

% print the location of cfg_file.m
fprintf('cfg_file.m is located at: %s\n', cfg.location);

% check whether parallel computing is enabled:
if cfg.classmodel.parcomp
    fprintf('   - Parallel computing enabled.\n');
else
    fprintf('   - Parallel computing disabled.\n');
end

% check dimensionality of the data:
fprintf('   - Data dimensions: ');
fprintf([int2str(size(X,1)) ' trials x ' int2str(size(X,2)) ' channels x ' int2str(size(X,3)) ' timepoints.\n']);

% print ntp:
fprintf('   - Number of timepoints: %d\n', ntp);

% print the distance measure:
fprintf('   - Distance measure: %s\n', cfg.rsa.distance);

% print cfg.classmodel.parcomp:
fprintf('   - Parallel computing: %d\n', cfg.classmodel.parcomp);

if cfg.classmodel.parcomp && ntp > 1
    parfor tp = 1 : ntp
        rdms(:,:,tp) = mvpalab_computerdm(cfg,X(:,:,tp), []);
    end
else
    for tp = 1 : ntp
        rdms(:,:,tp) = mvpalab_computerdm(cfg,X(:,:,tp), []);
    end
end

fprintf('- Done.\n\n');

end

