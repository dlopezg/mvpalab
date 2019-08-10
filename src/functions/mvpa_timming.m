function [ cfg ] = mvpa_timming( cfg )
%MVPA_TIMMING This function configures the data in the cfg structure for 
%the mvpa analysis.
fprintf('<strong> > Adjusting MVPA timming: </strong>');
c = cfg.mvpa;
%% Find closest points in the time vector:

[~,c.startidx] = min(abs(cfg.times-c.tpstart));
[~,c.endidx] = min(abs(cfg.times-c.tpend));

%% Adjust sizes and timepoints:

c.tpoints = (c.startidx:c.tpsteps:c.endidx);
c.ntp = length(c.tpoints);
c.times = cfg.times(c.startidx:c.tpsteps:c.endidx);

%% Update the cfg structure
cfg.mvpa = c;
fprintf(' - Done!\n');

end

