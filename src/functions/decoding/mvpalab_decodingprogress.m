function mvpalab_decodingprogress(cfg,stage,job)
%% MVPALAB_DECODINGPROGRESS
%
%  This function shows the progress of a decoding analysis in the console.
%  The observed analyses show the bands and repetitions of each subject,
%  and the time per subject. The permuted maps show the permutations and
%  repetitions of each subject and band, and the time per band.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {string} - stage:
%    Point of the analysis: 'start', 'subject', 'band', 'repetitions',
%    'repetition', 'map', 'bandend', 'subjectend' or 'end'.
%
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).

switch stage
    case 'start'
        fprintf('<strong> > Computing %s: </strong>\n',job.title);

    case 'subject'
        if ~job.permuted
            tic;
            printsubject(job);
            if cfg.sf.flag, fprintf(' Frequency bands - '); end
        end

    case 'band'
        if job.permuted
            tic;
            printsubject(job);
            fprintf('- Permutation: ');
        elseif cfg.sf.flag
            mvpalab_pcounter(job.freq,job.nfreq);
        end

    case 'repetitions'
        if ~job.permuted && job.nreps > 1, fprintf(' Repetition: '); end

    case 'repetition'
        if job.nreps > 1
            if job.permuted
                printrepetition(job);
            else
                mvpalab_pcounter(job.rep,job.nreps);
            end
        end

    case 'map'
        if job.permuted && job.nreps == 1
            mvpalab_pcounter(job.per,job.nper);
        end

    case 'bandend'
        if job.permuted
            fprintf(' >> ');
            toc;
        end

    case 'subjectend'
        if ~job.permuted, toc; end

    case 'end'
        fprintf('\n');
end

end

function printsubject(job)
%% Subject being computed, out of the total.

fprintf(['   - Subject: ' int2str(job.sub) '/' int2str(job.nsub) ' >> ']);

end

function printrepetition(job)
%% Live progress: permutation + repetition, always with the same length.

msg = sprintf('%*d/%d - Repetition: %*d/%d',...
    numel(num2str(job.nper)),job.per,job.nper,...
    numel(num2str(job.nreps)),job.rep,job.nreps);

if job.per > 1 || job.rep > 1
    fprintf('%s',repmat(char(8),1,numel(msg)));
end

fprintf('%s',msg);

end
