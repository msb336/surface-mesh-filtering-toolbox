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
    %     plot3dvectors(points(points_connected,:),points(free_edges(i),:), '*');
    switch conlevel
        case 3
            newconnections = [newconnections; connect3p(points_connected, con, free_edges, i)];
        case 2
            if length(points_connected)> 2
                newest = connect2p(points_connected, con, free_edges(i), points);
                %                 plot3dvectors(points(newest,:), '*')
                newconnections = [newconnections; newest];
                con = [con; newest];
            end
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
req = 0;
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
[i1, i2] = meshgrid(1:length(points_connected)-1, 2:length(points_connected));
iters = unique(sort([i1(:) i2(:)], 2), 'rows');
iters = iters(iters(:,1)~=iters(:,2),:);
for j = 1:size(iters,1)
    points3d = points(points_connected(iters(j,:)),:);
    orig = points3d - points(indexpoint,:);
    potcon = sort([indexpoint, points_connected(iters(j,:))']);
    if ~ismember(potcon, con, 'rows')
        b1 = linecheck(points(potcon,:));
        b2 = crosscheck(points,con, potcon, indexpoint);
        b3 = areacheck(points(potcon,:));
        if b1 && b2 && b3
%             crosscheck(points,con, potcon, indexpoint, 1);
            newconnection = potcon;
            break
        end
    end
end
end

function bool = linecheck(points)
l = points(2:3,:)-points(1,:);
ref = rref(l);
bool = all(any(ref, 2));
end

function bool = crosscheck(pc, con, con1,index, ~)
rows = con(any(con == index,2),:);
edge = con1(con1~=index);
checkpoints = unique(rows(rows~=index));

edges = [checkpoints(:) index*ones(length(checkpoints),1)];
p1 = pc(edge,:);
if nargin == 5 && any(pc(con1,3) == -1)
    plot3dvectors(pc(con1,:),'*');
    deb = 1;
else
    deb  = 0;
end

for i = 1:length(checkpoints)
    
    if deb == 1
        bool = ~intersection(p1, pc(edges(i,:),:),1);
    else
        bool = ~intersection(p1, pc(edges(i,:),:));
    end
    
    if bool == false
        break
    end
end
end

function bool = areacheck(points)
maxa = 0.5*0.3^2;
a = 0.5*norm(cross(points(3,:)-points(1,:), points(2,:)-points(1,:)));
bool = a <= maxa;
end


