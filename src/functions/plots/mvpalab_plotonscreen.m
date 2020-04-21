function [] = mvpalab_plotonscreen(graphs)
%mvpalab_plotonscreen Summary of this function goes here
%   Detailed explanation goes here
rectangle('Position',[graphs.onscreen(1) 0 graphs.onscreen(2) 1],...
    'facecolor',[.9 .9 .9],'edgecolor','w');
hl = vline(0,'k-','On screen time');

end

