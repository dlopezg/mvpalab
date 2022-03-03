function [res,stats,cfg] = mvpalab_rsa(cfg,fv)
%% Initialize
stats = struct();
nsub = length(cfg.study.dataFiles{1,1});
mode = cfg.rsa.analysis;
dist = cfg.rsa.distance;

%% Subjects loop:
%  Iterate along subjects:

for sub = 1 : nsub
    
    fprintf('<strong> > Computing RSA analysis: </strong>');
    fprintf(['- Subject: ' int2str(sub) '/' int2str(nsub) '\n\n']);
    tic;
    
    %%  Select datamatrix:
    %   Select data, labels and timepoints.
    
    X = fv{sub}.X.a; Y = fv{sub}.Y.a;
    X = X(:,:,cfg.tm.tpoints);
    
    %% Generate neural Representational Dissimilarity Matrices:
    %  This function returns 3D matrices containing the RDMs in a time
    %  resolved way - [timepoints x trials x trials]
    
    [rdms{sub}, cfg.rsa.bounds{sub}] = mvpalab_rdm(cfg,X,Y);
    res.(mode).(dist).rdms{sub} = rdms{sub};
    
    %% Generate the theoretical matrices:
    %  Based on the previously designed models.
    
    theo{sub} = mvpalab_gentrdms(cfg,cfg.rsa.tmodels,cfg.rsa.bounds{sub});
    res.(mode).(dist).theo{sub} = theo{sub};
    
    %% Vectorize RDMs:
    %  Both theoretical and empirical DRMs are vectorized in order to
    %  compute the Representational Similarity Analysis.
    
    vrdms{sub} = mvpalab_vectorizerdm(cfg,rdms{sub});
    vtheo{sub} = mvpalab_vectorizerdm(cfg,theo{sub});
    
    %% Compute the Representational similarity analysis:
    
    %  Empirical and theoretical models are correlated to obtain the time
    %  resolved correlation coefficient.
    
    if strcmp(cfg.rsa.analysis,'corr')
        corr(1,:,sub,1,:) = mvpalab_computecorr(...
            cfg,vrdms{sub},vtheo{sub},false);
    
    %  A general linear model is fitted using the theoretical RDMs as
    %  regressors.

    elseif strcmp(cfg.rsa.analysis,'regress')
        [bvalues(1,:,sub,1,:) tvalues(1,:,sub,1,:)] = mvpalab_fitglm(...
            cfg,vrdms{sub},vtheo{sub},false);
    end
    
    %% Compute permuted maps:
    %  Repeat the representational similarity analysis but permuting the
    %  empirical RDM if needed.
    
    if cfg.stats.flag
        if strcmp(mode,'corr')
            pmaps(1,:,sub,:,:) = mvpalab_computecorr( ...
                cfg,vrdms{sub},vtheo{sub},true);
        elseif strcmp(mode,'regress')
            [bpmaps(1,:,sub,:,:),tpmaps(1,:,sub,:,:)] = mvpalab_fitglm( ...
                cfg,vrdms{sub},vtheo{sub},true);
        end
    end
    
    fprintf('\n        >> '); toc; fprintf('\n');
end

%% Restructure and save data
%  The data structure shuld be reorganized to ensure compatibility with
%  statistical and saving data functions.

% Reestructure results:
if strcmp(mode,'corr')
    res.(mode).(dist) = mvpalab_rsarestruct(cfg,corr);
elseif strcmp(cfg.rsa.analysis,'regress')
    res.(mode).(dist).bvalues = mvpalab_rsarestruct(cfg,bvalues);
    res.(mode).(dist).tvalues = mvpalab_rsarestruct(cfg,tvalues);
end

% Save results:
if ~cfg.sf.flag, mvpalab_save(cfg,res,'res'); end

% Reestructure permuted maps:
if cfg.stats.flag
    if strcmp(mode,'corr')
        permaps.(mode).(dist) = mvpalab_rsarestruct(cfg,pmaps);
    elseif strcmp(mode,'regress')
        permaps.(mode).(dist).bvalues = mvpalab_rsarestruct(cfg,bpmaps);
        permaps.(mode).(dist).tvalues = mvpalab_rsarestruct(cfg,tpmaps);
    end
    
    % Save permuted maps:
    if ~cfg.sf.flag, mvpalab_save(cfg,permaps,'permaps'); end
    
end

%% Compute permutation test:
%  If needed:

if cfg.stats.flag, stats = mvpalab_permtest2(cfg,res,permaps); end

end