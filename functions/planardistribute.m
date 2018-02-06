function allpoints = planardistribute(pc, maxDistance, maxError, density, maxTime)
%PLANARDISTRIBUTE find planes in a pointcloud, and recreate then with some
%desired density

remainPtCloud = pointCloud(pc);
i = 1;
time = 0;

tic
while length(remainPtCloud.Location) > 100 && time < maxTime
    [model{i}, inliers, outliers] = pcfitplane(remainPtCloud, maxDistance);
    clc
    if ~isempty(inliers) && length(inliers) > 100
        temp_plane = select(remainPtCloud, inliers);
        
        tot_inliers = length(inliers);
        plane_dist = model{i}.Parameters*[temp_plane.Location';ones(1, length(inliers))];
        dist_less = plane_dist <= maxDistance*0.5;
        if 0.5*tot_inliers <= sum(dist_less(:))
            points = temp_plane.Location - (model{i}.Normal'.*plane_dist)';
            plane{i} = points;
            remainPtCloud = select(remainPtCloud, outliers);
            i= i + 1;
        end
    end
    time = toc;
end

%%
allpoints = remainPtCloud.Location;
figure; hold on
if exist('plane', 'var')
    for i = 1:length(plane)
        temp = estimateFace(plane{i}, 1/density, maxError);
        trans = findZTransformation(model{i});
        tplane = (trans*[plane{i} ones(size(plane{i},1),1)]')';
        tpoints =(trans*[temp ones(size(temp,1),1)]')';
        hull = boundary(tplane(:,1), tplane(:,2), 0.9);
        in = inpolygon(tpoints(:,1), tpoints(:,2), tplane(hull,1), tplane(hull,2));
        inpoints = tpoints(in,:);
        points = (trans'*inpoints')';
        allpoints = [allpoints; points(:,1:3)];
    end
end

end

