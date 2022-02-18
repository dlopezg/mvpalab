function bounds = mvpalab_findbound(Y)
%% MVPALAB_FINDBOUNDS
%
%  This function returns the indexes of the last trials of each condition.
%  It additionally returns the index of the middle trial of each condition.
%
%  INPUT:
%
%  - Y  : (ARRAY OF LOGICALS) Label vector for an individual subject.
%
%  OUTPUT:
%
%  - bounds : (STRUCT) - (ARRAY OF INTEGERS) This vector contains the
%             indexes of the last and the middle trial of each condition in
%             the data matrix.

%% Find boundaries:
%  Find changes in the value of consecutive elements.
%  (from 0 to 1 or viceversa).

last = find(diff(Y)~=0);
last(end+1) = length(Y);

%% Find middle trials:

last_ = [0; last];

for i = 2 : length(last_)
    middle(i-1) = ceil((last_(i) - last_(i-1)) / 2) + last_(i-1);
end

%% Return boundaries:

bounds.last = last';
bounds.middle = middle;

end

