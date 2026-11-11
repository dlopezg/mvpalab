function mvpalab_validatestudy(cfg)
%% MVPALAB_VALIDATESTUDY
%
%  This function checks the files of the study before any of them is read,
%  so the import stops with a clear error:
%
%  - Each class of each dataset that is read has one file per subject: as
%    many files as cfg.study.dataFiles{1,1}.
%  - The files are .mat or .set files.
%  - A sliding filter analysis needs cfg.sf.filesLocation.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.

files = cfg.study.dataFiles;
nsub = numel(files{1,1});
mvcc = mvpalab_ismvcc(cfg);

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

%% Sliding filter:
if cfg.sf.flag && isempty(cfg.sf.filesLocation)
    error('cfg.sf.filesLocation must be the folder for the filtered data.');
end

end
