%% MVPAlab - configuration of the M/EEG-fMRI fusion demo.
%  Only the settings of this demo: the rest keep the values of
%  mvpalab_init, where every option is documented.

cfg.analysis = 'fusion_target';

%% Fusion:

cfg.fusion.mode = 'mean-fmri';

%% RDMs of the M/EEG and of the fMRI regions, as the RSA demos save them:
%  run demos/rsa/time_resolved/rsa_tr_demo.m and demos/rsa/roi/rsa_roi_demo.m
%  first. Each file is the rdms/result.mat of an RSA (condition-wise in
%  M/EEG): the RDMs in result.rdm and the names of the conditions in
%  result.conditions. The fusion pairs the conditions by their position
%  and shows the pairs, so check that they match.

eegfolder = fullfile('..','rsa','time_resolved','results',...
    'rsa-time-resolved','multiple_regress','pearson');
fmrifolder = fullfile('..','rsa','roi','results','rsa-roi','corr',...
    'euclidean');

temp = load(fullfile(eegfolder,'rdms','result.mat'));
meeg_rdms = temp.result;
cfg.tm.times = temp.cfg.tm.times;

regions = {'bin_rwVVC_bilateral','bin_rwM1_bilateral',...
    'bin_rwA1_bilateral','bin_rwPSL_bilateral','bin_rwRSC_bilateral',...
    'bin_rwSFL_bilateral'};
for r = 1 : numel(regions)
    file = fullfile(fmrifolder,regions{r},'rdms','result.mat');
    temp = load(file,'result');
    fmri_rdms.(regions{r}) = temp.result;
end

clear eegfolder fmrifolder regions r file temp

%% Shared permutation test, run inside the fusion:

cfg.stats.flag = true;
cfg.stats.nper = 5000;  % Shared permutations, one null map each.
