function [permuted_maps,cfg] = cr_permaps(cfg,fv)
%PERMUTATION_MAPS This function generates permutation maps at a subject
%level for future statistical analyses.
fprintf('<strong> > Computing permutated maps: </strong>\n');
cfg.analysis.permlab = true;
%% Subjects loop:
for sub = 1 : length(cfg.subjects)
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(length(cfg.subjects)) '\n']);
    X = fv.X{sub}.a; Y = fv.Y{sub}.a;
    %% Generate permuted labels
    for i = 1 : cfg.stats.nper
        tic; strpar = cvpartition(Y,'KFold',cfg.analysis.nfolds);
        if cfg.analysis.parcomp
            %% Timepoints loop
            c = cfg.analysis;
            parfor tp = 1 : cfg.analysis.ntp
                correct_rate(tp,:) = cr_classifier(X,Y,tp,c,strpar);
            end
            fprintf(['     - Permutation: ' int2str(i) ' > ']);
        else
            for tp = 1 : cfg.analysis.ntp
                correct_rate(tp,:) = cr_classifier(X,Y,tp,c,strpar);
            end
            fprintf(['     - Permutation: ' int2str(i) ' > ']);
        end

        if isrow(correct_rate)
            permuted_maps(:,:,i,sub) = correct_rate;
        else
            permuted_maps(:,:,i,sub) = correct_rate';
        end
        toc
    end
end
cfg.analysis.permlab = false;

end

