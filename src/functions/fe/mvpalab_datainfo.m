function cfg = mvpalab_datainfo(cfg,raw)
%% MVPALAB_DATAINFO
%
%  This function stores the information of the study that comes from the
%  data, taken from the first file of the first subject: the sampling
%  frequency (cfg.fs), the channel locations (cfg.channels.chanloc) and
%  the timepoints of the analysis (see mvpalab_timing). The files of every
%  subject are checked against it (see mvpalab_checkdata).
%
%  The times must be in milliseconds (see mvpalab_dataformat), as cfg.tm
%  and the plots. A sample lasts 1000/fs milliseconds, or 1/fs seconds, so
%  it shows a warning if the step between the times is closer to 1/fs
%  (below sqrt(1000)/fs, the midpoint in logarithmic scale).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - raw:
%    Data of the first subject {datasets x classes} (see
%    mvpalab_readsubject).
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Updated configuration structure.

first = raw{1,1};

cfg.fs = first.srate;
cfg.channels.chanloc = first.chanlocs;

if numel(first.times) > 1 && median(diff(first.times))*cfg.fs < sqrt(1000)
    warning(['The times of the data seem to be in seconds. MVPAlab ' ...
        'needs them in milliseconds.']);
end
cfg = mvpalab_timing(cfg,first.times);

end
