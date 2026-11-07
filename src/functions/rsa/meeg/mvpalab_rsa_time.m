function [res,stats,cfg] = mvpalab_rsa_time(cfg,fv)
%% MVPALAB_RSA_TIME
%
%  This function computes the time-resolved representational similarity
%  analysis of M/EEG data. For each subject it builds the supertrials
%  (mvpalab_supertrials), the RDM at each timepoint of cfg.tm.tpoints
%  (mvpalab_rdm) and the theoretical RDMs (mvpalab_gentrdms), and compares
%  them as set in cfg.rsa.modality:
%
%  - 'corr': Spearman correlation with each theoretical model, Fisher
%    z-transformed (mvpalab_computecorr).
%  - 'regress': a general linear model for each theoretical model
%    (mvpalab_fitglm).
%  - 'multiple_regress': one general linear model with all the theoretical
%    models as regressors (mvpalab_fitglm).
%
%  The values 3 and 4 of cfg.normdata have no effect in RSA (a warning is
%  shown). With cfg.stats.flag the permuted maps are computed and the
%  permutation test is run (mvpalab_permtest); with cfg.stats.signflip the
%  sign flip test is used instead (mvpalab_signmaps).
%
%  The results and the permuted maps are saved with mvpalab_save and the
%  statistics by mvpalab_permtest, except in a sliding filter analysis
%  (cfg.sf.flag). The configuration is saved with mvpalab_savecfg at the
%  start and at the end of the analysis.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - fv:
%    Feature vectors of each subject, with the data in X.a [trials x
%    channels x timepoints] and the labels in Y.a.
%
%%  OUTPUT:
%
%  - {struct} - res:
%    Results in res.(cfg.rsa.modality).(cfg.rsa.distance):
%    - One field per theoretical model (cfg.rsa.tmodels{i}.id): the
%      correlation [1 x timepoints x subjects] in 'corr', or the fields
%      bvalues and tvalues of the same size in 'regress' and
%      'multiple_regress'.
%    - rdms: Cell array with the RDM of each subject [conditions x
%      conditions x timepoints] or, with cfg.rsa.trialwise, [trials x
%      trials x timepoints].
%    - theo: Cell array with the theoretical RDMs of each subject (see
%      mvpalab_gentrdms).
%
%  - {struct} - stats:
%    Result of the permutation test (see mvpalab_permtest), empty without
%    cfg.stats.flag.
%
%  - {struct} - cfg:
%    Configuration structure, with the condition boundaries of each
%    subject in cfg.rsa.bounds (see mvpalab_findbound).

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);
mvpalab_savecfg(cfg);
mvpalab_checksignflip(cfg);

%% Initialize
stats = struct();
nsub = length(cfg.study.dataFiles{1,1});
mode = cfg.rsa.modality;
dist = cfg.rsa.distance;
permuted = cfg.stats.flag && ~cfg.stats.signflip;

%% Check the configuration:
%  Second-order analysis (see cfg.rsa.modality in mvpalab_init):

if ~any(strcmp(mode,{'corr','regress','multiple_regress'}))
    error(['RSA modality not recognized: ''%s''. Use ''corr'', ' ...
        '''regress'' or ''multiple_regress''.'],mode);
end

%  Data normalization: values 3 and 4 of cfg.normdata are applied within
%  the cross-validation folds of the classifiers (mvpalab_datanorm) and
%  have no effect in RSA. Values 1 and 2 are applied to each trial or
%  supertrial (mvpalab_adjustclasses).

if cfg.normdata >= 3
    warning(['cfg.normdata = %d is only applied by the classifiers ' ...
        '(MVPA and MVCC) and has no effect in RSA. Use cfg.normdata = 1 ' ...
        'or 2 (applied to each trial or supertrial) or 0.'],cfg.normdata);
end

%% Subjects loop:
%  Iterate along subjects:

for sub = 1 : nsub

    fprintf('\n<strong> > Computing RSA analysis: </strong>');
    fprintf(['- Subject: ' int2str(sub) '/' int2str(nsub) '\n\n']);
    tic;

    %%  Select datamatrix:
    %   Select subject data, labels and timepoints. The RDMs are computed
    %   once, so the supertrials are also built once per subject.

    mvpalab_checkfv(cfg,fv{sub});
    data.a.X = fv{sub}.X.a; data.a.Y = fv{sub}.Y.a;
    data = mvpalab_supertrials(cfg,data);
    X = data.a.X; Y = data.a.Y;
    X = X(:,:,cfg.tm.tpoints);

    %% Generate neural Representational Dissimilarity Matrices:
    %  This function returns 3D matrices containing the RDMs in a time
    %  resolved way:
    %  rdms - [trials x trials x timepoints]
    %  rdms - [conditions x conditions x timepoints]

    rdms{sub} = mvpalab_rdm(cfg,X,Y);

    %%  Find condition's boundaries for each subject:
    %   This functions returns the indexes of the last trials for each
    %   condition. This indexes can be used to plot conditions boundaries
    %   or to split the data.

    cfg.rsa.bounds{sub} = mvpalab_findbound(rdms{sub}.labels);

    %% Generate the theoretical RD matrices:
    %  Based on the previously designed models.
    %  theo - [n_conditions x n_conditions x 1 x models]
    %  theo - [n_trials x n_trials x 1 x models]

    theo{sub} = mvpalab_gentrdms(cfg,cfg.rsa.tmodels,rdms{sub}.labels);

    %% Vectorize RDMs:
    %  Both theoretical and empirical DRMs are vectorized in order to
    %  compute the Representational Similarity Analysis.
    %  vrdms - [timepoints x vectorized]
    %  vtheo - [1 x vectorized x models]

    vrdms{sub} = mvpalab_vectorizerdm(cfg,rdms{sub}.rdm);
    vtheo{sub} = mvpalab_vectorizerdm(cfg,theo{sub});

    %% Repeat theoretical matrices for each timepoint:
    %  vtheo - [timepoints x vectorized x models]

    vtheo{sub} = repmat(vtheo{sub},[size(vrdms{sub},1) 1 1]);

    %% Compute the Representational similarity analysis:

    %  Empirical and theoretical models are correlated to obtain the time
    %  resolved correlation coefficient.

    if strcmp(mode,'multiple_regress')

        [bval, tval] = mvpalab_fitglm(cfg,vrdms{sub},vtheo{sub},false);
         for mdl = 1:size(vtheo{sub},3)
             mname = cfg.rsa.tmodels{mdl}.id;
             res.(mode).(dist).(mname).bvalues(1,:,sub) = bval(1,:,1,1,mdl);
             res.(mode).(dist).(mname).tvalues(1,:,sub) = tval(1,:,1,1,mdl);
         end

        %% Compute permuted maps:
        %  Repeat the representational similarity analysis but permuting
        %  the empirical RDM if needed.

        if permuted
            [pbv,ptv] = mvpalab_fitglm(cfg,vrdms{sub},vtheo{sub},true);

             for mdl = 1:size(vtheo{sub},3)
                mname = cfg.rsa.tmodels{mdl}.id;
                permaps.(mode).(dist).(mname).bvalues(1,:,sub,:) = pbv(1,:,1,:,mdl);
                permaps.(mode).(dist).(mname).tvalues(1,:,sub,:) = ptv(1,:,1,:,mdl);
             end
        end
    else

        for mdl = 1 : size(vtheo{sub},3)

            fprintf(['\n<strong>   >> Model: '...
                cfg.rsa.tmodels{mdl}.id '</strong>\n']);

            % Select theoretical model:
            vtheo_mdl = vtheo{sub}(:,:,mdl);
            mname = cfg.rsa.tmodels{mdl}.id;

            % Analysis: Correlation or regression.
            if strcmp(mode,'corr')

                corr= mvpalab_computecorr(cfg,vrdms{sub},vtheo_mdl,false);
                res.(mode).(dist).(mname)(1,:,sub) = corr;

                %  A general linear model is fitted using the theoretical RDMs as
                %  regressors.

            elseif strcmp(mode,'regress')

                [bval, tval] = mvpalab_fitglm(cfg,vrdms{sub},vtheo_mdl,false);
                res.(mode).(dist).(mname).bvalues(1,:,sub) = bval;
                res.(mode).(dist).(mname).tvalues(1,:,sub) = tval;

            end

            %% Compute permuted maps:
            %  Repeat the representational similarity analysis but permuting
            %  the empirical RDM if needed.

            if permuted
                if strcmp(mode,'corr')

                    pmaps = mvpalab_computecorr(cfg,vrdms{sub},vtheo_mdl,true);
                    permaps.(mode).(dist).(mname)(1,:,sub,:) = pmaps;

                elseif strcmp(mode,'regress')

                    [pbv,ptv] = mvpalab_fitglm(cfg,vrdms{sub},vtheo_mdl,true);

                    permaps.(mode).(dist).(mname).bvalues(1,:,sub,:) = pbv;
                    permaps.(mode).(dist).(mname).tvalues(1,:,sub,:) = ptv;

                end
            end

            fprintf('        >> '); toc;
        end
    end
end

%% Save RSA data:
%  Only the RDM matrices are saved (numeric [conditions x conditions x
%  timepoints] or [trials x trials x timepoints] for each subject), as in
%  the fMRI ROI analysis. This is the format read by the fusion analysis
%  (mvpalab_fusion). The condition boundaries are saved in cfg.rsa.bounds.

res.(mode).(dist).rdms = cellfun(@(r) r.rdm,rdms,'UniformOutput',false);
res.(mode).(dist).theo = theo;

% Save results:
if ~cfg.sf.flag, mvpalab_save(cfg,res,'res'); end

if permuted
    if ~cfg.sf.flag, mvpalab_save(cfg,permaps,'permaps'); end
end

%% Compute permutation test:
%  If needed. The correlations and the coefficients have no effect at 0.

if cfg.stats.flag
    if cfg.stats.signflip, permaps = mvpalab_signmaps(res,0); end
    stats = mvpalab_permtest(cfg,res,permaps);
end

% Save the configuration with the fields set by the analysis:
mvpalab_savecfg(cfg);

end