function projected_data = project_pca(input_data,params,cfg)
%PROJECT_PCA Summary of this function goes here
%   Detailed explanation goes here
input_data = input_data - params.mu;  % Xcentered
projected_data = input_data/params.coeff';   % Projected scores
projected_data = projected_data(:,1:cfg.pca.ncom,:);
end

