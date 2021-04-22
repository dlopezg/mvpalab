function data = mvpalab_selectsub(graph,data)
if graph.subject && ~isempty(data)
    if size(data,3) >= graph.subject
        data = data(:,:,graph.subject);
    else
        warning('Subject index out of range. Gruop average is showed');
    end
end
end

