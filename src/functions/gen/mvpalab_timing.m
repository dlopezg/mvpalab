function cfg = mvpalab_timing(cfg,times)
%% MVPALAB_TIMING
%
%  This function selects the timepoints of the analysis from the time
%  vector of the data, between cfg.tm.tpstart and cfg.tm.tpend (training
%  window) and between cfg.tm.tpstart_ and cfg.tm.tpend_ (testing
%  window). If cfg.tm.tpstart and cfg.tm.tpend are both 0, the analysis
%  uses the entire epoch. If cfg.tm.tpstart_ and cfg.tm.tpend_ are both 0,
%  the testing window is the training window. The limits are moved to the
%  closest points of the time vector, and one of every cfg.tm.tpsteps
%  points is selected.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.tm).
%
%  - {matrix} - times:
%    Time vector of the data, one value per timepoint.
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    The same structure with cfg.tm updated: tpstart, tpend, tpstart_,
%    tpend_, startidx, endidx, startidx_, endidx_, tpoints, tpoints_
%    (indices of the selected timepoints), ntp, ntp_ (number of
%    timepoints), rtimes (the whole time vector), times and times_
%    (selected timepoints).

fprintf('<strong> > Adjusting timing: </strong>');
cfg.tm.rtimes = times;
c = cfg.tm;
c.times = times;

%% If start and end timepoints are zero, analize the entire epoch:
if (c.tpstart == 0) && (c.tpend == 0)
    c.tpstart = c.times(1);
    c.tpend   = c.times(end);
end

%% If start and end timepoints for testing window are 0, test = train:
if (c.tpstart_ == 0) && (c.tpend_ == 0)
    c.tpstart_ = c.tpstart;
    c.tpend_   = c.tpend;
end

%% Find closest points in the time vector:
[~,c.startidx] = min(abs(c.times-c.tpstart));
[~,c.endidx] = min(abs(c.times-c.tpend));
[~,c.startidx_] = min(abs(c.times-c.tpstart_));
[~,c.endidx_] = min(abs(c.times-c.tpend_));

%% Adjust sizes and timepoints:
c.tpoints = (c.startidx:c.tpsteps:c.endidx);
c.tpoints_ = (c.startidx_:c.tpsteps:c.endidx_);
c.ntp = length(c.tpoints);
c.ntp_ = length(c.tpoints_);
c.times = times(c.startidx:c.tpsteps:c.endidx);
c.times_ = times(c.startidx_:c.tpsteps:c.endidx_);

%% Update the cfg structure
cfg.tm = c;

fprintf(' > Done! \n\n');

end

