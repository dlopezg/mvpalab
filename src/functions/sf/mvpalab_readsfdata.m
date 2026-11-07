function cfg = mvpalab_readsfdata(cfg)
%% MVPALAB_READSFDATA
%
%  This function reads the data of each subject of a sliding filter
%  analysis once (see mvpalab_readsubject), filters it in each frequency
%  band (see mvpalab_filterdata) and computes and saves the feature
%  vectors of each band in cfg.sf.filesLocation (see mvpalab_fext and
%  mvpalab_savesfdata). The data stays on disk, so only one subject is
%  kept in memory.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (see mvpalab_preparesf).
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Updated configuration structure.

nsub = length(cfg.study.dataFiles{1,1});
nfreq = length(cfg.sf.freqvec);

for sub = 1 : nsub
    [raw,cfg] = mvpalab_readsubject(cfg,sub);

    for freq = 1 : nfreq
        fprintf('  <strong> > Filtering data: </strong>');
        fprintf([int2str(freq) '/' int2str(nfreq) '\n\n']);

        filtered = raw;
        for i = 1 : numel(raw)
            filtered{i}.data = mvpalab_filterdata(raw{i},freq,cfg);
        end

        data = mvpalab_classdata(cfg,filtered);
        [fv,cfg] = mvpalab_fext(cfg,data,sub);
        mvpalab_savesfdata(cfg,data,fv,sub,freq);
    end
end

end
