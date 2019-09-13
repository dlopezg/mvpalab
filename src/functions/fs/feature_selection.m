function [ X ] = feature_selection(cfg,X,Y)
%FEATURE_SELECTION Summary of this function goes here
%   Detailed explanation goes here
%% Subjects loop:
nsub = length(cfg.subjects);
for sub = 1 : nsub
    if cfg.fs.pca.flag
        for tp = 1 : size(X,3)
            [coeff(:,:,tp),scores(:,:,tp),latent(:,:,tp)] = pca(X(:,:,tp));
        end
        X = scores(:,1:cfg.fs.pca.ncom,:);
    elseif cfg.pls.flag
        for tp = 1 : size(X,3)
            [xl(:,:,tp),...
                yl{tp},...
                xs(:,:,tp),...
                ys(:,:,tp),...
                beta(:,:,tp),...
                pctvar{tp},...
                mse{tp},...
                stats{tp}] = plsregress(X(:,:,tp),Y,cfg.fs.pls.ncom);
            
            if false
                w = stats{tp}.W;
                for i = 1:length(Y)
                    XS(i,:,tp)= X(i,:,tp)*w;
                end
            end
        end
        X = XS;
    end
end

end

