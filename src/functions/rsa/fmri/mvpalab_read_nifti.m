function volume = mvpalab_read_nifti(file)
%% MVPALAB_READNIFTI
%
%  This function load the specified NIFTI file using the matlab function
%  niftiread if it is available (matlab version R2017b and avobe).
%
%  Otherwise the SPM function spm_vol is employed. Note that SPM must be
%  installed and added to the matlab path.
%
%%  INPUT:
%
%  - {struct} - file:
%    Configuration structure.
%
%%  OUTPUT:
%
%  - {struct} - data:
%    NIFTI file containing the following fields:
%       mask.data:  [3D-matrix] containing the value for each voxel.
%       mask.dim:   [vector]    containing the size of the volume.
%       mask.fname: [string]    containing the path to the volume file.
%%

if exist('niftiread','file')
    
    % Read nifti header and get info:
    header = niftiinfo(file);
    volume.dim = header.ImageSize;
    volume.fname = header.Filename;
    
    % Read volume data:
    volume.data = niftiread(file);
    
elseif exist('spm_vol','file')
    
    % Read nifti header and get info:
    header = spm_vol(file);
    volume.dim = header.dim;
    volume.fname = header.fname;
    
    % Read volume data:
    volume.data = spm_read_vols(header);
    
else
    error('Error: No software found to read .nii files.')
end

end

