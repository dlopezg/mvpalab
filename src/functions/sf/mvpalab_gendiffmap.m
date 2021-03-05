function [diffMap,perdiffMap,cfg] = mvpalab_gendiffmap(cfg,acc,accmap,peracc,permaps)

fprintf('<strong> > Generating diffmaps... </strong>');

n_freq = size(permaps,5);
n_maps = size(permaps,4);

%% Generate diffMap for real data and permuted diffMaps for statistics:
for freq = 1 : n_freq
    diffMap.(cfg.sf.metric)(freq,:,:) = squeeze(acc - accmap(:,:,:,freq));
    
    % Generate permuted diffMaps for statistics if nedeed:
    if nargin > 3
        for map = 1 : n_maps
            perdiffMap.(cfg.sf.metric)(freq,:,:,map) = ...
                squeeze(peracc) - squeeze(permaps(:,:,:,map,freq));
        end
    end
end

fprintf('Done.\n');

end

