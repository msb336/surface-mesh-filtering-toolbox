function [triobj] = nearestTriangulation(pc)
%NEARESTTRIANGLE determine surface mesh by nearest neighbor
if isa(pc,'double')
    pc = pointCloud(pc);
end
conn = [];
tic
time = 0;
maxarea = 0.5;
newref = 1:pc.Count;
while ~isempty(newref) && time < 5
    newcon = sort(pc.findNearestNeighbors(pc.Location(newref(1),:), 3)');
    newref = newref(2:end);
    b1 = linecheck(pc.Location(newcon,:));
    if b1
        conn = [conn;newcon];
        newref = newref(~ismember(newref, conn));
    elseif isempty(newref)
        break;
    end
end
triobj = triangulation(double(conn), pc.Location);
end

function bool = crosscheck(pc, con1, con2, edge)
p1 = con1(~ismember(con1, edge));
p2 = con2(~ismember(con2, edge));
vecs1 = [pc.Location([p1;edge(1)],:);pc.Location([p1;edge(2)],:)];
vecs2 = [pc.Location([p2;edge(1)],:);pc.Location([p2;edge(2)],:)];
bool = any(arrayfun(@(x,y)intersection(vecs1(x:x+1,:), vecs2(y:y+1,:)), [1 1 3 3], [1 3 1 3]));
end
function bool = linecheck(points)
l = points(2:3,:)-points(1,:);
ref = rref(l);
bool = all(any(ref, 2));
end

function bool = areacheck(points, maxA)
a = 0.5*norm(cross(points(3,:)-points(1,:), points(2,:)-points(1,:)));
bool = a <= maxA;
end
