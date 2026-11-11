function data = mvpalab_subjectdata(cfg,fv,job)
%% MVPALAB_SUBJECTDATA
%
%  This function returns the datasets of the current subject and frequency
%  band, ready for the decoding analysis. The datasets keep all the
%  channels and they are not normalized: both are applied in each
%  repetition (see mvpalab_preparedata). In a sliding filter analysis the
%  feature vectors of the band are read from disk, where they are saved in
%  single precision (see mvpalab_savesfdata), and converted to double. It
%  gives an error if they come from another import than cfg, because then
%  the analysis or its null maps would use other data (cfg.sf.importid,
%  see mvpalab_preparesf).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - fv:
%    Feature vectors of each subject (not used in a sliding filter
%    analysis).
%
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).
%
%%  OUTPUT:
%
%  - {struct} - data:
%    Data matrix (X) and labels (Y) of dataset A (data.a) and, in MVCC, of
%    dataset B (data.b).

%% Load data if needed:
if cfg.sf.flag
    % Saved in single precision (see mvpalab_savesfdata), computed in
    % double precision:
    file = mvpalab_sffile(cfg,'fv',job.sub,job.freq);
    band = load(file,'fv','cfg');
    imported = '';
    if isfield(band.cfg.sf,'importid'), imported = band.cfg.sf.importid; end
    if ~strcmp(imported,cfg.sf.importid)
        error(['%s comes from another import than this cfg. Use the cfg ' ...
            'of that import, or import the data again.'],file);
    end
    fv = band.fv;
    fv.X = structfun(@double,fv.X,'UniformOutput',false);
else
    fv = fv{job.sub};
end

mvpalab_validatefv(cfg,fv);

%% Datasets:
data.a.X = fv.X.a;
data.a.Y = fv.Y.a;

if job.mvcc
    data.b.X = fv.X.b;
    data.b.Y = fv.Y.b;
end

end
