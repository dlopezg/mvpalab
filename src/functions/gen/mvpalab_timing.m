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

%% Find closest points in the time vector:
[~,c.startidx] = min(abs(c.times-c.tpstart));
[~,c.endidx] = min(abs(c.times-c.tpend));

%% Adjust sizes and timepoints:
c.tpoints = (c.startidx:c.tpsteps:c.endidx);
c.ntp = length(c.tpoints);
c.times = cfg.tm.times(c.startidx:c.tpsteps:c.endidx);

%% Update the cfg structure
cfg.tm = c;

fprintf(' > Done! \n\n');

end

