function volume = mvpalab_read_nifti(file)
%% MVPALAB_READ_NIFTI
%
%  This function loads a NIfTI file with the MATLAB function niftiread if
%  it is available (MATLAB R2017b and above). Otherwise the SPM functions
%  spm_vol and spm_read_vols are used, so SPM must be installed and added
%  to the MATLAB path. An error is raised if neither is available.
%
%%  INPUT:
%
%  - {string} - file:
%    Path of the NIfTI file.
%
%%  OUTPUT:
%
%  - {struct} - volume:
%    Volume with the fields:
%    - data: Value of each voxel.
%    - dim: Size of the volume.
%    - fname: Path of the file.

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
    error('mvpalab:read_nifti','Error: No software found to read .nii files.')
end

end

