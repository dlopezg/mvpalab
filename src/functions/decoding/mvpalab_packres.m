function res = mvpalab_packres(res,job)
%% MVPALAB_PACKRES
%
%  This function completes the result structure of a decoding analysis.
%  mvpalab_storemap stores all the metrics in fields per direction, and MVPA
%  only has one of them, so its results do not keep that level.
%
%%  INPUT:
%
%  - {struct} - res:
%    Result structure (see mvpalab_storemap).
%
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).
%
%%  OUTPUT:
%
%  - {struct} - res:
%    The same structure. In MVPA, without the fields aa.

if ~job.mvcc, res = withoutdirection(res); end

end

function out = withoutdirection(in)
%% The content of the field aa, at the level of the structure where it is.

if isfield(in,'aa')
    out = in.aa;
else
    out = structfun(@withoutdirection,in,'UniformOutput',false);
end

end
