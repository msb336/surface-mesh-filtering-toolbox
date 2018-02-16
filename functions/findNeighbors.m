function [ neighbor_vector ] = findNeighbors( conn, idx )
%FINDNEIGHBORS find all neighboring points based on connectivity index conn
%     conn - connectivity index
%     idx - desired index point

indeces = conn(conn == idx, :);
indeces = indeces(:);
important_ones = indeces(indeces ~= idx);
neighbor_vector = unique(important_ones);

end

