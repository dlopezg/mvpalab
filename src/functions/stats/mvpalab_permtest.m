function stats = mvpalab_permtest(cfg,results,permuted_maps,fname)
%% MVPALAB_PERMTEST
%
%  This function recursively iterates over the fields contained in the
%  results and permuted_maps structures. If the selected field has permuted
%  maps we make a recursive call and the permutation test is computed with
%  mvpalab_computepermtest. Cell arrays are not maps: an RSA model can
%  share its name with the RDMs.
%
%  The first call (without fname) saves the statistics with mvpalab_save,
%  unless cfg.sf.flag is true.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - results:
%    Data structure containing the results for each measure, or one map
%    in the recursive call.
%
%  - {struct} - permuted_maps:
%    Data structure containing the permuted maps for each measure, or the
%    permuted maps of one map in the recursive call.
%
%  - {string} - fname:
%    Optional. Current field name used for the recursive call.
%
%%  OUTPUT:
%
%  - {struct} - stats:
%    The same fields as results that have permuted maps, with the output
%    of mvpalab_computepermtest for each map.

%% Check if the current input is a struct:
%  Description: If the current input is a struct, extract field names and
%  iterate over fields.

if isstruct(results)
    field_names = fieldnames(results);
    
    for i = 1 : length(field_names)
        fname = field_names{i};
        
        if isfield(permuted_maps,fname) && ~iscell(results.(fname))
            res = results.(fname);
            pmap = permuted_maps.(fname);
            stats.(fname) = mvpalab_permtest(cfg,res,pmap,fname);
        end
    end
    
else
    %% Compute the permutation test:
    %  Description: If the current input is a data matrix the permutation 
    %  test is computed.
    
    if ~exist('fname','var'); fname = 'acc'; end
    fprintf(['\n<strong> > Permutation test (' fname '): </strong>\n']);
    stats = mvpalab_computepermtest(cfg,results,permuted_maps);
    
end

%% Exit:
%  And save the statistics.

if nargin < 4
    fprintf('\n<strong> > Permutation test finished!</strong>\n\n');
    if ~cfg.sf.flag, mvpalab_save(cfg,stats,'stats'); end
end

end

