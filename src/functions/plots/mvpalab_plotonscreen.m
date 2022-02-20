function [] = mvpalab_plotonscreen(graphs)
%mvpalab_plotonscreen Summary of this function goes here
%   Detailed explanation goes here
rectangle('Position',[graphs.onscreen(1) -1.5 graphs.onscreen(2) 3],...
    'facecolor',[.9 .9 .9],'edgecolor','w');
hl = vline(0,'k-','On screen time');

end

