function drivertest(action,varargin)
%% DRIVERTEST
%
%  Regression harness of the decoding analyses (mvpalab_decoding and the
%  deprecated functions that call it). It runs a grid of configurations
%  on tiny synthetic data through the GUI controllers and stores everything
%  the toolbox produces, so two versions of the code can be compared
%  exactly: results, permuted maps, statistics, returned cfg, state of the
%  random number generator, saved files and console output.
%
%  Each version runs in its own MATLAB session, from this folder:
%
%    drivertest('capture',oldRoot,'old.mat');
%    drivertest('capture',newRoot,'new.mat');
%    drivertest('compare','old.mat','new.mat');
%
%  'capture' also checks that a permuted map computed with the identity
%  instead of a label permutation equals the observed map.
%
%%  INPUT:
%
%  - {string} - action:
%    'capture' or 'compare'.
%
%  - varargin:
%    capture: toolbox root, output file and optional name filter (regexp).
%    compare: the two capture files.

switch action
    case 'capture'
        capture(varargin{:});
    case 'compare'
        compare(varargin{:});
    otherwise
        error('Unknown action: %s.',action);
end

end

%% CAPTURE

function capture(root,outfile,filter)

if nargin < 3, filter = '.'; end

isolatepath(root);
set(0,'DefaultFigureVisible','off');

work = fullfile(tempdir,'drivertest');
datadir = fullfile(work,'data');
if ~exist(datadir,'dir'), makedata(datadir); end

cases = gridcases();
cases = cases(~cellfun(@isempty,regexp({cases.name},filter)));
if any([cases.parallel]), startpool(); end

record = struct();
for i = 1 : numel(cases)
    t = tic;
    record.(cases(i).name) = runcase(cases(i),work,datadir);
    fprintf('%3d/%d %-32s %5.1fs %s\n',i,numel(cases),cases(i).name,...
        toc(t),record.(cases(i).name).error);
end

identity = identitycases(root,work,datadir,filter);
save(outfile,'record','identity','-v7.3');

end

function rec = runcase(c,work,datadir)
%% Runs one configuration through its GUI controller.

loc = fullfile(work,'run');
if exist(loc,'dir'), rmdir(loc,'s'); end
mkdir(loc);

cfg = c.build(basecfg(loc,datadir));

rec.error = '';
rng(c.seed,'twister');
try
    console = evalc(c.controller);
catch failure
    console = '';
    rec.error = failure.message;
end
rec.rng = rng;
close all hidden;

outputs = {'result','permaps','stats','resultdiag','permapsdiag','statsdiag'};
for i = 1 : numel(outputs)
    if exist(outputs{i},'var'), rec.(outputs{i}) = eval(outputs{i}); end
end
rec.cfg = cfg;
rec.console = cleanconsole(console);
if c.noconsole, rec.console = ''; end
rec.files = snapshot(loc);

end

function text = cleanconsole(text)
%% Without the times, the links, the paths and the warning tracebacks, which
%  depend on the run, the location and the structure of the code.

text = regexprep(text,'Elapsed time is [\d.]+ seconds\.','');
text = regexprep(text,'ETE \d+:\d+','');
text = regexprep(text,'<a href[^>]*>|</a>','');
text = regexprep(text,'Warning: mvpalab_\w+ is deprecated[^\n]*\n','');
text = regexprep(text,'(\[\x08)+>\x08 *\n?','');
text = regexprep(text,'\]\x08','');
text = regexprep(text,'\[?\s*In [^\n]*\(line \d+\)\s*\]?\n?','');
text = regexprep(text,'/[^\n]*/src/functions/','src/functions/');

end

function files = snapshot(folder)
%% Contents of all the files saved in a folder.

list = dir(fullfile(folder,'**','*.mat'));
files = struct('path',{},'content',{});
for i = 1 : numel(list)
    file = fullfile(list(i).folder,list(i).name);
    files(i).path = file(numel(folder)+2:end);
    files(i).content = load(file);
end
if ~isempty(files)
    [~,order] = sort({files.path});
    files = files(order);
end

end

function result = identitycases(root,work,datadir,filter)
%% A permuted map with the identity as permutation is the observed map.
%  mvpalab_checkcfg puts the toolbox back at the top of the path, so a
%  function earlier on the path cannot replace mvpalab_permlabels: this
%  check uses a copy of the toolbox where the function is replaced.

result = struct();

copy = fullfile(work,'identityroot');
if exist(copy,'dir'), rmdir(copy,'s'); end
mkdir(copy);
copyfile(fullfile(root,'src'),fullfile(copy,'src'));
copyfile(fullfile(root,'mvpalab.m'),copy);
copyfile(fullfile(root,'mvpalab_init.m'),copy);
copyfile(fullfile(root,'genpath_exclude.m'),copy);

file = fullfile(copy,'src','functions','gen','mvpalab_permlabels.m');
fid = fopen(file,'w');
fprintf(fid,'function Yp = mvpalab_permlabels(Y)\nYp = Y;\nend\n');
fclose(fid);

entries = strsplit(path,pathsep);
entries = entries(startsWith(entries,root));
rmpath(entries{:});
addpath(copy);
mvpalab_init(false);
rehash;
assert(contains(which('mvpalab_permlabels'),'identityroot'),...
    'The identity permutation is not on the path.');

analyses = {'mvpa',@mvpalab_mvpa,@mvpalab_permaps;
            'mvcc',@mvpalab_mvcc,@mvpalab_cpermaps};
for a = 1 : size(analyses,1)
    for tempgen = 0 : 1
        name = sprintf('identity_%s_tg%d',analyses{a,1},tempgen);
        if isempty(regexp(name,filter,'once')), continue; end
        loc = fullfile(work,'run');
        cfg = basecfg(loc,datadir);
        cfg = allmetrics(cfg);
        cfg.classmodel.roc = false;
        cfg.classmodel.confmat = false;
        cfg.classmodel.wvector = false;
        cfg.classmodel.tempgen = logical(tempgen);
        cfg.cv.nreps = 2;
        cfg.stats.nper = 1;
        if a == 2, cfg = secondset(cfg,datadir,{'c','d'}); end
        [~,cfg,~,fv] = evalc('mvpalab_import(cfg)');
        rng(7,'twister');
        [~,res,cfg] = evalc('analyses{a,2}(cfg,fv)');
        rng(7,'twister');
        [~,permaps] = evalc('analyses{a,3}(cfg,fv)');
        result.(name) = isequaln(res,permaps);
        fprintf('%s: %d\n',name,result.(name));
    end
end

end

%% GRID OF CONFIGURATIONS

function cases = gridcases()

mods = {
    'min',      @(c,d) c,                                      false;
    'all',      @(c,d) allmetrics(c),                          false;
    'reps',     @(c,d) setreps(allmetrics(c),3),               false;
    'loo',      @(c,d) setcv(allmetrics(c),'loo'),             false;
    'none',     @(c,d) setcv(allmetrics(c),'none'),            false;
    'permlab',  @(c,d) setpermlab(setreps(allmetrics(c),2)),   false;
    'channels', @(c,d) setchannels(allmetrics(c)),             false;
    'rbf',      @(c,d) setkernel(allmetrics(c),'svm','rbf'),   false;
    'da',       @(c,d) setkernel(allmetrics(c),'da','linear'), false;
    'nper1',    @(c,d) setnper(allmetrics(c),1),               false;
    'numeric',  @(c,d) numericflags(c),                        false;
    'roc',      @(c,d) setmetric(c,'roc'),                     false;
    'auc',      @(c,d) setmetric(c,'auc'),                     false;
    'confmat',  @(c,d) setmetric(c,'confmat'),                 false;
    'recall',   @(c,d) setmetric(c,'recall'),                  false;
    'wvector',  @(c,d) setmetric(c,'wvector'),                 false;
    'onesub',   @(c,d) onesubject(allmetrics(c)),              false;
    'parallel', @(c,d) setparallel(setreps(allmetrics(c),2)),  true;
    'parmin',   @(c,d) setparallel(c),                         true};

cases = struct('name',{},'build',{},'controller',{},'seed',{},...
    'parallel',{},'noconsole',{});

for m = 1 : size(mods,1)
    for analysis = {'mvpa','mvcc'}
        for tempgen = 0 : 1
            c.name = sprintf('%s_tg%d_%s',analysis{1},tempgen,mods{m,1});
            c.build = decodingbuild(mods{m,2},analysis{1},tempgen,...
                strcmp(mods{m,1},'loo'));
            c.controller = 'analysisController;';
            c.seed = 1000 + numel(cases);
            c.parallel = mods{m,3};
            c.noconsole = false;
            cases(end+1) = c; %#ok<AGROW>
        end
    end
end

% Different training and test windows and a step between timepoints:
for analysis = {'mvpa','mvcc'}
    c.name = sprintf('%s_tg1_window',analysis{1});
    c.build = decodingbuild(@(c,d) setwindow(allmetrics(c)),analysis{1},1,false);
    c.controller = 'analysisController;';
    c.seed = 1000 + numel(cases);
    c.parallel = false;
    c.noconsole = false;
    cases(end+1) = c; %#ok<AGROW>
end

% Hyperparameter optimization draws inside the timepoints loop:
for analysis = {'mvpa','mvcc'}
    c.name = sprintf('%s_tg0_optimize',analysis{1});
    c.build = decodingbuild(@(c,d) setoptimize(onesubject(c)),analysis{1},0,false);
    c.controller = 'analysisController;';
    c.seed = 1000 + numel(cases);
    c.parallel = false;
    c.noconsole = true;
    cases(end+1) = c; %#ok<AGROW>
end

% Same error with leave-one-out and datasets of different sizes:
c.name = 'mvcc_tg0_loo_unequal';
c.build = decodingbuild(@(c,d) setcv(c,'loo'),'mvcc',0,false);
c.controller = 'analysisController;';
c.seed = 1000 + numel(cases);
c.parallel = false;
c.noconsole = false;
cases(end+1) = c;

% Direct calls: the permuted maps enable the statistics, and a sliding filter
% analysis uses the current cfg, changed after the import in these cases.
direct = {
    'direct_mvpa_flag','mvpa',0,['cfg.stats.flag = 0; ' ...
        '[cfg,~,fv] = mvpalab_import(cfg); ' ...
        '[permaps,cfg] = mvpalab_permaps(cfg,fv);'];
    'direct_mvcc_flag','mvcc',0,['cfg.stats.flag = 0; ' ...
        '[cfg,~,fv] = mvpalab_import(cfg); ' ...
        '[permaps,cfg] = mvpalab_cpermaps(cfg,fv);']};
for d = 1 : size(direct,1)
    c.name = direct{d,1};
    c.build = decodingbuild(@(c,d) c,direct{d,2},direct{d,3},false);
    c.controller = direct{d,4};
    c.seed = 1000 + numel(cases);
    c.parallel = false;
    c.noconsole = false;
    cases(end+1) = c; %#ok<AGROW>
end

sfdirect = {
    'direct_sf_mvpa','MVPA',['cfg = mvpalab_import(cfg); cfg.stats.nper = 2; ' ...
        'cfg.cv.nfolds = 3; [result,cfg] = mvpalab_mvpa(cfg); ' ...
        '[permaps,cfg] = mvpalab_permaps(cfg);'];
    'direct_sf_mvcc','MVCC',['cfg = mvpalab_import(cfg); cfg.stats.nper = 2; ' ...
        'cfg.cv.nfolds = 3; [result,cfg] = mvpalab_mvcc(cfg); ' ...
        '[permaps,cfg] = mvpalab_cpermaps(cfg);']};
for d = 1 : size(sfdirect,1)
    analysis = sfdirect{d,2};
    c.name = sfdirect{d,1};
    c.build = @(cfg) sfcfg(cfg,analysis,1,1);
    c.controller = sfdirect{d,3};
    c.seed = 1000 + numel(cases);
    c.parallel = false;
    c.noconsole = false;
    cases(end+1) = c; %#ok<AGROW>
end

% Sliding filter (the band files are read by the drivers):
for analysis = {'MVPA','MVCC'}
    for flag = 0 : 1
        for nreps = 1 : 2
            c.name = sprintf('sf_%s_stats%d_nreps%d',lower(analysis{1}),flag,nreps);
            c.build = @(cfg) sfcfg(cfg,analysis{1},flag,nreps);
            c.controller = 'sfilterController;';
            c.seed = 1000 + numel(cases);
            c.parallel = false;
            c.noconsole = false;
            cases(end+1) = c; %#ok<AGROW>
        end
    end
end

end

function build = decodingbuild(mod,analysis,tempgen,equalsize)

build = @apply;

    function cfg = apply(cfg)
        datadir = cfg.drivertestdata;
        cfg = rmfield(cfg,'drivertestdata');
        cfg.classmodel.tempgen = logical(tempgen);
        cfg.classmodel.extdiag = logical(tempgen);
        if strcmp(analysis,'mvcc')
            sets = {'e','f'};
            if equalsize, sets = {'c','d'}; end
            cfg = secondset(cfg,datadir,sets);
        end
        cfg = mod(cfg,datadir);
    end

end

function cfg = basecfg(loc,datadir)

cfg = mvpalab_init(false);
cfg.location = loc;
cfg.drivertestdata = datadir;
files = {'s1.mat','s2.mat','s3.mat'};
cfg.study.dataPaths{1,1} = [datadir filesep 'a' filesep];
cfg.study.dataPaths{1,2} = [datadir filesep 'b' filesep];
cfg.study.dataFiles{1,1} = files;
cfg.study.dataFiles{1,2} = files;
cfg.classmodel.parcomp = false;
cfg.cv.nfolds = 4;
cfg.stats.flag = 1;
cfg.stats.nper = 3;
cfg.stats.nperg = 20;

end

function cfg = secondset(cfg,datadir,sets)

files = cfg.study.dataFiles{1,1};
cfg.study.dataPaths{2,1} = [datadir filesep sets{1} filesep];
cfg.study.dataPaths{2,2} = [datadir filesep sets{2} filesep];
cfg.study.dataFiles{2,1} = files;
cfg.study.dataFiles{2,2} = files;

end

function cfg = allmetrics(cfg)

metrics = {'roc','auc','confmat','precision','recall','f1score','wvector'};
for i = 1 : numel(metrics)
    cfg.classmodel.(metrics{i}) = true;
end

end

function cfg = setmetric(cfg,metric)
cfg.classmodel.(metric) = true;
end

function cfg = numericflags(cfg)
cfg.classmodel.precision = 1;
cfg.classmodel.recall = 0;
cfg.classmodel.f1score = 1;
end

function cfg = setreps(cfg,nreps)
cfg.cv.nreps = nreps;
end

function cfg = setcv(cfg,method)
cfg.cv.method = method;
end

function cfg = setpermlab(cfg)
cfg.classmodel.permlab = true;
end

function cfg = setchannels(cfg)
cfg.channels.selected = [1 3 4 6];
cfg.normdata = 3;
cfg.dimred.method = 'pca';
cfg.dimred.ncomp = 3;
end

function cfg = setkernel(cfg,method,kernel)
cfg.classmodel.method = method;
cfg.classmodel.kernel = kernel;
end

function cfg = setnper(cfg,nper)
cfg.stats.nper = nper;
end

function cfg = onesubject(cfg)
cfg.study.dataFiles{1,1} = cfg.study.dataFiles{1,1}(1);
cfg.study.dataFiles{1,2} = cfg.study.dataFiles{1,2}(1);
if ~isempty(cfg.study.dataFiles{2,1})
    cfg.study.dataFiles{2,1} = cfg.study.dataFiles{2,1}(1);
    cfg.study.dataFiles{2,2} = cfg.study.dataFiles{2,2}(1);
end
end

function cfg = setparallel(cfg)
cfg.classmodel.parcomp = true;
end

function cfg = setwindow(cfg)
cfg.classmodel.extdiag = false;
cfg.tm.tpstart = -20;
cfg.tm.tpend = 40;
cfg.tm.tpstart_ = 0;
cfg.tm.tpend_ = 30;
cfg.tm.tpsteps = 2;
end

function cfg = setoptimize(cfg)
cfg.classmodel.optimize.flag = true;
cfg.classmodel.optimize.opt.Verbose = 0;
cfg.classmodel.optimize.opt.ShowPlots = false;
cfg.stats.nper = 1;
end

function cfg = sfcfg(cfg,analysis,flag,nreps)

datadir = cfg.drivertestdata;
cfg = rmfield(cfg,'drivertestdata');
files = {'s1.mat','s2.mat'};
cfg.analysis = analysis;
cfg.study.dataPaths{1,1} = [datadir filesep 'sfa' filesep];
cfg.study.dataPaths{1,2} = [datadir filesep 'sfb' filesep];
cfg.study.dataFiles{1,1} = files;
cfg.study.dataFiles{1,2} = files;
if strcmp(analysis,'MVCC')
    cfg.study.dataPaths{2,1} = [datadir filesep 'sfc' filesep];
    cfg.study.dataPaths{2,2} = [datadir filesep 'sfd' filesep];
    cfg.study.dataFiles{2,1} = files;
    cfg.study.dataFiles{2,2} = files;
end
cfg.cv.nreps = nreps;
cfg.tm.tpsteps = 8;
cfg.stats.flag = flag;
cfg.sf.flag = 1;
cfg.sf.filesLocation = fullfile(cfg.location,'filtered_datasets');
cfg.sf.lfreq = 8;
cfg.sf.hfreq = 32;
cfg.sf.bw = 4;
cfg.sf.hbw = 2;
cfg.sf.order = 120;
cfg.sf.nfreq = 2;

end

%% SYNTHETIC DATA

function makedata(datadir)

rng(20261106,'twister');
nch = 6;
times = -30:10:40;
Q = orth(randn(nch));

% Different number of trials per subject and dataset:
sizes = struct('a',[14 16 18],'b',[14 16 18],...
    'c',[14 16 18],'d',[14 16 18],'e',[12 13 15],'f',[12 13 15]);
signs = struct('a',1,'b',-1,'c',1,'d',-1,'e',1,'f',-1);
for set = fieldnames(sizes)'
    name = set{1};
    pattern = signs.(name) * Q(:,1) + 0.5 * Q(:,2) * strcmp(name,'a');
    for sub = 1 : numel(sizes.(name))
        ntrials = sizes.(name)(sub);
        X = randn(nch,numel(times),ntrials);
        X = X + pattern * double(times >= 0);
        saveset(fullfile(datadir,name),sub,X,100,times);
    end
end

% Sliding filter: a burst of 10 Hz after the stimulus.
fs = 250;
times = -200:4:596;
burst = (times >= 200 & times <= 500) .* cos(2*pi*10*times/1000);
sfsigns = struct('sfa',1,'sfb',-1,'sfc',1,'sfd',-1);
for set = fieldnames(sfsigns)'
    name = set{1};
    for sub = 1 : 2
        X = randn(nch,numel(times),24) + sfsigns.(name) * 2.5 * Q(:,1) * burst;
        saveset(fullfile(datadir,name),sub,X,fs,times);
    end
end

end

function saveset(folder,sub,X,fs,times)

if ~exist(folder,'dir'), mkdir(folder); end
labels = arrayfun(@(i) sprintf('E%d',i),1:size(X,1),'UniformOutput',false);
EEG = struct('setname','drivertest','srate',fs,'data',X,...
    'trials',size(X,3),'nbchan',size(X,1),'pnts',size(X,2),'times',times,...
    'xmin',times(1)/1000,'xmax',times(end)/1000,'event',[],...
    'chanlocs',struct('labels',labels));
save(fullfile(folder,sprintf('s%d.mat',sub)),'EEG');

end

%% MATLAB PATH

function isolatepath(root)
%% Only one copy of the toolbox on the path (see toolbox/local/pathdef.m).

entries = strsplit(path,pathsep);
remove = entries(contains(entries,'/Sourcecode/mvpalab') | ...
    contains(entries,'/toolboxes/spm') | ...
    contains(entries,'/toolboxes/Psychtoolbox'));
if ~isempty(remove), rmpath(remove{:}); end

addpath(root);
mvpalab_init(false);
addpath('/Users/David/Sourcecode/toolboxes/eeglab');
addpath('/Users/David/Sourcecode/toolboxes/eeglab/plugins/firfilt');

assert(startsWith(which('mvpalab_mvpa'),root),'Wrong toolbox on the path.');

end

function startpool()
%% The workers must use the same copy of the toolbox as the client.

delete(gcp('nocreate'));
pool = parpool('Processes',2);
wait(parfevalOnAll(pool,@path,0,path));
locations = fetchOutputs(parfevalOnAll(pool,@which,1,'mvpalab_mvpa'),...
    'UniformOutput',false);
assert(all(strcmp(locations,which('mvpalab_mvpa'))),...
    'Wrong toolbox on the workers.');

end

%% COMPARE

function compare(fileA,fileB)

a = load(fileA);
b = load(fileB);

names = fieldnames(a.record);
extra = setxor(names,fieldnames(b.record));
if ~isempty(extra), fprintf('Different cases: %s\n',strjoin(extra,' ')); end

ndiff = 0;
for i = 1 : numel(names)
    if ~isfield(b.record,names{i}), continue; end
    found = difference(a.record.(names{i}),b.record.(names{i}),'',{});
    if ~isempty(found)
        ndiff = ndiff + 1;
        fprintf('%s: %d differences\n',names{i},numel(found));
        fprintf('    %s\n',found{1:min(numel(found),15)});
    end
end

fprintf('\n%d cases compared, %d with differences.\n',numel(names),ndiff);

fprintf('Failed in the first version: %s\n',strjoin(failed(a.record),' '));
fprintf('Failed in the second version: %s\n',strjoin(failed(b.record),' '));

for side = {a.identity,b.identity}
    fields = fieldnames(side{1});
    values = cellfun(@(f) side{1}.(f),fields);
    fprintf('Identity permutation: %d/%d equal.\n',sum(values),numel(values));
end

end

function names = failed(record)

names = fieldnames(record);
keep = cellfun(@(n) ~isempty(record.(n).error),names);
names = names(keep)';

end

function found = difference(a,b,where,found)
%% Exact recursive comparison, including the order of the fields.

if ~strcmp(class(a),class(b))
    found{end+1} = sprintf('%s: class %s vs %s',where,class(a),class(b));
elseif isstruct(a)
    if ~isequal(size(a),size(b))
        found{end+1} = sprintf('%s: size',where);
    elseif ~isequal(fieldnames(a),fieldnames(b))
        found{end+1} = sprintf('%s: fields [%s] vs [%s]',where,...
            strjoin(fieldnames(a)',' '),strjoin(fieldnames(b)',' '));
    else
        fields = fieldnames(a);
        for n = 1 : numel(a)
            for f = 1 : numel(fields)
                found = difference(a(n).(fields{f}),b(n).(fields{f}),...
                    sprintf('%s(%d).%s',where,n,fields{f}),found);
            end
        end
    end
elseif iscell(a)
    if ~isequal(size(a),size(b))
        found{end+1} = sprintf('%s: size %s vs %s',where,...
            mat2str(size(a)),mat2str(size(b)));
    else
        for n = 1 : numel(a)
            found = difference(a{n},b{n},sprintf('%s{%d}',where,n),found);
        end
    end
elseif isa(a,'function_handle')
    if ~strcmp(func2str(a),func2str(b))
        found{end+1} = sprintf('%s: function',where);
    end
elseif ~isequal(size(a),size(b))
    found{end+1} = sprintf('%s: size %s vs %s',where,...
        mat2str(size(a)),mat2str(size(b)));
elseif ~isequaln(a,b)
    if isnumeric(a)
        found{end+1} = sprintf('%s: max diff %g',where,...
            max(abs(double(a(:))-double(b(:)))));
    else
        found{end+1} = sprintf('%s: values',where);
    end
end

end
