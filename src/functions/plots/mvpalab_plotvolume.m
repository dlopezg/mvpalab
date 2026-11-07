function mvpalab_plotvolume(volume,size,color)
%% MVPALAB_PLOTVOLUME
%
%  This function plots the voxels of a volume as points in 3D in the
%  current axes, with the axis limits from 0 to the size of the volume.
%
%%  INPUT:
%
%  - {struct} - volume:
%    Volume with the coordinates of the voxels in volume.coor
%    [voxels x 3] and the size of the volume in volume.dim (see
%    mvpalab_load_volumes).
%
%  - {double} - size:
%    Size of the markers.
%
%  - {matrix} - color:
%    Color of the markers, an RGB triplet [1 x 3] or a string with a
%    hexadecimal color code (for example '#BBBBBB').

plot3(volume.coor(:,1),volume.coor(:,2),volume.coor(:,3),'o','Color',color,'MarkerSize',size,'MarkerFaceColor',color)
xlim([0,volume.dim(1)])
ylim([0,volume.dim(2)])
zlim([0,volume.dim(3)])

end

