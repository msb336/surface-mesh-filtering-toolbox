clearvars -except points;clc;close all
addpath functions data

%%
shape = 'read';
shape = lower(shape);
noise_level = 0;
definition = 0.2;
alpha = 0.1;
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
    case 'sphere'
        %% Sphere
        [x,y,z] = sphere(ceil(15/definition));
        p = unique([x(:), y(:), z(:)],'rows');
    case 'read'
        if ~exist('points', 'var')
            points = csvread('bridge.csv');
        end
        %p = points((1:end),:);
end

if noise_level ~= 0
    stdev = std(p);
    p = p + noise_level*randn(size(p)).*stdev;
end

%% Alpha Shape
if strcmpi('read', shape)
    %% k-means cluster
    K = 15;
    chunk = points(1:50000,:);
    outliers = isoutlier(chunk);
    cleaned = chunk(outliers(:,1)==0, :);
    %%
    [G, C] = kmeans(cleaned, K);
else
    K = 15;
    cleaned  = p;
    G = ones(length(cleaned),1);
end
    
%%
smoothed = cell(K,1);


figure
for i = 2% 1:K

    C = i/K;
    p = estimateFace(cleaned(G==i,:), 0.01, 0.1);
    
    shp = alphaShape(p, alpha);
%     while shp.numRegions > 1 || shp.volume == 0
%         alpha = alpha+0.01;
%         shp = alphaShape(p,alpha);
%     end

    %% Removing non-indexed points
    indeces = unique(shp.boundaryFacets);
    ii = (1:length(indeces))';
    key = [indeces, ii];
    relpoints = p(indeces,:);
    newbounds = arrayfun(@(x) swapidx(key, x), shp.boundaryFacets);
    
    %%
    tri = triangulation(newbounds, relpoints);
    smoothed{i} = isoLaplace(tri);
    
    %%
    h = trisurf(smoothed{i});
    h.FaceColor = [(i-1)/K i/(2*K) 1- (i-1)/K];
    hold on
    
end
% figure;scatter3(cleaned(:,1), cleaned(:,2), cleaned(:,3), 0.5, 'b.')
% hold on;scatter3(p(:,1), p(:,2), p(:,3), 0.5, 'r*')


