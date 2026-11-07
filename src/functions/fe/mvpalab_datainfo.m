function cfg = mvpalab_datainfo(cfg,raw)
%% MVPALAB_DATAINFO
%
%  This function stores the information of the study that comes from the
%  data, taken from the first file of the first subject: the sampling
%  frequency (cfg.fs), the channel locations (cfg.channels.chanloc) and
%  the timepoints of the analysis (see mvpalab_timing). The files of every
%  subject are checked against it (see mvpalab_checkdata).
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
cfg = mvpalab_timing(cfg,first.times);

end
