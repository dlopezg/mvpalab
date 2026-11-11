function [fv,cfg] = mvpalab_sfbaseline(cfg)
%% MVPALAB_SFBASELINE
%
%  This function reads the unfiltered baseline of a sliding filter
%  analysis: the feature vectors of each subject without any filter (see
%  mvpalab_readdata), rounded to single precision and read in double
%  precision as those of the bands saved by the import (see
%  mvpalab_savesfdata and mvpalab_subjectdata), so a filter without effect
%  gives a diffMap of exactly 0. mvpalab_sfilter and mvpalab_sfnullmaps
%  use it, so the observed and the permuted baselines are read in the
%  same way.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%%  OUTPUT:
%
%  - {cell array} - fv:
%    Feature vectors of each subject.
%
%  - {struct} - cfg:
%    Configuration structure (see mvpalab_readdata).

[cfg,~,fv] = mvpalab_readdata(cfg);
fv = cellfun(@singleprecision,fv,'UniformOutput',false);

end

function fv = singleprecision(fv)
%% Feature vectors of one subject rounded to single precision and read in
%  double precision, as the bands.

for field = fieldnames(fv.X)'
    fv.X.(field{1}) = double(single(fv.X.(field{1})));
end

end
