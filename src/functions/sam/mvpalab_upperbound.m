function upperbounds = mvpalab_upperbound()
%MVPALAB_UPPERBOUND Upper bound calculation:

%% Initialization
eta = 0.05;  % Significance level
l = 10:2000; % Number of samples
d = 1:10;    % Number of features
h = d+1;     % VC dimenison

%% Bound VC:
vcbound = zeros(numel(l),numel(d));
for i = 1 : numel(d)
    for j = 1 : numel(l)
        vcbound(j,i)=sqrt(abs((h(i).*(log(2*l(j)./h(i))+1)-log(eta/4))./l(j)));
    end
end

%% Bound G:
gbound = zeros(numel(l),numel(d));
Cld = zeros(numel(l),numel(d));

for s = 1 : numel(l)
    for j = 1 : numel(d)
        for k = 1 : j
            Cld(s,j) = Cld(s,j)+nchoosek(l(s)-1,k-1);
        end
        Cld(s,j) = 2*Cld(s,j);
        gbound(s,j) = sqrt(log(Cld(s,j)/eta)/(2*l(s)));
    end
end

%% Bound Phi(n,d):
phibound = zeros(numel(l),numel(d));
CldPhi = zeros(numel(l),numel(d));

for s = 1 : numel(l)
    for j = 1 : numel(d)
        for k = 1 : j
            CldPhi(s,j) = CldPhi(s,j)+nchoosek(l(s),k-1);
        end
        %Cld(s,j)= 2*Cld(s,j);
        phibound(s,j) = sqrt(log(CldPhi(s,j)/eta)/(2*l(s)));
    end
end

%% Number of functions with k zeroes
gzbound = zeros(numel(l),numel(d));
Cld = zeros(numel(l),numel(d));
K = d-1;

for s = 1 : numel(l)
    for j = 1 : numel(d)
        for z=K
            for k=1:j-z
                Cld(s,j) = Cld(s,j)+nchoosek(l(s),z)*nchoosek(l(s)-1-z,k-1);
            end
        end
        Cld(s,j) = 2*Cld(s,j);
        gzbound(s,j) = sqrt(log(Cld(s,j)/eta)/(2*l(s)));
    end
end

%% Save bounds:
upperbounds.vcbound = vcbound;
upperbounds.gbound = gbound;
upperbounds.phibound = phibound;
upperbounds.gzbound = gzbound;

mvpalabdir = which('mvpalab');
idcs = strfind(mvpalabdir,filesep);
mvpalabdir = mvpalabdir(1:idcs(end-2));

save([mvpalabdir 'res/sam_upperbound.mat'],'upperbounds','-v7.3');

%% Plot figure:
figure;

[X,Y]=meshgrid(l,d);
ax1=mesh(X,Y,vcbound','FaceColor',[.8 .8 .8],'LineStyle','none');
hold on
ax2=mesh(X,Y,gbound','FaceColor',[.7 .7 .7],'LineStyle','none');
ax3=mesh(X(1:9,:),Y(1:9,:),gzbound(:,1:9)','FaceColor',[.6 .6 .6],'LineStyle','none');
% ax4=mesh(X,Y,phibound','FaceColor',[.5 .5 .5],'LineStyle','none');

% Highlight some points:
Xpoints = [...
    790,790,790,...
    260,260,260,...
    150,150,150,...
    90,90,90,...
    70,70,70];

Ypoints = [...
    1,3,5,...
    1,3,5,...
    1,3,5,...
    1,3,5,...
    1,3,5];

for i = 1 : numel(Xpoints)
    zpoints(i) = gzbound(Xpoints(i),Ypoints(i))+0.05;
end

scatter3(Xpoints,Ypoints,zpoints,30,'red','k','filled')
xlabel('Sample Size l')
ylabel('Dimension d')
zlabel('Upper bound')

legend('Vapnik`s bound \gamma_{VC}',...
    'Proposed Bound \gamma_{emp} with N(l,d)',...
    'Proposed Bound with \gamma_{emp} with Q(l,d)',...
    'Upper Bound values')

end

