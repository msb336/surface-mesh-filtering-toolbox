function [conn] = nearestTriangulation(pc)
%NEARESTTRIANGLE determine surface mesh by nearest neighbor
if isa(pc,'double')
    pc = pointCloud(pc);
end

conn = uint32([0 0 0]);

for i = 1:length(pc.Location)
    conn = [conn; getNeighbs(pc, conn, i, 4)];
end

conn = conn(2:end,:);

end

function points = getNeighbs(pc, conn, idx, num)
%%
temp = pc.findNearestNeighbors(pc.Location(idx,:), num);
temp = temp(temp~=idx);
temp = temp(end-2:end)';

orig = pc.Location(temp,:) - pc.Location(idx,:);
v = orig./(orig(:,1).^2+orig(:,2).^2 + orig(:,3).^2).^0.5;
lin = sum([sum(rref(v(:,1:2)),2) sum(rref(v(:,[1 3])),2) sum(rref(v(:,2:3)),2)], 1) == 2;


conrows = sort([idx*ones(3,1) [temp(1:2);temp([1 3]);temp([2 3])]], 2);
conrows = conrows(lin',:);

bool = membercheck(conn, conrows);   

if all(~lin) || all(bool) && num < 10 
    num = num + 2;
    neighbs = getNeighbs(pc,conn, idx, num);
elseif num >= 10
    neighbs = [];
else
    neighbs = conrows(~bool, :);
end

points = neighbs;
end

function bool = membercheck(v1, v2)
bool = ismember(v2, v1, 'rows');
end


    

