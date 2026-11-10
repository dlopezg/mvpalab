function mvpalab_checkdecoding(cfg,mode)
%% MVPALAB_CHECKDECODING
%
%  This function checks the settings of a decoding analysis (MVPA or MVCC)
%  before it starts, so a wrong setting stops with a clear error instead of
%  failing later or giving a wrong result:
%
%  - The classes of the analysis (see mvpalab_checkclasses).
%  - The methods of the analysis (see mvpalab_checkmethods).
%  - Observed maps: the settings of the sign flip test (see
%    mvpalab_checksignflip) and the feature weights (see
%    mvpalab_checkwvector).
%  - Permuted maps: the sign flip test has no permuted maps (see
%    mvpalab_nullmaps), so it gives an error.
%
%  mvpalab_decoding and mvpalab_sfilter call it.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {string} - mode:
%    'observed' or 'permuted'.

mvpalab_checkclasses(cfg);
mvpalab_checkmethods(cfg);

if strcmp(mode,'permuted')
    if cfg.stats.signflip
        error('The sign flip test has no permuted maps. Use mvpalab_nullmaps.');
    end
else
    mvpalab_checksignflip(cfg);
    mvpalab_checkwvector(cfg);
end

end
