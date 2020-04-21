function [] = mvpalab_pcounter( this , total )
if this > 1
    for j = 0 : log10(this - 1) + numel(num2str(total)) + 2
        fprintf('\b'); % Delete previous counter display
    end
end

fprintf([int2str(total) '/' int2str(this) ' ']);

end

