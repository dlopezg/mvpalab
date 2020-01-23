function [ cfg ] = analysis_timming( cfg )
%MVPA_TIMMING This function configures the data in the cfg structure for 
%the mvpa analysis.
fprintf('<strong> > Adjusting analysis timming: </strong>');
c = cfg.analysis;
%% Find closest points in the time vector:
[~,c.startidx] = min(abs(c.times-c.tpstart));
[~,c.endidx] = min(abs(c.times-c.tpend));

%% Adjust sizes and timepoints:
c.tpoints = (c.startidx:c.tpsteps:c.endidx);
c.ntp = length(c.tpoints);
c.times = cfg.times(c.startidx:c.tpsteps:c.endidx);

%% Update the cfg structure
cfg.analysis = c;
fprintf(' - Done!\n');

end

