function [conn] = nearestTriangulation(pc)
%NEARESTTRIANGLE determine surface mesh by nearest neighbor

conn = uint32([0 0 0]);%zeros(pc.Count, 3));

for i = 1:length(pc.Location)
    conn = [conn; getNeighbs(pc, conn, i, 5)];
end

end

function points = getNeighbs(pc, conn, idx, num)
%% 4 triangles
%you are currently trying to figure out how to build 4 rows of connectivity
%without any overlap.
%Also, you're a boss for building a recursive function correctly

temp = pc.findNearestNeighbors(pc.Location(idx,:), num);
temp = temp(temp~=idx);
temp = temp([end-3:end])';

orig = pc.Location(temp,:) - pc.Location(idx,:);
v = orig./(orig(:,1).^2+orig(:,2).^2+orig(:,3).^2).^0.5;
lin = rref(v);

if all(sum(lin)) || any(ismember(conn, [idx temp], 'rows'))
    num = num + 1;
    neighbs = getNeighbs(pc,conn, idx, num);
else
    neighbs = [idx temp];
end

points = neighbs;
end


