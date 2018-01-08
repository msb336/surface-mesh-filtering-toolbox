function [ max_distance ] = findNearest( pointSet, numNeighbors )
%FINDNEAREST search a point set for the maximum distance between neighbor
%points
%   pointSet - an nx3 set of 3d points
%   numNeighbors - scalar dictating how many points to count as neighbors

if nargin == 1
    numNeighbors = 3;
end
closest = [];
for i = 1:length(pointSet)
    %compute Euclidean distances:
    distances = unique(round(sort(sqrt(sum((pointSet-pointSet(i,:)).^2,2))),3));
    %find the smallest distance and use that as an index into B:
    closest(end+1:end+numNeighbors) = distances(1:numNeighbors);
end

max_distance = max(closest(:));


end

