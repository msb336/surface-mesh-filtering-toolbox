function [ max_distance ] = findNearest( pointSet, numNeighbors )
%FINDNEAREST search a point set for the maximum distance between neighbor
%points
%   pointSet - an nx3 set of 3d points
%   numNeighbors - scalar dictating how many points to count as neighbors

if nargin == 1
    numNeighbors = 3;
end

distancevectors = arrayfun(@(x)getD(pointSet, x, numNeighbors), 1:length(pointSet), 'UniformOutput', false);
closest = cell2mat(distancevectors);
max_distance = max(closest(:));

end

function closest = getD(pointset, idx, numNeighbors)
    distance = unique(round(sort(sqrt(sum((pointset-pointset(idx,:)).^2,2))),3));
    closest = distance(1:numNeighbors);
end

