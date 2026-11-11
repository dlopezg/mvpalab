function mvpalab_pcounter(this,total)
%% MVPALAB_PCOUNTER
%
%  This function prints a progress counter 'this/total' in the command
%  window, with a fixed width. From the second call it deletes the
%  previous counter first, so nothing else must be printed between two
%  calls.
%
%%  INPUT:
%
%  - {int} - this:
%    Current iteration.
%
%  - {int} - total:
%    Total number of iterations.

msg = sprintf('%*d/%d ',numel(num2str(total)),this,total);
if this > 1, fprintf(repmat('\b',1,numel(msg))); end
fprintf('%s',msg);

end
