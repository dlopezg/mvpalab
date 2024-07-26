% Load the results
sub = 1;
% Select the slice index from the voxel coordinates based on the view
slice_index = 57;
view = "s";

% Load the results for the specified subject (the name for sub 1 is sl_sub1)
results = load(fullfile('results/fusion_cue/pearson/', ['sl_sub' num2str(sub)], 'result.mat'));
result = results.result;
cfg = results.cfg;
vc = cfg.searchlight_vcs;
% only get the coordinates for the current subject
voxel_coordinates = vc{sub};

% Initialize and configure plots
graph = mvpalab_plotinit();

% Plot configuration
graph.xlim = [-500 2000];
graph.ylim = [-.3 .5];
graph.xlabel = 'Time (ms)';
graph.ylabel = 'Spearman correlation';
graph.title = 'EEG-fMRI fusion';
graph.chanlvl = 0;
graph.smoothdata = 10;
graph.fontsize = 20;
graph.shadealpha = .9;
graph.linestyle = 'none';
colormap = 'aguamarine';
graph.colorSch = graph.colors.(colormap);
graph.colorMap = graph.grads.(colormap);
graph.stats.above = true;
graph.stats.below = true;

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

% Assuming 'result' is a 3D array where the third dimension's size can vary
% Determine the size of the third dimension dynamically
num_tp = size(result, 2);

% Initialize a 3D matrix to hold the RDM values for the slice
% The third dimension is now dynamically set based on the actual RDM vector size
max_coord1 = max(cellfun(@(v) v(coord1_dir), voxel_coordinates));
max_coord2 = max(cellfun(@(v) v(coord2_dir), voxel_coordinates));
slice_rdm_values = nan(max_coord1, max_coord2, num_tp); % Use NaN for empty voxels/vectors

% Iterate through each matching voxel index
for i = 1:length(matching_voxel_indices)
    coord1 = voxel_coordinates{matching_voxel_indices(i)}(coord1_dir);
    coord2 = voxel_coordinates{matching_voxel_indices(i)}(coord2_dir);
    % Get the RDMs for the current voxel
    current_rdms = result(:,:,matching_voxel_indices(i));

    % Ensure current_rdms is a vector. If not, adjust accordingly.
    % Add the RDM values to the slice_rdm_values matrix
    slice_rdm_values(coord1, coord2, :) = current_rdms;
end

%min_val = min(slice_rdm_values(:));
%max_val = max(slice_rdm_values(:));
min_val = -1;
max_val = 1;

% Plot video with rotated matrix
figure;
for i = 1:num_tp
    rotated_slice = rot90(slice_rdm_values(:,:,i)); % Rotate the matrix 90 degrees counterclockwise
    imagesc(rotated_slice); % Adjust this line to your desired plot function
    clim([min_val, max_val]); % Set the color scale limits
    colorbar;
    title(['Time = ' num2str(cfg.tm.times(i)) ' sec.']);
    xlabel('Coordinate 1');
    ylabel('Coordinate 2');
    axis equal;
    if (i == 1); title('Press any key to start video'); pause; end
    pause(0.01);
end