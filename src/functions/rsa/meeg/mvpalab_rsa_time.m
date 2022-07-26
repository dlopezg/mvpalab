function [res,stats,cfg] = mvpalab_rsa_time(cfg,fv)
%% Initialize
stats = struct();
nsub = length(cfg.study.dataFiles{1,1});
mode = cfg.rsa.modality;
dist = cfg.rsa.distance;

%% Subjects loop:
%  Iterate along subjects:

for sub = 1 : nsub
    
    fprintf('\n<strong> > Computing RSA analysis: </strong>');
    fprintf(['- Subject: ' int2str(sub) '/' int2str(nsub) '\n\n']);
    tic;
    
    %%  Select datamatrix:
    %   Select data, labels and timepoints.
    
    X = fv{sub}.X.a; Y = fv{sub}.Y.a;
    X = X(:,:,cfg.tm.tpoints);
    
    %% Generate neural Representational Dissimilarity Matrices:
    %  This function returns 3D matrices containing the RDMs in a time
    %  resolved way:
    %  rdms - [trials x trials x timepoints]
    
    rdms{sub} = mvpalab_rdm(cfg,X);
    
    %%  Find condition's boundaries for each subject:
    %   This functions returns the indexes of the last trials for each
    %   condition. This indexes can be used to plot conditions boundaries
    %   or to split the data.
    
    cfg.rsa.bounds{sub} = mvpalab_findbound(Y);
    
    %% Transform the trial-wise RDM to condition-wise RDM
    %  Representational dissimilarity matrices can be computed trial or
    %  condition-wise.
    %  rdms - [n_conditions x n_conditions x timepoints].
    
    rdms{sub} = mvpalab_conditionrdm(cfg,rdms{sub},cfg.rsa.bounds{sub});
    
    %% Generate the theoretical RD matrices:
    %  Based on the previously designed models.
    %  theo - [n_conditions x n_conditions x 1 x models]
    
    theo{sub} = mvpalab_gentrdms(cfg,cfg.rsa.tmodels,cfg.rsa.bounds{sub});
    
    %% Vectorize RDMs:
    %  Both theoretical and empirical DRMs are vectorized in order to
    %  compute the Representational Similarity Analysis.
    %  vrdms - [timepoints x vectorized]
    %  vtheo - [1 x vectorized x models]
    
    vrdms{sub} = mvpalab_vectorizerdm(cfg,rdms{sub});
    vtheo{sub} = mvpalab_vectorizerdm(cfg,theo{sub});
    
    %% Repeat theoretical matrices for each timepoint:
    %  vtheo - [timepoints x vectorized x models]
    
    vtheo{sub} = repmat(vtheo{sub},[size(vrdms{sub},1) 1 1]);
    
    %% Compute the Representational similarity analysis:
    
    %  Empirical and theoretical models are correlated to obtain the time
    %  resolved correlation coefficient.
    
    for mdl = 1 : size(vtheo{sub},3)
        
        fprintf(['\n<strong>   >> Model: '...
            cfg.rsa.tmodels{mdl}.id '</strong>\n']);
        
        vtheo_mdl = vtheo{sub}(:,:,mdl);
        mname = cfg.rsa.tmodels{mdl}.id;
        
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
        
        if cfg.stats.flag
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

%% Save RSA data:

res.(mode).(dist).rdms = rdms;
res.(mode).(dist).theo = theo;

% Save results:
if ~cfg.sf.flag, mvpalab_save(cfg,res,'res'); end

if cfg.stats.flag
    if ~cfg.sf.flag, mvpalab_save(cfg,permaps,'permaps'); end
end

%% Compute permutation test:
%  If needed:

if cfg.stats.flag, stats = mvpalab_permtest(cfg,res,permaps); end

end