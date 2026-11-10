function [res,cfg,job] = mvpalab_evalsubjects(cfg,fv,mode)
%% MVPALAB_EVALSUBJECTS
%
%  This function computes all the performance maps of a decoding analysis:
%  for each subject and frequency band, the observed map or the
%  cfg.stats.nper permuted maps (see mvpalab_evalmap). It does not check or
%  save anything, so mvpalab_sfilter can compute the frequency bands and
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
%    mvpalab_storemap). In MVPA, without the level of the direction.
%
%  - {struct} - cfg:
%    Updated configuration structure.
%
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).

job = mvpalab_decodingjob(cfg,mode);
mvpalab_decodingprogress('start',cfg,job);

res = struct();

%% Subjects loop:
for sub = 1 : job.nsub
    job.sub = sub;
    mvpalab_decodingprogress('subject',cfg,job);

    %% Frequencies loop:
    for freq = 1 : job.nfreq
        job.freq = freq;
        mvpalab_decodingprogress('band',cfg,job);

        data = mvpalab_subjectdata(cfg,fv,job);

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

            map = mvpalab_evalmap(cfg,mapdata,job);
            res = mvpalab_storemap(res,map,cfg,job);

            mvpalab_decodingprogress('map',cfg,job);
        end
        mvpalab_decodingprogress('bandend',cfg,job);
    end
    mvpalab_decodingprogress('subjectend',cfg,job);
end
mvpalab_decodingprogress('end',cfg,job);

% Locations of the selected channels, once every subject has passed the
% check of the selection (see mvpalab_chanselection):
cfg = mvpalab_updatechanloc(cfg.channels.selected,cfg);

%% MVPA has one direction, so its results do not keep that level:
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
