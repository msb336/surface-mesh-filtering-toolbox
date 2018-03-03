function [collapsedmesh] = collapse(pointset,stepsize, timeout)
%COLLAPSE - collapse balloon onto pointset

if nargin == 1
    stepsize = 0.1;
    timeout = 5;
end

balloon = buildballoon(pointset);
balloonpoints = balloon.Points;

balloonCloud = pointCloud(balloon.Points);
l = length(pointset);
centroid = sum(pointset)/l;
thresh = 0.5;
used_index = [];
newpointset = pointset;

it = 1;


tic
while length(used_index) < 0.99*l && it*stepsize < 1
    [~, balloonpoints, used_index]  = pair(newpointset, balloonpoints, used_index, thresh);
    idx = ~ismember(1:l, used_index);
    balloonpoints(idx, :) = (centroid - balloonpoints(idx, :))*stepsize + balloonpoints(idx, :);
%     plot3dvectors(balloonpoints(idx, :), '.')
%     plot3dvectors(pointset, '.')
%     plot3dvectors(balloonpoints(~idx,:), '*');
%     
%     view([-101,70])
%     axis equal
%     hold off
%     plot3(0,0,0)
it = it+1;
end

% [connectivity] = clean_up(balloon.ConnectivityList,balloonpoints);
connectivity = balloon.ConnectivityList;
collapsedmesh = triangulation(connectivity, balloonpoints);

end




function [newref, moddedballoon, new_used] = pair(referencepoints, balloonpoints, used_index, threshold)
ptCloud = pointCloud(referencepoints);
pairidx = arrayfun(@(x)neighborhunt(x), 1:length(balloonpoints));
new_point_locks = find(pairidx~=0);

new_used = used_index;
new_used = [new_used(:); new_point_locks(:)];

moddedballoon = balloonpoints;
moddedballoon(new_point_locks,:) = referencepoints(pairidx(pairidx~=0),:);

newref = referencepoints;
newref(pairidx(pairidx~=0),:) = [];




    function index = neighborhunt(i)
        if ~ismember(i, used_index)
            p = balloonpoints(i,:);
            neigh = ptCloud.findNearestNeighbors(p, 1);
                if norm(ptCloud.Location(neigh,:) -p) <= threshold %&& ~any(neigh == used_index)
                    index = neigh;
                else
                    index = uint32(0);
                end
        else
            index = uint32(0);
        end
    end

end


function [newcon] = clean_up(con, pts)
[~, dup2unique, ~] = unique(pts, 'rows');

for i = 1:length(dup2unique)
    duplicates = all(pts == pts(dup2unique(i),:), 2);
    con(ismember(con, find(duplicates))) = dup2unique(i);
end

newcon = con;

end
