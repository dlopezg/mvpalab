function data = mvpalab_classdata(cfg,raw)
%% MVPALAB_CLASSDATA
%
%  This function returns the data of each dataset of one subject in a
%  structure with one field per class, named after
%  cfg.study.conditionIdentifier without spaces. It is the format of the
%  data returned by mvpalab_import and read by mvpalab_fext.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.study.conditionIdentifier).
%
%  - {cell array} - raw:
%    Data of each dataset and class {datasets x classes} (see
%    mvpalab_readsubject).
%
%%  OUTPUT:
%
%  - {cell array} - data:
%    One structure per dataset {1 x datasets}, with the data of each class
%    [channels x timepoints x trials].

data = cell(1,size(raw,1));

for ctxt = 1 : size(raw,1)
    for class = 1 : size(raw,2)
        id = cfg.study.conditionIdentifier{ctxt,class};
        data{ctxt}.(id(~isspace(id))) = raw{ctxt,class}.data;
    end
end

end
