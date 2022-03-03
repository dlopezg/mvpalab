function [] = mvpalab_plotrdm(graph,cfg,data)
%MVPALAB_PLOTRDM Summary of this function goes here
%   Detailed explanation goes here

%% Plot the RDM.
%  For a specific subject and timepoint:

imagesc(data,graph.caxis);
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

