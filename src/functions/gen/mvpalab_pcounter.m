function [] = mvpalab_pcounter( this , total )
%% MVPALAB_PCOUNTER
%
%  This function prints a progress counter 'total/this' in the command
%  window. From the second call it deletes the previous counter first, so
%  nothing else must be printed between two calls.
%
%%  INPUT:
%
%  - {int} - this:
%    Current iteration.
%
%  - {int} - total:
%    Total number of iterations.

if this > 1
    for j = 0 : log10(this - 1) + numel(num2str(total)) + 2
        fprintf('\b'); % Delete previous counter display
    end
end

fprintf([int2str(total) '/' int2str(this) ' ']);

end

