function [ edges ] = boundedcheck( tri )
%BOUNDEDCHECK determines all boundary edges of triangulation object tri
if isa(tri, 'triangulation')
    con = tri.ConnectivityList;
else
    con = tri;
end

s = size(con);
mult =[1 0 0; 0 1 0; 1 0 0; 0 0 1; 0 1 0; 0 0 1];
edgevec = mult*con';
rows = sort(reshape(edgevec, 2, s(1)*3)',2);

r = unique(rows, 'rows');
bool = arrayfun(@(x1,x2)redundant(rows, [x1 x2]), r(:,1), r(:,2));%1:s(1)*3);
edges = r(bool,:);
end

function bool = redundant(rows, r)
logi =ismember(rows, r, 'rows'); %rows(idx,:), 'rows');
bool = sum(logi) == 1;
end
