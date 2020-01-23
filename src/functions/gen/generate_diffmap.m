function [diffMap,perdiffMap,cfg] = generate_diffmap(cfg,acc,accmap,peracc,permaps)

n_subjects = size(acc,3);
n_maps = size(permaps,3);
n_freq = size(accmap,1);


%% Generate diffMap for real data and permuted diffMaps for statistics:
for freq = 1 : n_freq
    diffMap(freq,:,:) = acc - accmap(freq,:,:);
    
    % Generate permuted diffMaps for statistics:
    if exist('permaps','var') && exist('peracc','var')
        for map = 1 : n_maps
            perdiffMap(freq,:,map,:) = squeeze(peracc) - squeeze(permaps(freq,:,map,:));
        end
    end
end




end

