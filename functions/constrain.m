function [ conTri ] = constrain( varargin )
%CONSTRAIN constrains a delaunay triangulation based on edge length and
%vertex angles
%
% conTri = constrain(triObj, constraints)
% Outputs:
% conTri - triangulation object
%
% Inputs:
% triObj - triangulation object
% constraints - constraint object with properties "Length" (angle -
% deprecated)
%
% conTri = constrain(connections, points, constraints)
% Outputs:
% conTri - triangulation object
%
% Inputs:
% connections - list of point connections for tetrahedral mesh
% points - verteces of tetrahedral mesh
% constraints  - constraint object with properties "Length" and "Angle"

if length(varargin) == 2
    triObj = varargin{1};
    points = triObj.Points;
    connections = triObj.ConnectivityList;
    constraints = varargin{2};
elseif length(varargin) == 3
    connections = varargin{1};
    points = varargin{2};
    constraints = varargin{3};
end

maxLength = constraints.Length;
[~,tetrasize] = size(connections);

logi = arrayfun(@(x)checkDistance(connections, points, x, tetrasize, maxLength), 1:length(connections(:,1)));
newcon = connections(logi', :);

if tetrasize == 4
    [ft,fp] = freeBoundary(triangulation(newcon,points));
    conTri = triangulation(ft, fp);
else
    conTri = triangulation(newcon, points);
end


end

function L = checkDistance(connectionset, pointset, index, tetrasize, maxLength)


switch tetrasize
    case 4
        
        vecs = [pointset(connectionset(index, 1), :)' - pointset(connectionset(index, 2), :)', ...
            pointset(connectionset(index, 2), :)' - pointset(connectionset(index, 3), :)', ...
            pointset(connectionset(index, 3), :)' - pointset(connectionset(index, 4), :)', ...
            pointset(connectionset(index, 4), :)' - pointset(connectionset(index, 1), :)'];
        
        dist = [norm(vecs(:,1)), norm(vecs(:,2)), norm(vecs(:,3)), norm(vecs(:,4))];
        
    case 3
        vecs = [pointset(connectionset(index, 1), :)' - pointset(connectionset(index, 2), :)', ...
            pointset(connectionset(index, 3), :)' - pointset(connectionset(index, 2), :)'];
        
        dist = [norm(vecs(:,1)), norm(vecs(:,2))];
        
end

if all(dist < maxLength)
    L = true;
else
    L = false;
end

end
