%% MVPAlab - configuration of the M/EEG-fMRI fusion demo.
%  Only the settings of this demo: the rest keep the values of
%  mvpalab_init, where every option is documented.

cfg.analysis = 'fusion_cue';

%% Fusion:

cfg.fusion.mode = 'mean-fmri';

%% RDMs of the fMRI regions (also bin_rwA1_bilateral, bin_rwPSL_bilateral,
%  bin_rwRSC_bilateral and bin_rwSFL_bilateral) and of the M/EEG:

folder = fullfile('data','rdms');
regions = {'bin_rwM1_bilateral','bin_rwVVC_bilateral'};
for r = 1 : numel(regions)
    temp = load(fullfile(folder,'fmri',regions{r},'result.mat'),'result');
    fmri_rdms.(regions{r}) = temp.result;
end

temp = load(fullfile(folder,'eeg','result.mat'));
meeg_rdms = temp.result;
cfg.tm.times = temp.cfg.tm.times;

clear folder regions r temp

%% Shared permutation test, run inside the fusion:

cfg.stats.flag = true;
cfg.stats.nper = 5000;  % Shared permutations, one null map each.
