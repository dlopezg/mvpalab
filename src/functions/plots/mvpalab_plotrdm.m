function mvpalab_plotrdm(graph,cfg,data)
%% MVPALAB_PLOTRDM
%
%  This function plots a representational dissimilarity matrix (RDM) of
%  one subject and timepoint in the current axes, with lines between the
%  conditions and the names of the conditions
%  (cfg.study.conditionIdentifier, with '_' replaced by '-') as labels.
%
%%  INPUT:
%
%  - {struct} - graph:
%    Parameters of the plot (see mvpalab_plotinit). graph.subject is the
%    index of the subject of the RDM in cfg.rsa.bounds: it must be set,
%    because 0 (all subjects) has no bounds.
%
%  - {struct} - cfg:
%    Configuration structure (cfg.rsa.bounds, see mvpalab_rsa_time, and
%    cfg.study.conditionIdentifier).
%
%  - {matrix} - data:
%    RDM [trials x trials].

if ~graph.subject
    error('mvpalab:plotrdm','Set graph.subject to the subject of the RDM.');
end

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


% Lines between the last trial of a condition and the first of the next:
between = cfg.rsa.bounds{graph.subject}.last(1:end-1) + .5;
vline(between,'-k')
hline(between,'-k')


%% Extract conditions identifiers 
%  The underscore (_) should be replaced by a dash (-)

identifiers = cfg.study.conditionIdentifier(1,:);

for i = 1 : length(identifiers)
   labels{i} = strrep(identifiers{i},'_','-');
end


%% Add the condition names to the plot:
%  
xticks(cfg.rsa.bounds{graph.subject}.middle)
yticks(cfg.rsa.bounds{graph.subject}.middle)
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

