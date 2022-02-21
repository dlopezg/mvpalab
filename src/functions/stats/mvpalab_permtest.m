function [ stats ] = mvpalab_permtest( cfg, performance, permuted_maps )
%% Extract valid field:
%  Not all fields contained in the result structure are compatible with a
%  permutation test (e.g weight verctors, theoretical RDMs, etc).

fields = fieldnames(performance);
validfields = {'acc' 'auc' 'precision' 'recall' 'f1score' 'pearson' 'euclidean'};

%% Enable statistics:
%  Just to be sure that it is enabled.

cfg.stats.flag = 1;

%% Fields loop:
%  A field is ommited if it is not contained in the valid list.

for i = 1 : numel(fields)
    
    if find(strcmp(validfields, fields{i}))
        %% Extract performance metric and the associated permuted maps:
        
        performance_ = performance.(fields{i});
        permuted_maps_ = permuted_maps.(fields{i});
        
        %% Multilevel fields:
        
        if find(strcmp(validfields(3:end), fields{i}))
            
            temp = performance_;
            temp_ = permuted_maps_;
            subfields = fieldnames(temp);
            
            %% Loop over subfields:
            
            for j = 1 : numel(subfields)
                
                performance_ = performance_.(subfields{j});
                permuted_maps_ = permuted_maps_.(subfields{j});
                
                fprintf(['\n<strong> > Permutation test (' fields{i} ...
                    ' > ' subfields{j} '): </strong>\n']);
                
                
                if isstruct(performance_)
                    %% MVCC
                    fprintf('<strong>   - Direction: A-B </strong>\n');
                    stats.(fields{i}).(subfields{j}).ab = mvpalab_computepermtest(...
                        cfg,performance_.ab,permuted_maps_.ab);
                    fprintf('<strong>   - Direction: B-A </strong>\n');
                    stats.(fields{i}).(subfields{j}).ba = mvpalab_computepermtest(...
                        cfg,performance_.ba,permuted_maps_.ba);
                 
                else
                    %% MVPA or RSA
                    stats.(fields{i}).(subfields{j}) = mvpalab_computepermtest(...
                        cfg,performance_,permuted_maps_);
                end
                
                
                performance_ = temp;
                permuted_maps_ = temp_;
            end
        else
            fprintf(['<strong> > Permutation test (' fields{i} ...
                '): </strong>\n']);
            
            
            if isstruct(performance_)
                %% MVCC
                fprintf('<strong>   - Direction: A-B </strong>\n');
                stats.(fields{i}).ab = mvpalab_computepermtest(...
                    cfg,performance_.ab,permuted_maps_.ab);
                
                fprintf('<strong>   - Direction: B-A </strong>\n');
                stats.(fields{i}).ba = mvpalab_computepermtest(...
                    cfg,performance_.ba,permuted_maps_.ba);
                
            else
                %% MVPA or RSA
                stats.(fields{i}) = mvpalab_computepermtest(...
                    cfg,performance_,permuted_maps_);
            end
        end
    end
end

fprintf('\n<strong> > Permutation test finished!</strong>\n\n');

if ~cfg.sf.flag
    mvpalab_savestats(cfg,stats);
end


end

