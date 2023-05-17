function [X, cfg] = mvpalab_chanselection(X,cfg)

%% MVPALAB_CHANSELECTION
%
%  This function extracs the selected electrodes from the entire dataset
%  
%  INPUT:
%
%  - cfg: (STRUCT) Configuration estructure. 
%
%  - X :  (3D-MATRIX) Data matrix [trials x electrodes x timepoint]
%
%  OUTPUT:
%
%  - X :  (3D-MATRIX) Data matrix including the selected electrodes:
%         [trials x electrodes x timepoint]
%  - cfg: (STRUCT) Updated cfg structure.
%

%% Initialization:

% Define the selected electrodes location:
cfg.channels.selectedchanloc = cfg.channels.chanloc;
selected = cfg.channels.selected;

%% Electrode selection:

% Check if the selected channel vector is not empty
if ~isempty(selected)
    % Check dimension mismatch:
    if max(selected) <= size(X,2)
        % Update data matrix:
        X = X(:,selected,:);
        % Update selected electrodes location:
        cfg = mvpalab_updatechanloc(selected, cfg);
        
    else
        warning('Channel selection fails: Dimension mismatch')
    end
end
end

