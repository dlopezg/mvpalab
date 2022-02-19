function res = mvpalab_rsarestruct(cfg,data)
%% MVPALAB_RSARESTRUCT
%
%  This function returns a restructured result variable according to the
%  MVPAlab guidelines. The returned struct will be fully compatible with
%  statistical and plotting functions. This fuction is compatible with
%  correlation values and permuted maps.
%
%%  INPUT:
%
%  - {struct} cfg
%    Description: Configuration structure.
%
%  - {5D-matrix} data
%    Description: Time series including correlation values or permuted maps
%    for each timepoint and model. For data structure consistency:
%    [1 x timepoints x subject x permutetions x model]
%
%%  OUTPUT:
%
%  - {struct} res
%    Description:Data matrices [1 x timepoints x subject] are rearranged
%    in individual fields for each theoretical model.


%% Rearrange the data:

for mdl = 1 : size(data,5)
    res.(cfg.rsa.tmodels{mdl}.id) = data(:,:,:,:,mdl);
end

end

