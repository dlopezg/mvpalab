function [cfg,diffMap,perdiffMap] = mvpalab_gendiffmap(cfg,acc,accmap,peracc,permaps)

fprintf('<strong> > Generating diffmaps... </strong>');

%% Generate diffMap for real data and permuted diffMaps for statistics:
for freq = 1 : length(cfg.sf.freqvec)
    if strcmp(cfg.analysis,'MVPA')
        diffMap.(cfg.sf.metric)(freq,:,:) = squeeze(accmap(:,:,:,freq) - acc);
    elseif strcmp(cfg.analysis,'MVCC')
        diffMap.(cfg.sf.metric).ab(freq,:,:) = ...
            squeeze(accmap.ab(:,:,:,freq) - acc.ab);
        diffMap.(cfg.sf.metric).ba(freq,:,:) = ...
            squeeze(accmap.ba(:,:,:,freq) - acc.ba);
    end
    
    % Generate permuted diffMaps for statistics if nedeed:
    if nargin > 3
        for map = 1 : cfg.stats.nper
            if strcmp(cfg.analysis,'MVPA')
                perdiffMap.(cfg.sf.metric)(freq,:,:,map) = ...
                    squeeze(permaps(:,:,:,map,freq)) - squeeze(peracc);
            elseif strcmp(cfg.analysis,'MVCC')
                perdiffMap.(cfg.sf.metric).ab(freq,:,:,map) = ...
                    squeeze(permaps.ab(:,:,:,map,freq)) - squeeze(peracc.ab);
                perdiffMap.(cfg.sf.metric).ba(freq,:,:,map) = ...
                    squeeze(permaps.ba(:,:,:,map,freq)) - squeeze(peracc.ba);
            end
        end
    end
end

fprintf('Done.\n');

end

