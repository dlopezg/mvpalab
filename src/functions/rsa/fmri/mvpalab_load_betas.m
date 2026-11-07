function betas = mvpalab_load_betas(folder,conditions_to_extract)
%% MVPALAB_LOAD_BETAS
%
%  This function loads the beta images of the specified conditions from a
%  first-level SPM model: one beta per condition and run (session).
%
%  - Selection: SPM describes each beta as 'Sn(k) name*bf(j)', where k is
%    the session and j the basis function. A beta is selected when its
%    regressor name is exactly the name of the condition and it is the
%    first basis function (bf(1), the canonical HRF). Other betas whose
%    description contains the name of the condition are not selected:
%    derivatives of the HRF (bf(2), bf(3)), parametric modulators
%    ('namexmod^1') and conditions whose name starts with the name of
%    another condition ('cond1' and 'cond10').
%
%  - Runs: the betas are arranged by session, so column r is the same run
%    for all the conditions. The runs are the sessions that include any of
%    the specified conditions. The runs are the folds of the
%    leave-one-run-out cross-validation (see mvpalab_rsa_roi), so each
%    condition must have exactly one beta in each run; an error is raised
%    otherwise.
%
%%  INPUT:
%
%  - {string} - folder:
%    Folder of the first-level model, including the SPM.mat file and the
%    beta images.
%
%  - {cell array} - conditions_to_extract:
%    Names of the conditions (regressor names of the SPM model).
%
%%  OUTPUT:
%
%  - {cell array} - betas:
%    Beta images [conditions x runs]. Each cell is a struct with the
%    fields of mvpalab_read_nifti, the name of the regressor (regressor)
%    and the session of the SPM model (session).

load(fullfile(folder,'SPM.mat'),'SPM');

%% Extract beta files and info:
betas_fname = {SPM.Vbeta.fname};
betas_descrip = {SPM.Vbeta.descrip};

%% Session, regressor name and basis function of each beta:
%  Description of a beta: 'spm_spm:beta (0001) - Sn(1) name*bf(1)'. Betas
%  without basis function (e.g. the constant of each session) are ignored.

tokens = regexp(betas_descrip,'Sn\((\d+)\) (.*)\*bf\((\d+)\)$','tokens','once');
valid = ~cellfun(@isempty,tokens);

session = nan(size(tokens));
name = repmat({''},size(tokens));
bf = nan(size(tokens));

session(valid) = cellfun(@(t) str2double(t{1}),tokens(valid));
name(valid) = cellfun(@(t) t{2},tokens(valid),'UniformOutput',false);
bf(valid) = cellfun(@(t) str2double(t{3}),tokens(valid));

%% Selected betas: exact regressor name and first basis function:

selected = valid & bf == 1 & ismember(name,conditions_to_extract);
sessions = unique(session(selected));

if isempty(sessions)
    error(['None of the conditions was found in the SPM model of %s. ' ...
        'The names must be the regressor names of the model.'],folder);
end

%% Import the required beta files:
for cond = 1 : length(conditions_to_extract)

    % Extract regressor name:
    regressor_name = conditions_to_extract{cond};

    for run = 1 : length(sessions)

        % Beta of this condition in this session:
        idx = find(selected & strcmp(name,regressor_name) & ...
            session == sessions(run));

        if numel(idx) ~= 1
            error(['Condition ''%s'' has %d betas (first basis ' ...
                'function) in session %d of the SPM model of %s. Each ' ...
                'condition needs exactly one beta in each session that ' ...
                'includes any of the conditions (sessions: %s).'], ...
                regressor_name,numel(idx),sessions(run),folder, ...
                mat2str(sessions));
        end

        betas{cond,run} = mvpalab_read_nifti(fullfile(folder,betas_fname{idx}));
        betas{cond,run}.regressor = regressor_name;
        betas{cond,run}.session = sessions(run);
    end

end

end
