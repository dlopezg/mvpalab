function [mean_rdm] = mvpalab_meanrdm(cellarray)

nsub = length(cellarray);
[ncond,~,ntp] = size(cellarray{1});

% Compute the mean RDM:
mean_rdm = squeeze(mean(reshape(cell2mat(cellarray),[ncond,ncond,nsub,ntp]),3));

end

