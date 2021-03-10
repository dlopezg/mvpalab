function [cfg,diffMap,perdiffMap] = mvpalab_gendiffmap(cfg,acc,accmap,peracc,permaps)

fprintf('<strong> > Generating diffmaps... </strong>');

%% Generate diffMap for real data and permuted diffMaps for statistics:
for freq = 1 : length(cfg.sf.freqvec)
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
        for map = 1 : cfg.stats.nper
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

