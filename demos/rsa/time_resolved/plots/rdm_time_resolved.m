
%% Initialize:
%  Initilize the plot utility.
%  Load the RDM for all the subjects and timepoints.
%  Select subject 1.

graph = mvpalab_plotinit();
load ('..\results\rsa-time-resolved\corr\pearson/rdms/result.mat')
graph.subject = 1;
graph.caxis = [0 1.5];

%% Plot video:
%  Video animation of the evolution of the neural RDM for the specified
%  subject.

figure;
for i = 1 : size(result.rdm{1},3)
    mvpalab_plotrdm(graph,cfg,result.rdm{graph.subject}(:,:,i));
    if (i == 1); title('Press any key to start video'); pause; end
    title(['time = ' num2str(cfg.tm.times(i)) ' sec.'])
    colorbar
    pause(0.1);
end

%% Example:
% 
% graph.tmp = 10;
% figure(3);
% mvpalab_plotrdm(graph,cfg,result.rdm{graph.subject}(:,:,graph.tmp));
% colorbar
% 
% graph.tmp = 184;
% figure(4);
% mvpalab_plotrdm(graph,cfg,result.rdm{graph.subject}(:,:,graph.tmp));
% colorbar
% 
% graph.tmp = 200;
% figure(5);
% mvpalab_plotrdm(graph,cfg,result.rdm{graph.subject}(:,:,graph.tmp));
% colorbar
% 
% graph.tmp = 250;
% figure(6);
% mvpalab_plotrdm(graph,cfg,result.rdm{graph.subject}(:,:,graph.tmp));
% colorbar
% 
% 
