function [data,cfg] = mvpalab_loadfv(cfg,fv,job)
%% MVPALAB_LOADFV
%
%  This function returns the datasets of the current subject and frequency
%  band, ready for the decoding analysis. The datasets keep all the
%  channels: they are selected in each repetition (see mvpalab_repdata).
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
%
%  - {struct} - cfg:
%    Updated configuration structure.

%% Load data if needed:
if cfg.sf.flag
    band = load(mvpalab_sffile(cfg,'fv',job.sub,job.freq),'fv');
    fv = band.fv;
else
    fv = fv{job.sub};
end

mvpalab_checkfv(cfg,fv);

%% Update nfold for each subject if LOO is selected:
if strcmp(cfg.cv.method,'loo')
    cfg.cv.nfolds = cfg.cv.loo(job.sub);
end

%% Datasets:
data.a.X = fv.X.a;
data.a.Y = fv.Y.a;

if job.mvcc
    data.b.X = fv.X.b;
    data.b.Y = fv.Y.b;
end

end
