function [collapsedmesh] = collapse(pointset,balloon, step)
%COLLAPSE - collapse balloon onto pointset

pc = pointCloud(pointset);
balloonpoints = balloon.Points;

balloonCloud = pointCloud(balloon.Points);
l = length(pointset);
centroid = sum(pointset)/l;
index = [];

tic
while true %length(index) < balloonCloud.Count %&& toc < 10
    [balloonpts, index]  = pair(pc, balloonpoints, 0.5);
    balloonpts(~index, :) = (centroid - balloonpts(~index, :))*step + balloonpts(~index, :);
    plot3dvectors(balloonpts, '.')
%     t = triangulation(balloon.ConnectivityList, balloonpts);
%     h = trisurf(t);
%     h.FaceColor = 'None';
%     plot3dvectors(pointset, '.');
    hold off
    plot3(0,0,0)
end

[length(index) balloonCloud.Count]

end

function [ptset, logi] = pair(ptCloud, ptset, threshold)

pairidx = arrayfun(@(x)neighborhunt(x), 1:length(ptset));
logi = pairidx~=0;
index = pairidx(logi);
ptset(pairidx~=0,:) = ptCloud.Location(index,:);



function index = neighborhunt(i)
    
    p = ptset(i,:);
    neigh = ptCloud.findNearestNeighbors(p, 1);
    
    if norm(ptCloud.Location(neigh,:) -p) <= threshold
        index = neigh(1);
    else
        index = uint32(0);
    end
    if length(index) > 1
    end
end
end
