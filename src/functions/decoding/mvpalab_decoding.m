function [res,cfg] = mvpalab_decoding(cfg,fv,mode)
%% MVPALAB_DECODING
%
%  This function computes the decoding analysis defined in cfg.analysis:
%  MVPA or MVCC (cross-classification between datasets A and B, in both
%  directions: training in A and test in B and vice versa), and their
%  permuted maps for the permutation test:
%
%    [result,cfg] = mvpalab_decoding(cfg,fv);
%    [permaps,cfg] = mvpalab_decoding(cfg,fv,'permuted');
%
%  A permuted map is the observed map computed with permuted labels, so
%  both follow the same pipeline:
%
%    Subjects > frequency bands > maps (one if observed, cfg.stats.nper if
%    permuted) > repetitions > timepoints (see mvpalab_decodemap).
%
%  In MVCC each permuted map uses one reassignment of the labels of dataset
%  A in both directions (training labels in A - B, test labels in B - A),
%  while dataset B keeps its labels. The two directions of the observed
%  analysis use the same data and labels, so they are correlated; permuting
%  each direction separately loses this correlation and the null
%  distribution of their mean is too narrow.
%
%  Limitation: the permutation also removes the decoding within dataset A.
%  If datasets A and B contain decoding effects that are not shared, the
%  null distribution is still narrower than the distribution of the
%  cross-decoding between them (0.082 vs 0.137 in a simulation with
%  cfg.cv.nreps = 5), so the test can be liberal in that case.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - fv:
%    Feature vectors of each subject. Empty or not used in a sliding filter
%    analysis, where the data of each frequency band is loaded from disk.
%
%  - {string} - mode:
%    'observed' (default) or 'permuted'.
%
%%  OUTPUT:
%
%  - {struct} - res:
%    Result or permuted maps of each performance metric (see
%    mvpalab_storemap and mvpalab_packres).
%
%  - {struct} - cfg:
%    Updated configuration structure.

if nargin < 2, fv = []; end
if nargin < 3, mode = 'observed'; end

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

if strcmp(mode,'permuted')
    % Enable statistics:
    cfg.stats.flag = 1;
else
    % Feature weights are not available with non-linear kernels:
    mvpalab_checkwvector(cfg);
end

job = mvpalab_decodingjob(cfg,mode);
mvpalab_decodingprint('start',cfg,job);

res = struct();

%% Subjects loop:
for sub = 1 : job.nsub
    job.sub = sub;
    mvpalab_decodingprint('subject',cfg,job);

    %% Frequencies loop:
    for freq = 1 : job.nfreq
        job.freq = freq;
        mvpalab_decodingprint('band',cfg,job);

        [data,cfg] = mvpalab_loadfv(cfg,fv,job);

        %% Maps loop:
        for per = 1 : job.nper
            job.per = per;

            %% Labels of this map (see mvpalab_permlabels):
            %  Drawn once per map, so the same labels are used at all the
            %  folds, repetitions and timepoints. In MVCC only the labels
            %  of dataset A are permuted, and they are used in both
            %  directions.
            mapdata = data;
            if job.permuted || cfg.classmodel.permlab
                mapdata.a.Y = mvpalab_permlabels(data.a.Y);
            end

            map = mvpalab_decodemap(cfg,mapdata,job);
            res = mvpalab_storemap(res,map.numeric,cfg,job);
            timepoints{sub,freq,per} = map.timepoints;

            mvpalab_decodingprint('map',cfg,job);
        end
        mvpalab_decodingprint('bandend',cfg,job);
    end
    mvpalab_decodingprint('subjectend',cfg,job);
end
mvpalab_decodingprint('end',cfg,job);

res = mvpalab_packres(res,timepoints,cfg,job);

% Save result:
if ~cfg.sf.flag, mvpalab_save(cfg,res,job.savemode); end

end
