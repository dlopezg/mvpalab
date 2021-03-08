function [cfg,diffMap,perdiffMap] = mvpalab_gendiffmap(cfg,acc,accmap,peracc,permaps)

fprintf('<strong> > Generating diffmaps... </strong>');

if strcmp(cfg.analysis,'MVPA')
    n_freq = size(accmap,5);
    n_maps = size(accmap,4);
elseif strcmp(cfg.analysis,'MVCC')
    n_freq = size(accmap.ab,5);
    n_maps = size(accmap.ab,4);
end

%% Generate diffMap for real data and permuted diffMaps for statistics:
for freq = 1 : n_freq
    if strcmp(cfg.analysis,'MVPA')
        diffMap.(cfg.sf.metric)(freq,:,:) = squeeze(acc - accmap(:,:,:,freq));
    elseif strcmp(cfg.analysis,'MVCC')
        diffMap.(cfg.sf.metric).ab(freq,:,:) = ...
            squeeze(acc.ab - accmap.ab(:,:,:,freq));
        diffMap.(cfg.sf.metric).ba(freq,:,:) = ...
            squeeze(acc.ba - accmap.ba(:,:,:,freq));
    end
    
    % Generate permuted diffMaps for statistics if nedeed:
    if nargin > 3
        for map = 1 : n_maps
            if strcmp(cfg.analysis,'MVPA')
                perdiffMap.(cfg.sf.metric)(freq,:,:,map) = ...
                    squeeze(peracc) - squeeze(permaps(:,:,:,map,freq));
            elseif strcmp(cfg.analysis,'MVCC')
                perdiffMap.(cfg.sf.metric).ab(freq,:,:,map) = ...
                    squeeze(peracc.ab) - squeeze(permaps.ab(:,:,:,map,freq));
                perdiffMap.(cfg.sf.metric).ba(freq,:,:,map) = ...
                    squeeze(peracc.ba) - squeeze(permaps.ba(:,:,:,map,freq));
            end
        end
    end
end

fprintf('Done.\n');

end

