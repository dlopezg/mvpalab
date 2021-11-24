function [ cfg ] = mvpalab_timing( cfg )
%MVPALAB_TIMING This function configures the data in the cfg structure for 
%the mvpa analysis.
fprintf('<strong> > Adjusting timing: </strong>');
c = cfg.tm;

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
c.times = cfg.tm.times(c.startidx:c.tpsteps:c.endidx);
c.times_ = cfg.tm.times(c.startidx_:c.tpsteps:c.endidx_);

%% Update the cfg structure
cfg.tm = c;

fprintf(' > Done! \n\n');

end

