function [] = mvpalab_mkdir(dir)
%create_folder This function creates a folder if it doesn't exist. 
    if isdir(dir) == false
        mkdir(dir);
    end
end