function mvpalab_updateversion(v)

load mvpalab_version
mvpalab_version = v;
save('mvpalab_version','mvpalab_version','-append');

end

