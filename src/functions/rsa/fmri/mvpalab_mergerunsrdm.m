function rdm_ = mvpalab_mergerunsrdm(cfg,data,rdm)
%% MVPALAB_MERGERUNSRDM
%
%  This function averages the run blocks of an RDM between betas, so it
%  returns the RDM between conditions. Each element is the mean of the
%  block of a pair of conditions, and the diagonal is set to 0. With one
%  run the RDM is returned without changes.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (not used).
%
%  - {cell array} - data:
%    Betas [conditions x runs]. Only the number of runs is used.
%
%  - {matrix} - rdm:
%    RDM between the betas [betas x betas], with the betas ordered
%    condition by condition (see mvpalab_combineruns).
%
%%  OUTPUT:
%
%  - {matrix} - rdm_:
%    RDM between the conditions [conditions x conditions].

offset = size(data,2);
offset_ = offset - 1;
xidx = 1;

if offset > 1
    for i = 1 : offset : size(rdm,1)-offset_
        yidx = 1;
        for j = 1 : offset : size(rdm,1)-offset_
            if i == j
                rdm_(xidx,yidx) = 0;
            else
                rdm_(xidx,yidx) = mean(mean(rdm(i:i+offset_,j:j+offset_)));
            end
            yidx = yidx + 1;
        end
        xidx = xidx + 1;
    end
else
    rdm_ = rdm;
end

