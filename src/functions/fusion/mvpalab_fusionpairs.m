function [veeg,vfmri] = mvpalab_fusionpairs(cfg,eeg_rdms,fmri_rdms)
%% MVPALAB_FUSIONPAIRS
%
%  This function returns the pairs of RDMs of one region that a fusion
%  analysis correlates, one pair per observation, as set in
%  cfg.fusion.mode:
%
%  - 'mean-fmri': the mean fMRI RDM with the RDM of each M/EEG subject.
%  - 'mean-eeg': the mean M/EEG RDM with the RDM of each fMRI subject.
%
%  Each RDM is vectorized once (see mvpalab_vectorizerdm).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.fusion.mode).
%
%  - {cell array} - eeg_rdms:
%    RDM of each M/EEG subject [conditions x conditions x timepoints].
%
%  - {cell array} - fmri_rdms:
%    RDM of each fMRI subject of the region [conditions x conditions].
%
%%  OUTPUT:
%
%  - {cell array} - veeg:
%    Vectorized M/EEG RDM of each observation [timepoints x pairs].
%
%  - {cell array} - vfmri:
%    Vectorized fMRI RDM of each observation [pairs x 1].

vectorize = @(rdms) cellfun(@mvpalab_vectorizerdm,rdms,'UniformOutput',false);

switch cfg.fusion.mode
    case 'mean-fmri'
        veeg = vectorize(eeg_rdms);
        vfmri = repmat({mvpalab_vectorizerdm(mvpalab_meanrdm(fmri_rdms))'},size(veeg));
    case 'mean-eeg'
        vfmri = cellfun(@(v) v',vectorize(fmri_rdms),'UniformOutput',false);
        veeg = repmat({mvpalab_vectorizerdm(mvpalab_meanrdm(eeg_rdms))},size(vfmri));
end

end
