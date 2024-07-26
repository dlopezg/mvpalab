% Initialize:
%  Initialize the plot utility.
%  Load the RDM for one subject and all voxels.
%  Select subject 1.

graph = mvpalab_plotinit();
result = load('results/RSA/pearson/sl_sub_1/rdms/result.mat');
graph.sub = 1;
graph.caxis = [-1 1];

% Import the voxel coordinates
vc = load('results/RSA/pearson/sl_sub_1/voxel_coordinates/result.mat');
voxel_coordinates = vc.result;

% Select the slice index from the voxel coordinates based on the view
slice_index = 57;
view = "f";

% Determine the indices for the specified view
if view == 's'
    x = 1;
    coord1_dir = 2;
    coord2_dir = 3;
elseif view == 'f'
    x = 2;
    coord1_dir = 1;
    coord2_dir = 3;
elseif view == 't'
    x = 3;
    coord1_dir = 1;
    coord2_dir = 2;
else
    error('Invalid view. Please enter "f", "t", or "s"');
end

% Initialize an empty array to hold the indices of voxels matching the slice_index in the first dimension
matching_voxel_indices = [];

% Iterate through each voxel's coordinates
for i = 1:length(voxel_coordinates)
    % Check if the first dimension matches slice_index
    if voxel_coordinates{i}(x) == slice_index
        % If it matches, add the index to the matching_voxel_indices array
        matching_voxel_indices = [matching_voxel_indices, i];
    end
end
% matching_voxel_indices now contains all indices of voxels where the first dimension is slice_index

% Initialize a matrix to hold the RDM values for the slice
max_coord1 = max(cellfun(@(v) v(coord1_dir), voxel_coordinates));
max_coord2 = max(cellfun(@(v) v(coord2_dir), voxel_coordinates));
slice_rdm_values = nan(max_coord1, max_coord2); % Use NaN for empty voxels

% Iterate through each matching voxel index
for i = 1:length(matching_voxel_indices)
    coord1 = voxel_coordinates{matching_voxel_indices(i)}(coord1_dir);
    coord2 = voxel_coordinates{matching_voxel_indices(i)}(coord2_dir);
    % Get the RDM for the current voxel
    current_rdm = result.result(:,:,matching_voxel_indices(i));
    % Calculate the mean value of the RDM (or another representative value)
    mean_rdm_value = mean(current_rdm(:));
    % Add the mean RDM value to the slice_rdm_values matrix
    slice_rdm_values(coord1, coord2) = mean_rdm_value;
end

% Plot the heatmap of the slice
figure;
imagesc(slice_rdm_values);
colorbar;
title(['Slice ', num2str(slice_index), ' RDM Heatmap (View: ', view, ')']);
xlabel('Coordinate 1');
ylabel('Coordinate 2');
axis equal;
% rotate image

