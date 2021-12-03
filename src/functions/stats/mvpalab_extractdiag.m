function [per,permaps,stats] = mvpalab_extractdiag(cfg,performance,permuted_maps)

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

fprintf('<strong> > Extracting time resolved diagonal: </strong>');

cfg.classmodel.tempgen = false;
%% Loop over different performance metrics:
fields = fieldnames(performance);
validfields = {'acc' 'auc' 'precision' 'recall' 'f1score'};

% For each field:
for i = 1 : numel(fields)
    if find(strcmp(validfields, fields{i}))
        % Extract performance metric:
        performance_ = performance.(fields{i});
        % Extract permuted maps if needed:
        if nargin > 2
            permuted_maps_ = permuted_maps.(fields{i});
        end
        
        % If metric is precision, recall or f1 score, loop over classes:
        if find(strcmp(validfields(3:end), fields{i}))
            % Extract performance metric:
            temp = performance_;
            % Extract permuted maps if needed:
            if nargin > 2
                temp_ = permuted_maps_;
            end
            subfields = fieldnames(temp);
            
            % For each subfield:
            for j = 1 : numel(subfields)
                performance_ = performance_.(subfields{j});
                
                if nargin > 2
                    permuted_maps_ = permuted_maps_.(subfields{j});
                end
                
                % MVCC
                if isstruct(performance_)
                    % Extract diagonal (results)  - Both directions
                    for k = 1 : size(performance_.ab,3)
                        per.(fields{i}).(subfields{j}).ab(1,:,k) = diag(performance_.ab(:,:,k));
                        per.(fields{i}).(subfields{j}).ba(1,:,k) = diag(performance_.ba(:,:,k));
                    end
                    % Extract diagonal (permuted maps)  - Both directions:
                    if nargin > 2
                        for k = 1 : size(permuted_maps_.ab,4)
                            for l = 1 : size(permuted_maps_.ab,3)
                                permaps.(fields{i}).(subfields{j}).ab(1,:,l,k) = diag(permuted_maps_.ab(:,:,l,k));
                                permaps.(fields{i}).(subfields{j}).ba(1,:,l,k) = diag(permuted_maps_.ba(:,:,l,k));
                            end
                        end
                    end
                    % MVPA
                else
                    % Extract diagonal (results):
                    for k = 1 : size(performance_,3)
                        per.(fields{i}).(subfields{j})(1,:,k) = diag(performance_(:,:,k));
                    end
                    % Extract diagonal (permuted maps)
                    if nargin > 2
                        for k = 1 : size(permuted_maps_,4)
                            for l = 1 : size(permuted_maps_,3)
                                permaps.(fields{i}).(subfields{j})(1,:,l,k) = diag(permuted_maps_(:,:,l,k));
                            end
                        end
                    end
                end
                performance_ = temp;
                
                if nargin > 2
                    permuted_maps_ = temp_;
                end
            end
        else
            % MVCC
            if isstruct(performance_)
                % Extract diagonal (results) - Both directions:
                for k = 1 : size(performance_.ab,3)
                    per.(fields{i}).ab(1,:,k) = diag(performance_.ab(:,:,k));
                    per.(fields{i}).ba(1,:,k) = diag(performance_.ba(:,:,k));
                end
                % Extract diagonal (permuted maps) - Both directions:
                if nargin > 2
                    for k = 1 : size(permuted_maps_.ab,4)
                        for l = 1 : size(permuted_maps_.ab,3)
                            permaps.(fields{i}).ab(1,:,l,k) = diag(permuted_maps_.ab(:,:,l,k));
                            permaps.(fields{i}).ba(1,:,l,k) = diag(permuted_maps_.ba(:,:,l,k));
                        end
                    end
                end
            else
                % Extract diagonal (results):
                for k = 1 : size(performance_,3)
                    per.(fields{i})(1,:,k) = diag(performance_(:,:,k));
                end
                
                % Extract diagonal (permuted maps)
                if nargin > 2
                    for k = 1 : size(permuted_maps_,4)
                        for l = 1 : size(permuted_maps_,3)
                            permaps.(fields{i})(1,:,l,k) = diag(permuted_maps_(:,:,l,k));
                        end
                    end
                end
            end
        end
    end
end

fprintf(' > Done! ');
fprintf('\n\n');

%% Permutations tests and save result:
mvpalab_saveresults(cfg,per);
if nargin > 2
    mvpalab_savepermaps(cfg,permaps);
    stats = mvpalab_permtest(cfg,per,permaps);
end
end

