function [newconnections] = defineNewConnections(con,free_edges, conlevel, points, freepts)
%DEFINTENEWCONNECTIONS builds new connections based on edge and floating
%points
%   con - list all all current triangulations
%   free_edges - list of all vertices that lie on the edge boundary of an
%   unclosed shape
%   conlevel - number of preconnected edges to link. (3 -> 3 edges already
%   connected to become a new triangle, 2 -> build a new edge connecting
%   the vertices of 2 predefined edges
%   points - all points the the triangulation shape
%   freepts - all points not referenced in the triangulation


if nargin == 2
    conlevel = 3;
end

newconnections = [];
for i = 1:length(free_edges)
    points_connected = getConnectedPoints(con, free_edges, i);
    points_connected = points_connected(ismember(points_connected, free_edges));
    switch conlevel
        case 3
            newconnections = [newconnections; connect3p(points_connected, con, free_edges, i)];
        case 2
            newest = connect2p(points_connected, con, free_edges(i), points);
            newconnections = [newconnections; newest];
            con = [con; newest];
    end
end

newconnections = unique(newconnections, 'rows');
end







%%%%Functions%%%%
function pointset = getConnectedPoints(connections, currentSet, setindex)
%Collect all points connected to setindex
pointset = connections(any(connections == currentSet(setindex),2),:);
pointset = unique(pointset(pointset~=currentSet(setindex)));
end
function newconnection = connect3p(points_connected, con, free_edges, i)
%find a connection created by three edges (if one exists)
newconnection = [];
for j = 1:length(points_connected)
    second_set = getConnectedPoints(con, points_connected, j);
    second_set = second_set(second_set~=free_edges(i) & ismember(second_set, free_edges));
    for k = 1:length(second_set)
        closing = con(any(con == second_set(k),2),:);
        potcon = sort([free_edges(i) points_connected(j) second_set(k)]);
        if any(closing(:) == free_edges(i)) && ~ismember(potcon, con, 'rows')
            newconnection = potcon;
            req = 1;
            break
        else
            req = 0;
        end
    end
    if req == 1
        break
    end
end

end

function newconnection = connect2p(points_connected, con, indexpoint, points)
%find a connection referenced by 2 edges (if one exists)
newconnection = [];
points3d = points(points_connected,:);
if length(points_connected) == 2
    orig = points3d - points(indexpoint,:);
    potcon = sort([indexpoint, points_connected']);
    v = orig./(orig(:,1).^2+orig(:,2).^2 + orig(:,3).^2).^0.5;
    angle = acos(dot(v(1,:), v(2,:)));
    angleparams = angle > 0.16*pi/180 && angle <= pi/2;
    if any(v(1,:) ~= v(2,:)) && any(v(1,:) ~= -v(2,:)) && ~ismember(potcon, con, 'rows') && angleparams
        rel = [points3d; points(indexpoint,:)];
        newconnection = potcon;
    end
end
end


