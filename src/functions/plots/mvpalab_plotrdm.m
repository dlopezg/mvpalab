function [] = mvpalab_plotrdm(graph,cfg,data)
%% MVPALAB_PLOTRDM
%
%  This function plots a representational dissimilarity matrix (RDM) of
%  one subject and timepoint in the current axes, with lines at the
%  boundaries of the conditions and the names of the conditions
%  (cfg.study.conditionIdentifier, with '_' replaced by '-') as labels.
%
%%  INPUT:
%
%  - {struct} - graph:
%    Parameters of the plot (see mvpalab_plotinit). graph.sub is the
%    index of the subject in cfg.rsa.bounds; mvpalab_plotinit does not
%    set it.
%
%  - {struct} - cfg:
%    Configuration structure (cfg.rsa.bounds, see mvpalab_rsa_time, and
%    cfg.study.conditionIdentifier).
%
%  - {matrix} - data:
%    RDM [trials x trials].

%% Plot the RDM.
%  For a specific subject and timepoint:

if any(graph.caxis)
    imagesc(data,graph.caxis);
else
    imagesc(data);
end
% 
% contourf(data,64,'LineStyle', 'none');
% caxis(graph.caxis)


vline(cfg.rsa.bounds{graph.sub}.last,'-k')
hline(cfg.rsa.bounds{graph.sub}.last,'-k')


%% Extract conditions identifiers 
%  The underscore (_) should be replaced by a dash (-)

identifiers = cfg.study.conditionIdentifier(1,:);

for i = 1 : length(identifiers)
   labels{i} = strrep(identifiers{i},'_','-');
end


%% Add the condition names to the plot:
%  
xticks(cfg.rsa.bounds{graph.sub}.middle)
yticks(cfg.rsa.bounds{graph.sub}.middle)
xticklabels(labels)
yticklabels(labels)


% xticks([])
% yticks([])
% xticklabels([])
% yticklabels([])


%% Final configuration:
%

set(gca,'XAxisLocation','top');
set(gca,'XTickLabelRotation',90);
set(gca,'YTickLabelRotation',0);
set(gca,'FontSize',graph.fontsize)
%title(graph.title);
set(gca,'Layer','top')

colormap(graph.colorMap);


end

