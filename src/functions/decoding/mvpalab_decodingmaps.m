function [res,cfg,job] = mvpalab_decodingmaps(cfg,fv,mode)
%% MVPALAB_DECODINGMAPS
%
%  This function computes the maps of a decoding analysis, without checking
%  or saving anything, so mvpalab_sfilter can compute the frequency bands and
%  the unfiltered baseline. See the pipeline in mvpalab_decoding.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - fv:
%    Feature vectors of each subject (see mvpalab_decoding).
%
%  - {string} - mode:
%    'observed' or 'permuted'.
%
%%  OUTPUT:
%
%  - {struct} - res:
%    Result or permuted maps of each performance metric (see
%    mvpalab_storemap and mvpalab_packres).
%
%  - {struct} - cfg:
%    Updated configuration structure.
%
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).

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

        %% Random draws of this band (see mvpalab_sfrng):
        cfg = mvpalab_sfrng(cfg,job);

        %% Maps loop:
        for per = 1 : job.nper
            job.per = per;

            %% Labels of this map (see mvpalab_permlabels):
            %  Drawn once per map, so the same labels are used at all the
            %  folds, repetitions and timepoints. With supertrials they are
            %  the labels of the single trials. In MVCC only the labels of
            %  dataset A are permuted, and they are used in both directions.
            mapdata = data;
            if job.permuted || cfg.classmodel.permlab
                mapdata.a.Y = mvpalab_permlabels(data.a.Y);
            end

            map = mvpalab_decodemap(cfg,mapdata,job);
            res = mvpalab_storemap(res,map,cfg,job);

            mvpalab_decodingprint('map',cfg,job);
        end
        mvpalab_decodingprint('bandend',cfg,job);
    end
    mvpalab_decodingprint('subjectend',cfg,job);
end
mvpalab_decodingprint('end',cfg,job);

% Locations of the selected channels, once every subject has passed the
% check of the selection (see mvpalab_chanselection):
cfg = mvpalab_updatechanloc(cfg.channels.selected,cfg);

res = mvpalab_packres(res,job);

end
