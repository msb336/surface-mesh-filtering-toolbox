function [idx ] = triangulateNearest( pointSet)
%FINDNEAREST search a point set for each point's nearest neighbor
%
%   pointSet - a mxn pointcloud
%   getindex - boolean (true or false). true returns the index location of
%   each point's nearest neighbor as well as the distance between those two
%   points
s = size(pointSet);
idx = zeros(s(1), 3);
for i = 1:length(pointSet)
idx(i,:) = [i, getD(pointSet, i)];
end
idx = idx(idx(:,1)~=0, :);

end

function closest = getD(pointset, idx)
distance = sqrt(sum((pointset-pointset(idx,:)).^2,2));
[sorted_d, ind] = sort(distance);
new_ind = ind(sorted_d~=0);
closest = new_ind(1:2)';
end

