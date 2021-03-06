function [ stats ] = mvpalab_permtest( cfg, performance, permuted_maps )
%% Loop over different performance metrics:
fields = fieldnames(performance);
validfields = {'acc' 'auc' 'precision' 'recall' 'f1score'};

% Enable statistics:
cfg.stats.flag = 1;

% For each field:
for i = 1 : numel(fields)
    if find(strcmp(validfields, fields{i}))
        
        % Extract performance metric and the associated permuted maps:
        performance_ = performance.(fields{i});
        permuted_maps_ = permuted_maps.(fields{i});
        
        % If metric is precision, recall or f1 score, loop over classes:
        if find(strcmp(validfields(3:end), fields{i}))
            temp = performance_;
            temp_ = permuted_maps_;
            subfields = fieldnames(temp);
            
            for j = 1 : numel(subfields)
                performance_ = performance_.(subfields{j});
                permuted_maps_ = permuted_maps_.(subfields{j});
                
                fprintf(['<strong> > Permutation test (' fields{i} ...
                    ' > ' subfields{j} '): </strong>\n']);
                
                % MVCC
                if isstruct(performance_)
                    fprintf('<strong>   - Direction: A-B </strong>\n');
                    stats.(fields{i}).(subfields{j}).ab = mvpalab_computepermtest(...
                        cfg,performance_.ab,permuted_maps_.ab);
                    fprintf('<strong>   - Direction: B-A </strong>\n');
                    stats.(fields{i}).(subfields{j}).ba = mvpalab_computepermtest(...
                        cfg,performance_.ba,permuted_maps_.ba);
                    % MVPA
                else
                    stats.(fields{i}).(subfields{j}) = mvpalab_computepermtest(...
                        cfg,performance_,permuted_maps_);
                end
                
                
                performance_ = temp;
                permuted_maps_ = temp_;
            end
        else
            fprintf(['<strong> > Permutation test (' fields{i} ...
                '): </strong>\n']);
            
            % MVCC
            if isstruct(performance_)
                
                fprintf('<strong>   - Direction: A-B </strong>\n');
                stats.(fields{i}).ab = mvpalab_computepermtest(...
                    cfg,performance_.ab,permuted_maps_.ab);
                
                fprintf('<strong>   - Direction: B-A </strong>\n');
                stats.(fields{i}).ba = mvpalab_computepermtest(...
                    cfg,performance_.ba,permuted_maps_.ba);
                % MVPA
            else
                stats.(fields{i}) = mvpalab_computepermtest(...
                    cfg,performance_,permuted_maps_);
            end
        end
    end
end

%% Save data:
fprintf('<strong> > Saving results... </strong>\n');

if ~cfg.sf.flag
    mvpalab_savestats(cfg,stats);
end

fprintf('<strong> > Permutation test finished!</strong>\n');

end

