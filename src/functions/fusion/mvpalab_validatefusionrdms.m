function mvpalab_validatefusionrdms(eeg_rdms,fmri_rdms)
%% MVPALAB_VALIDATEFUSIONRDMS
%
%  This function checks the RDMs of a fusion analysis before it starts
%  (see mvpalab_fusion). The settings are checked by
%  mvpalab_validatefusion.
%
%  - The M/EEG RDMs and the RDMs of each fMRI region are the field rdms of
%    the result of an RSA (mvpalab_rsa_time, mvpalab_rsa_roi), with the
%    RDM of each subject in rdm and the names of the conditions in
%    conditions.
%  - Every RDM has one row and one column per condition, and both
%    modalities have the same number of conditions. Trial-wise M/EEG RDMs
%    (cfg.rsa.trialwise) have one row per trial and cannot be fused.
%
%  The names of the conditions are not compared: they can be different in
%  the two modalities, and mvpalab_fusion shows the pairs.
%
%%  INPUT:
%
%  - {struct} - eeg_rdms:
%    RDMs of the M/EEG subjects (see mvpalab_fusion).
%
%  - {struct} - fmri_rdms:
%    RDMs of the fMRI subjects of each region (see mvpalab_fusion).

checkset(eeg_rdms,'The M/EEG RDMs','mvpalab_rsa_time');
nconds = numel(eeg_rdms.conditions);

regions = fieldnames(fmri_rdms);
for roi = 1 : numel(regions)
    name = ['The RDMs of the region ' regions{roi}];
    checkset(fmri_rdms.(regions{roi}),name,'mvpalab_rsa_roi');
    if numel(fmri_rdms.(regions{roi}).conditions) ~= nconds
        error('mvpalab:validatefusionrdms',...
            '%s have %d conditions and the M/EEG RDMs %d.',name,...
            numel(fmri_rdms.(regions{roi}).conditions),nconds);
    end
end

end

function checkset(rdms,name,analysis)
%% One set of RDMs: rdm and conditions, one row and column per condition.

if ~isstruct(rdms) || ~all(isfield(rdms,{'rdm','conditions'}))
    error('mvpalab:validatefusionrdms',...
        ['%s must be the field rdms of the result of %s, with the RDMs ' ...
        'in rdm and the names of the conditions in conditions.'],...
        name,analysis);
end

nconds = numel(rdms.conditions);
for sub = 1 : numel(rdms.rdm)
    [rows,cols,~] = size(rdms.rdm{sub});
    if rows ~= nconds || cols ~= nconds
        error('mvpalab:validatefusionrdms',...
            ['%s of subject %d are [%d x %d] and there are %d ' ...
            'conditions. The fusion needs condition-wise RDMs ' ...
            '(cfg.rsa.trialwise = false in the RSA).'],...
            name,sub,rows,cols,nconds);
    end
end

end
