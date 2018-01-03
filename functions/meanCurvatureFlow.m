function [ smoothedTri ] = meanCurvatureFlow(  triObj, numiter )
%MEANCURVATUREFLOW Summary of this function goes here
%   delx = - H(i)*n(i)
%   H(i) - mean curvature at x(i)
%   outer unit normal vector at x(i)
%   delx = -(1/4*A)* sum(cot(alpha(j) + cot(beta(j))*(x(j) - x(i))
%   A - Area of a small region surround x(i)
%   alpha & beta - angles opposite to edge x(i)x(j)

if nargin == 1
    numiter = 1;
end

% Pull connection list and points from inputs
con = triObj.ConnectivityList;
pold = triObj.Points;

% Set empty matrix for smoothed point cloud
pnew = zeros(size(pold));

% Iterative smoothing for numiter iterations
for iter = 1:numiter
    for idx = 1:length(pold)

    % Find Neighbors
    neigh = findNeighbors(con,idx);
    
       
    % Calculate Area
    
    % Calculate Edge Angles (alpha + beta)
        
    end
    % Set old point values to newest values
    pold = pnew;
end
% Create new triangulation object
smoothTri = triangulation(con, pnew);


end

function neighbors = findNeighbors(con, idx)
% u(xi) = (1/(sum(wj)) (sum(wj*xj - xi))
% wj = ||xi - xj||^-1

% Find all rows containing point index
[r,~] = find(con == idx);
neighbors = [];

% Find all neighbors for index point
for i = 1:length(r)
    row = con(r(i),:);
    neighbors = [neighbors row(row~=idx)];
end

neighbors = unique(neighbors);

end

function area = getArea(neigh, points)



end

