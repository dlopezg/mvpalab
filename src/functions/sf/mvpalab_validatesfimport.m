function mvpalab_validatesfimport(cfg)
%% MVPALAB_VALIDATESFIMPORT
%
%  This function checks that the settings of a sliding filter analysis
%  are those of the import of its filtered data. The bands are built when
%  the data is imported (see mvpalab_readsfdata), while the unfiltered
%  baseline is read again with the current cfg (see mvpalab_sfbaseline),
%  so a setting changed after the import would compare bands and a
%  baseline of different data without any error: other subjects or
%  files, other features, other timepoints or other bands, or a temporal
%  generalization the import disabled.
%
%  It compares cfg with the cfg saved in the first file of the bands, in
%  these fields: cfg.study, cfg.feature, cfg.powenv, cfg.smoothdata, the
%  time window (cfg.tm.tpstart, tpend, tpstart_, tpend_ and tpsteps),
%  cfg.classmodel.tempgen and the bands (cfg.sf.lfreq, hfreq, bw, nfreq,
%  fspac, ftype, wtype and order). It gives an error that lists the fields
%  that changed. The settings applied by the analysis to the bands and to
%  the baseline alike (supertrials, class sizes, channels, normalization,
%  classifier) can change. mvpalab_subjectdata also checks that each file
%  comes from the same import (cfg.sf.importid).
%
%  mvpalab_sfilter and mvpalab_sfnullmaps call it.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure, as returned by the import.

file = mvpalab_sffile(cfg,'fv',1,1);
if ~isfile(file)
    error(['%s does not exist: import the data with cfg.sf.flag enabled ' ...
        'before the sliding filter analysis.'],file);
end
saved = load(file,'cfg');

fields = {'study','feature','powenv','smoothdata','tm.tpstart','tm.tpend',...
    'tm.tpstart_','tm.tpend_','tm.tpsteps','classmodel.tempgen','sf.lfreq',...
    'sf.hfreq','sf.bw','sf.nfreq','sf.fspac','sf.ftype','sf.wtype','sf.order'};
changed = fields(~cellfun(@(field) isequaln(fieldvalue(cfg,field),...
    fieldvalue(saved.cfg,field)),fields));

if ~isempty(changed)
    error(['These settings changed after the import of the sliding filter ' ...
        'data: cfg.%s. Use the cfg returned by the import, or import the ' ...
        'data again.'],strjoin(changed,', cfg.'));
end

end

function value = fieldvalue(cfg,field)
%% Value of a field of cfg, given as 'study' or 'tm.tpstart'.

parts = strsplit(field,'.');
value = getfield(cfg,parts{:});

end
