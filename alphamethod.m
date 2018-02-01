clearvars -except points;clc;close all
addpath functions data

%%
shape = 'read';
shape = lower(shape);
noise_level = 0;
definition = 0.2;
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
    K = 1;
    chunk = points(1:5000,:);
    outliers = isoutlier(chunk);
    cleaned = chunk(outliers(:,1)==0, :);
    %%
    [G, C] = kmeans(cleaned, K);
else
    K = 1;
    cleaned  = p;
    G = ones(length(cleaned),1);
end
    
%%
smoothed = cell(K,1);


figure
for i = 1:K

    C = i/K;
    p = cleaned(G==i,:);
    F = scatteredInterpolant(p(:,1), p(:,2), p(:,3));
    gs = 0.02;
    X = p(:,1);
    Y = p(:,2);
    tx = min(X(:)):gs:max(X(:));
    ty = min(Y(:)):gs:max(Y(:));
    %Scattered X,Y to gridded x,y
    [x,y] = meshgrid(tx,ty);
    %Interpolation over z-axis
    z = F(x,y);
    test = [x(:) y(:) z(:)];
    alpha =  0.1;
    
    shp = alphaShape(test, alpha);
    while shp.numRegions > 1 || shp.volume == 0
        alpha = alpha+0.1;
        shp = alphaShape(test,alpha);
    end

    %% Removing non-indexed points
    indeces = unique(shp.boundaryFacets);
    ii = (1:length(indeces))';
    key = [indeces, ii];
    relpoints = test(indeces,:);
    newbounds = arrayfun(@(x) swapidx(key, x), shp.boundaryFacets);
    
    %%
    tri = triangulation(newbounds, relpoints);
    smoothed{i} = isoLaplace(tri);
    
    %%
    h = trisurf(smoothed{i});
    h.FaceColor = [(i-1)/K i/(2*K) 1- (i-1)/K];
%     h.EdgeColor = 'None';
    hold on
    
end
figure;scatter3(cleaned(:,1), cleaned(:,2), cleaned(:,3), 0.5, 'b.')
hold on;scatter3(test(:,1), test(:,2), test(:,3), 0.5, 'r*')


