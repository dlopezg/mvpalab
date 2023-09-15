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

% Bug fix: dimensionality problem for single subject analysis:
% When only one subject is selected for the analysis the singleton
% dimension is automatically squeezed by MATLAB causing dimensionality
% problems. This problems are solved here.

if strcmp(cfg.analysis,'MVPA')
    diffMap.(cfg.sf.metric) = squeeze(diffMap.(cfg.sf.metric));
else
    diffMap.(cfg.sf.metric).ab = squeeze(diffMap.(cfg.sf.metric).ab);
    diffMap.(cfg.sf.metric).ba = squeeze(diffMap.(cfg.sf.metric).ba);
end

if nargin > 3
    if strcmp(cfg.analysis,'MVPA') && size(perdiffMap.(cfg.sf.metric),2) == 1
        perdiffMap.(cfg.sf.metric) = permute(perdiffMap.(cfg.sf.metric),[1 3 2 4]);
    elseif strcmp(cfg.analysis,'MVCC') && size(perdiffMap.(cfg.sf.metric).ab,2) == 1
        perdiffMap.(cfg.sf.metric).ab = permute(perdiffMap.(cfg.sf.metric).ab,[1 3 2 4]);
        perdiffMap.(cfg.sf.metric).ba = permute(perdiffMap.(cfg.sf.metric).ba,[1 3 2 4]);
    end
end


fprintf('Done.\n');

end

