function projected_data = mvpalab_project(input_data,params,cfg)
%PROJECT_PCA Summary of this function goes here
%   Detailed explanation goes here
input_data = input_data - params.mu;  % Xcentered
projected_data = input_data/params.coeff';   % Projected scores
projected_data = projected_data(:,1:cfg.dimred.ncomp,:);
end

