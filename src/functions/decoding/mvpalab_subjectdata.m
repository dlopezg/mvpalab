function data = mvpalab_subjectdata(cfg,fv,job)
%% MVPALAB_SUBJECTDATA
%
%  This function returns the datasets of the current subject and frequency
%  band, ready for the decoding analysis. The datasets keep all the
%  channels and they are not normalized: both are applied in each
%  repetition (see mvpalab_preparedata).
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
    band = load(mvpalab_sffile(cfg,'fv',job.sub,job.freq),'fv');
    fv = band.fv;
else
    fv = fv{job.sub};
end

mvpalab_checkfv(cfg,fv);

%% Datasets:
data.a.X = fv.X.a;
data.a.Y = fv.Y.a;

if job.mvcc
    data.b.X = fv.X.b;
    data.b.Y = fv.Y.b;
end

end
