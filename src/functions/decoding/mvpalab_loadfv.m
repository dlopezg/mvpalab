function [data,cfg] = mvpalab_loadfv(cfg,fv,job)
%% MVPALAB_LOADFV
%
%  This function returns the datasets of the current subject and frequency
%  band, ready for the decoding analysis.
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
    subject = job.folders(job.sub);
    folder = [subject.folder filesep subject.name];
    files = dir([folder filesep 'ffv_*.mat']);
    band = load([folder filesep files(job.freq).name],'fv');
    fv = band.fv;
else
    fv = fv{job.sub};
end

%% Update nfold for each subject if LOO is selected:
if strcmp(cfg.cv.method,'loo')
    cfg.cv.nfolds = cfg.cv.loo(job.sub);
end

%% Electrode selection:
[data.a.X,cfg] = mvpalab_chanselection(fv.X.a,cfg);
data.a.Y = fv.Y.a;

if job.mvcc
    [data.b.X,cfg] = mvpalab_chanselection(fv.X.b,cfg);
    data.b.Y = fv.Y.b;
end

end
