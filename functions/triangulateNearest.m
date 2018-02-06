function [idx ] = triangulateNearest(nec_con, pointSet, orphans)
%FINDNEAREST search a point set for each point's nearest neighbor
%
%   pointSet - a mxn pointcloud
%   getindex - boolean (true or false). true returns the index location of
%   each point's nearest neighbor as well as the distance between those two
%   points

%%%%You weren't referencing your pointset indices correctly! now you have
%%%%the entire pointset coming in, and it's slow because your scanning the
%%%%entier point set for distance when you only need to scan
%%%%pointset(orphans)
idx = [0 0 0];
for i = 1:length(orphans)
    index_point = orphans(i);
    if ~any(idx == index_point)
        idx(index_point,:) = getD(pointSet, [nec_con; idx], index_point);
    end
end
idx = idx(idx(:,1)~=0, :);

end




function connect = getD(pointset, connections, idx)
distance = sqrt(sum((pointset-pointset(idx,:)).^2,2));
[sorted_d, ind] = sort(distance);
new_ind = ind(sorted_d~=0);
closest =[ new_ind(1) new_ind(2)];
crit = [0 0];
i = 3;
while ~all(crit)
    while ~crit(1)
        orig = pointset(closest,:) - pointset(idx,:);
        v = orig./(orig(:,1).^2+orig(:,2).^2).^0.5;
        if all(v(1,:) == v(2,:)) || all(-v(1,:) == v(2,:))
            closest = [new_ind(1) new_ind(i)];
            i = i + 1;
        else
            crit(1) =1;
        end
    end
    points = sort([idx closest]);
    if ismember(points, connections, 'rows')
        crit(1) = 0;
        i = i + 1;
    else
        crit(2) = 1;
    end
end
connect = points;
end

