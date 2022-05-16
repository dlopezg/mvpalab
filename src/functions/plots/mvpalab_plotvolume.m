function mvpalab_plotvolume(volume,size,color)

plot3(volume.coor(:,1),volume.coor(:,2),volume.coor(:,3),'o','Color',color,'MarkerSize',size,'MarkerFaceColor',color)
xlim([0,volume.dim(1)])
ylim([0,volume.dim(2)])
zlim([0,volume.dim(3)])

end

