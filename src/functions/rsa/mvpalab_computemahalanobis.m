function rdm = mvpalab_computemahalanobis(data, cov_matrix)
%% MVPALAB_COMPUTEMAHALANOBIS
%
%   This function computes the Representational Dissimilarity Matrix with Mahalanobis distance.
%
%%  INPUT:
%
%  - {2D-matrix} - data:
%    Data matrix for an individual subject containing all the trials and
%    conditions. [trials x channels]
%
%  - {2D-matrix} - cov_matrix:
%    
%
%%  OUTPUT:
%
%  - {2D-matrix} - rdm:
%    Representational Dissimilarity Matrix:
%    An m-by-m matrix where each element rdm(i,j) is the Mahalanobis distance between data(i,:) and data(j,:)
%    [trials x trials] or [n_conditions x n_conditions]

% Ensure data is a matrix
if size(data, 1) == 1
    data = data';
end

% Calculate the mean of the data
mean_data = mean(data, 1);

% Center the data
centered_data = data - mean_data;

% Calculate the inverse of the covariance matrix
inv_cov_matrix = pinv(cov_matrix);

% Initialize the distance matrix
n = size(data, 1);
rdm = zeros(n, n);

% Calculate the Mahalanobis distance for all pairs of points
for i = 1:n
    for j = i:n
        diff = centered_data(i, :) - centered_data(j, :);
        rdm(i, j) = sqrt(diff * inv_cov_matrix * diff');
        rdm(j, i) = rdm(i, j); % Symmetric distance
    end
end
end
