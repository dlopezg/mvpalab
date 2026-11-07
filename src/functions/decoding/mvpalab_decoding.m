function [res,cfg] = mvpalab_decoding(cfg,fv,mode)
%% MVPALAB_DECODING
%
%  This function computes the decoding analysis defined in cfg.analysis:
%  MVPA or MVCC (cross-classification between datasets A and B, in both
%  directions: training in A and test in B and vice versa), and their
%  permuted maps for the permutation test:
%
%    [result,cfg] = mvpalab_decoding(cfg,fv);
%    [permaps,cfg] = mvpalab_decoding(cfg,fv,'permuted');
%
%  A permuted map is the observed map computed with permuted labels, so
%  both follow the same pipeline:
%
%    Subjects > frequency bands > maps (one if observed, cfg.stats.nper if
%    permuted) > repetitions (supertrials and partitions) > timepoints (see
%    mvpalab_decodemap).
%
%  In MVCC each permuted map uses one reassignment of the labels of dataset
%  A in both directions (training labels in A - B, test labels in B - A),
%  while dataset B keeps its labels. The two directions of the observed
%  analysis use the same data and labels, so they are correlated; permuting
%  each direction separately loses this correlation and the null
%  distribution of their mean is too narrow. With supertrials, both
%  directions of a repetition use the same supertrials of each dataset.
%
%  Limitation: the permutation also removes the decoding within dataset A.
%  If datasets A and B contain decoding effects that are not shared, the
%  null distribution can be narrower than the distribution of the
%  cross-decoding between them, so the test can be liberal. The sign flip
%  test (cfg.stats.signflip) does not permute labels, so it is recommended
%  for MVCC (see mvpalab_signmaps).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - fv:
%    Feature vectors of each subject (single trials if cfg.trialaver.flag
%    is enabled). Empty or not used in a sliding filter analysis, where the
%    data of each frequency band is loaded from disk.
%
%  - {string} - mode:
%    'observed' (default) or 'permuted'.
%
%%  OUTPUT:
%
%  - {struct} - res:
%    Result or permuted maps of each performance metric (see
%    mvpalab_storemap and mvpalab_packres).
%
%  - {struct} - cfg:
%    Updated configuration structure.

if nargin < 2, fv = []; end
if nargin < 3, mode = 'observed'; end

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);
mvpalab_savecfg(cfg);

% Check the classes and the methods of the analysis:
mvpalab_checkclasses(cfg);
mvpalab_checkmethods(cfg);

if strcmp(mode,'permuted')
    % The sign flip test has no permuted maps (see mvpalab_nullmaps):
    if cfg.stats.signflip
        error('The sign flip test has no permuted maps. Use mvpalab_nullmaps.');
    end
else
    mvpalab_checksignflip(cfg);
    % Feature weights are not available with non-linear kernels:
    mvpalab_checkwvector(cfg);
end

[res,cfg,job] = mvpalab_decodingmaps(cfg,fv,mode);

% Save result:
if ~cfg.sf.flag, mvpalab_save(cfg,res,job.savemode); end

% Save the configuration with the fields set by the analysis:
mvpalab_savecfg(cfg);

end
