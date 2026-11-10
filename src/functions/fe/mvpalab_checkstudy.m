function mvpalab_checkstudy(cfg)
%% MVPALAB_CHECKSTUDY
%
%  This function checks the files of the study before any of them is read,
%  so the import stops with a clear error:
%
%  - Dataset B (second row of cfg.study.dataFiles) has the files of every
%    class or of none, and an MVCC analysis needs them.
%  - Each class of each dataset that is read has one file per subject: as
%    many files as cfg.study.dataFiles{1,1}.
%  - The files are .mat or .set files.
%  - With supertrials, cfg.trialaver.ntrials is at least 1.
%  - A sliding filter analysis needs cfg.sf.filesLocation.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (see mvpalab_preparestudy).

files = cfg.study.dataFiles;
nsub = numel(files{1,1});
mvcc = strcmp(cfg.analysis,'MVCC');

%% Dataset B:
filled = ~cellfun(@isempty,files(2,:));
if any(filled) && ~all(filled)
    error('In MVCC, dataset B needs the same classes as dataset A.');
end
if mvcc && ~any(filled)
    error('MVCC needs the files of dataset B in cfg.study.dataFiles(2,:).');
end

%% Files of each class:
for dataset = 1 : 1 + mvcc
    for condition = 1 : size(files,2)
        if numel(files{dataset,condition}) ~= nsub
            error(['cfg.study.dataFiles{%d,%d} has %d files and ' ...
                'cfg.study.dataFiles{1,1} has %d: each class needs one ' ...
                'file per subject.'],dataset,condition,numel(files{dataset,condition}),nsub);
        end
        [~,~,ext] = cellfun(@fileparts,files{dataset,condition},'UniformOutput',false);
        unknown = find(~ismember(lower(ext),{'.mat','.set'}),1);
        if ~isempty(unknown)
            error('Only .mat and .set files are supported: %s.',...
                files{dataset,condition}{unknown});
        end
    end
end

%% Supertrials:
if cfg.trialaver.flag && cfg.trialaver.ntrials < 1
    error('cfg.trialaver.ntrials must be at least 1 to average trials.');
end

%% Sliding filter:
if cfg.sf.flag && isempty(cfg.sf.filesLocation)
    error('cfg.sf.filesLocation must be the folder for the filtered data.');
end

end
