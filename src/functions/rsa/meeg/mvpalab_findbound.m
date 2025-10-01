function bounds = mvpalab_findbound(Y)
%% MVPALAB_FINDBOUNDS
%
%  This function returns the indexes of the last trials of each condition.
%  It additionally returns the index of the middle trial of each condition.
%
%%  INPUT:
%
%  - {array of logicals} Y
%    Description: This vector contains logical labels for an individual 
%    subject.
%
%%  OUTPUT:
%
%  - {struct.array} bounds
%    Description: This vector contains the indexes of the last and the 
%    middle trial of each condition in the data matrix.

%% Find boundaries:
%  Find first and last element of each condition:

changes = find(Y(1:end-1) ~= Y(2:end));
last = [changes; length(Y)];
first = [1; changes + 1];
middle = round((first + last) / 2);

%% Return boundaries:

bounds.last = last';
bounds.middle = middle;

end

