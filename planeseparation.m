clearvars;close all;clc;
addpath functions

%%
shape = 'l';
shape = lower(shape);
noise_level = 0.00;
definition = 0.1;
d = [ -1:definition:1 ];

switch shape
    case 'l'
        %% L
        [x1,y1,z1] = meshgrid(d,d,d);
        [x2,y2,z2] = meshgrid(d,d,d+2);
        [x3,y3,z3] = meshgrid(d,d+2,d);

        x = [x1(:); x2(:); x3(:)];
        y = [y1(:); y2(:); y3(:)];
        z = [z1(:); z2(:); z3(:)];
        p = unique([x,y,z], 'rows');
        hol = makeHollow(p, definition*1.1);
    case 'sphere'
        %% Sphere
        [x,y,z] = sphere(ceil(10/definition));
        p = unique([x(:), y(:), z(:)],'rows');
        hol = p;
end

%%

hol = hol + noise_level*randn(size(hol));
%%
remainPtCloud = pointCloud(hol);


%% Hand-made
maxDistance = 0.05;
i = 1;
time = 0;

tic
while length(remainPtCloud.Location) > 100 && time < 15
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
bdpoints = [];
figure; hold on
if exist('plane', 'var')
    for i = 1:length(plane)
        temp = estimateFace(plane{i}, 0.2, Inf);
%         scatter3(temp(:,1), temp(:,2), temp(:,3), 3, '*b')
%         scatter3(plane{i}(:,1), plane{i}(:,2), plane{i}(:,3), 3, '.r')
        
        trans = findZTransformation(model{i});
        tplane = (trans*[plane{i} ones(size(plane{i},1),1)]')';
        tpoints =(trans*[temp ones(size(temp,1),1)]')';
        hull = boundary(tplane(:,1), tplane(:,2), 0.9);
        in = inpolygon(tpoints(:,1), tpoints(:,2), tplane(hull,1), tplane(hull,2));
        inpoints = tpoints(in,:);
        points = (trans'*inpoints')';
        allpoints = [allpoints; points(:,1:3)];
        scatter3(points(:,1), points(:,2), points(:,3), 5);
    end
end


%%
scatter3(allpoints(:,1), allpoints(:,2), allpoints(:,3),'.b')

% pcshow(remainPtCloud);

%%
% 
smooth = constrainedTriangulation(allpoints);
% 
figure;h=trisurf(smooth);

