function adjusted = mvpalab_bhfdr(pvals)
%% MVPALAB_BHFDR
%
%  This function computes the Benjamini-Hochberg FDR-adjusted p-values
%  (Benjamini & Hochberg, 1995). The p-values are sorted, the i-th of the m
%  p-values is multiplied by m/i, and each adjusted p-value is the minimum
%  of the values from its position to the end, so the adjusted p-values
%  keep the order of the p-values and none is larger than the largest
%  p-value. The p-values with an adjusted p-value below the FDR level are
%  the ones rejected by the step-up procedure.
%
%  It gives the same adjusted p-values as mafdr(pvals,'BHFDR',true) of the
%  Bioinformatics Toolbox, which is not needed.
%
%  - Benjamini, Y., & Hochberg, Y. (1995). Controlling the false discovery
%    rate: a practical and powerful approach to multiple testing. Journal
%    of the Royal Statistical Society: Series B, 57(1), 289-300.
%
%%  INPUT:
%
%  - {matrix} - pvals:
%    P-values.
%
%%  OUTPUT:
%
%  - {matrix} - adjusted:
%    FDR-adjusted p-values, with the size of pvals.

m = numel(pvals);
[sorted,order] = sort(pvals(:));
scaled = cummin(sorted .* (m ./ (1:m)'),'reverse');

adjusted = pvals;
adjusted(order) = scaled;

end
