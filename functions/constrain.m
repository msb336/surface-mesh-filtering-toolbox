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
% constraints - constraint object with properties "Length" and "Angle"
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
minAngle = constraints.Angle;
newcon = [];

[~,tetrasize] = size(connections);
    
    for k = 1:length(connections)
        switch tetrasize
            case 4
                
                vecs = {points(connections(k, 1), :) - points(connections(k, 2), :), ...
                    points(connections(k, 2), :) - points(connections(k, 3), :), ...
                    points(connections(k, 3), :) - points(connections(k, 4), :), ...
                    points(connections(k, 4), :) - points(connections(k, 1), :)};

                dist = [norm(vecs{1}), norm(vecs{2}), norm(vecs{3}), norm(vecs{4})];
                iters = 4;
                set =[2,3,4,1];
            case 3
                vecs = {points(connections(k, 1), :) - points(connections(k, 2), :), ...
                    points(connections(k, 3), :) - points(connections(k, 2), :)};

                dist = [norm(vecs{1}), norm(vecs{2})];
                iters = 1;
                set = 2;
        end
        
        for i = 1:iters
            
            angle(i) = acosd(dot(vecs{i}, vecs{set(i)}) / (dist(i)*dist(set(i))));
        end
        angle(angle > 90) = 180 - angle(angle>90);

        if all(dist <= maxLength) && all(angle >= minAngle)
            newcon(end+1, :) = connections(k,:);
        end
    end

    


[ft,fp] = freeBoundary(triangulation(newcon,points));
conTri = triangulation(ft, fp);


end

