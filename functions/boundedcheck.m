function [ points ] = boundedcheck( tri, previous )
%BOUNDEDCHECK determines all boundary edges of triangulation object tri
if isa(tri, 'triangulation')
    con = tri.ConnectivityList;
else
    con = tri;
end

if nargin == 2
    if ~isempty(previous)
    con = con(logical(sum(ismember(con,previous),2)), :);
    end
end

s = size(con);
mult =[1 0 0; 0 1 0; 1 0 0; 0 0 1; 0 1 0; 0 0 1];
edgevec = mult*con';
rows = sort(reshape(edgevec, 2, s(1)*3)',2);

r = unique(rows, 'rows');
bool = arrayfun(@(x1,x2)redundant(rows, [x1 x2]), r(:,1), r(:,2));

edges = r(bool,:);
points = unique(edges(:));
end

function bool = redundant(rows, r)
logi =ismember(rows, r, 'rows'); %rows(idx,:), 'rows');
bool = sum(logi) == 1;
end
