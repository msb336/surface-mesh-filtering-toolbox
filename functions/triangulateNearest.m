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
        idx(i,:) = getD(pointSet, [nec_con; idx], index_point, orphans);
    end
end
idx = idx(idx(:,1)~=0, :);

end




function connect = getD(pointset, connections, idx, orphans)
references = connections == idx;

switch sum(sum(references))
    case 2
        rows = any(references, 2);
        necidx = connections(rows,:);
        necidx = necidx(:);
        closest = necidx(necidx~=idx & ismember(necidx, orphans))';
        points = sort([idx closest]);
        crit = [1 1];
    case 0 | 1
        modded_points = pointset(orphans,:);
        distance = sqrt(sum((modded_points-pointset(idx,:)).^2,2));
        [sorted_d, ind] = sort(distance);
        new_ind = ind(sorted_d~=0);
        closest = orphans([ new_ind(1) new_ind(2)])';
        crit = [0 0];
        i = 3;
    otherwise
        rows = any(references, 2);
        necidx = connections(rows,:);
        necidx = necidx(:);
        new_idx = necidx(necidx~=idx & ismember(necidx, orphans))';
        
        crit = [0 0];
        i = 2;
end

    while ~all(crit)
        while ~crit(1)
            orig = pointset(closest,:) - pointset(idx,:);
            v = orig./(orig(:,1).^2+orig(:,2).^2).^0.5;
            if all(v(1,:) == v(2,:)) || all(-v(1,:) == v(2,:))
                closest = orphans([new_ind(1) new_ind(i)])';
                i = i + 1;
            else
                crit(1) =1;
            end
        end
        points = sort([idx closest]);
        if ismember(points, connections, 'rows')
            crit(1) = 0;
            closest = orphans([new_ind(1) new_ind(i)])';
            i = i + 1;
        else
            crit(2) = 1;
        end
    end
end

plot3(pointset(points,1), pointset(points,2), pointset(points,3))

connect = points;

end


function [index] = definedConnections(con, orphans)
s = size(con);
mult =[1 0 0; 0 1 0; 1 0 0; 0 0 1; 0 1 0; 0 0 1];
edgevec = mult*con';
row = sort(reshape(edgevec, 2, s(1)*3)',2);
rowsize = size(row);

for i = 1:length(orphans)
    edgepoints = con(any(con == orphans(i),2),:);
    combos = unique(edgepoints(:)~= orphans(i));
    
end
index = 0;
end
