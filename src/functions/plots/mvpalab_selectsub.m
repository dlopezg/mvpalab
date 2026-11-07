function data = mvpalab_selectsub(graph,data)
%% MVPALAB_SELECTSUB
%
%  This function selects the data of one subject for the plots. If
%  graph.subject is 0 or data is empty, data is returned without changes.
%  If graph.subject is out of range, a warning is shown and the data of
%  all subjects is returned, so the plot shows the group average.
%
%%  INPUT:
%
%  - {struct} - graph:
%    Parameters of the plot (see mvpalab_plotinit). graph.subject is the
%    index of the subject, or 0 for all subjects.
%
%  - {matrix} - data:
%    Results with the subjects in the third dimension.
%
%%  OUTPUT:
%
%  - {matrix} - data:
%    Results of the selected subject, or of all subjects.

if graph.subject && ~isempty(data)
    if size(data,3) >= graph.subject
        data = data(:,:,graph.subject);
    else
        warning('Subject index out of range. Gruop average is showed');
    end
end
end

