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

path = cfg.study.dataPaths{dataset,condition};
file = cfg.study.dataFiles{dataset,condition}{sub};
[~,~,ext] = fileparts(file);

try
    if strcmpi(ext,'.set')
        input.data = pop_loadset(file,path);
    else
        input = load([path file]);
    end
catch loaderror
    error('Unable to load %s: %s',[path file],loaderror.message);
end

EEG = mvpalab_dataformat(input);

end
