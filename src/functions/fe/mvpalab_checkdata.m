function mvpalab_checkdata(cfg,raw,sub)
%% MVPALAB_CHECKDATA
%
%  This function checks that the files of one subject agree with the
%  information of the study (see mvpalab_datainfo): the same sampling
%  frequency and the same time vector, up to half a sample. All the
%  timepoints of the analysis come from the first file, so a file with
%  other times would be decoded on the wrong times without any error.
%  The files of the subject must also have the same channels, because
%  the classes are stacked and the datasets of MVCC are crossed.
%  Different subjects can have different channels.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.fs, cfg.tm.rtimes and cfg.study).
%
%  - {cell array} - raw:
%    Data of the subject {datasets x classes} (see mvpalab_readsubject).
%
%  - {int} - sub:
%    Subject.

tolerance = 0.5*1000/cfg.fs;
times = cfg.tm.rtimes(:)';

for i = 1 : numel(raw)
    [ctxt,class] = ind2sub(size(raw),i);
    file = cfg.study.dataFiles{ctxt,class}{sub};
    EEG = raw{i};

    if EEG.srate ~= cfg.fs || numel(EEG.times) ~= numel(times) || ...
            max(abs(EEG.times(:)' - times)) >= tolerance
        error(['%s has a different sampling frequency or time vector ' ...
            'than the first file of the study.'],file);
    end

    if size(EEG.data,1) ~= size(raw{1,1}.data,1)
        error('%s has a different number of channels than the other files of the subject.',file);
    end
end

end
