clearvars;clc;
addpath functions data

%%
shape = 'read';
shape = lower(shape);
noise_level = 0;
definition = 0.2;
%%
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
        [x,y,z] = sphere(ceil(100/definition));
        p = unique([x(:), y(:), z(:)],'rows');
    case 'read'
        points = csvread('bridge.csv');

end

%% k-means cluster
K = 5;
chunk = points(1:50000,:);
[G, C] = kmeans(chunk, K);

for i = 1:K
%% 
p = points(G==i,:);
%% Noise
pnoise = p + noise_level*(randn(size(p))-0.5);
% figure;scatter3(p(:,1), p(:,2), p(:,3), '.')


%% Triangulation
tri = delaunayTriangulation(pnoise);

%% Apply Constraints
constraints.Length = findNearest(pnoise,15);
constraints.Angle = 0;
conTri = constrain(tri, constraints);

%% Ground Truth
% ctri = delaunayTriangulation(p);
% ccon = constrain(ctri, constraints);
% %% Plot Triangulation
% figure; h1 = trisurf(conTri);view(-108,20);title('No Smoothing');
% axis equal
%% Isotropic Gaussian Fairing
smooth = isoLaplace(conTri);
%%
trisurf(smooth);
hold on

end

view(-108,20);
title('Smoothed');
axis equal
%% Mean Curvature Flow

%% Shape Error
%%% Need a function to find points as they relate to originals
% unsmoothed = mean((pnoise(:) - p(:))./p(:));
% isosmoothed = mean((smooth.Points(:) - p(:))./p(:));

