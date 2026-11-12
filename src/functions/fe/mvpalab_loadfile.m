function EEG = mvpalab_loadfile(cfg,dataset,condition,sub)
%% MVPALAB_LOADFILE
%
%  This function loads the file of one subject, dataset and class of
%  cfg.study.dataFiles (a .mat file, or a .set file with EEGLAB) and
%  returns its data in the format used by MVPAlab (see
%  mvpalab_dataformat). If the file cannot be loaded, the error names it.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.study).
%
%  - {int} - dataset:
%    Dataset: 1 (A) or 2 (B).
%
%  - {int} - condition:
%    Class.
%
%  - {int} - sub:
%    Subject.
%
%%  OUTPUT:
%
%  - {struct} - EEG:
%    Data of the file (see mvpalab_dataformat).

folder = cfg.study.dataPaths{dataset,condition};
file = cfg.study.dataFiles{dataset,condition}{sub};
[~,~,ext] = fileparts(file);

try
    if strcmpi(ext,'.set')
        input.data = pop_loadset(file,folder);
    else
        input = load(fullfile(folder,file));
    end
catch loaderror
    error('mvpalab:loadfile',...
        'Unable to load %s: %s',fullfile(folder,file),loaderror.message);
end

EEG = mvpalab_dataformat(input);

end
