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
        [x,y,z] = sphere(ceil(10/definition));
        p = unique([x(:), y(:), z(:)],'rows');
    case 'read'
        if ~exist('points', 'var')
            points = csvread('bridge.csv');
            
        end
end




% %% k-means cluster
% K = 200;
% chunk = points(1:5000000,:);
% outliers = isoutlier(chunk);
% cleaned = chunk(outliers(:,1)==0, :);
% %%
% [G, C] = kmeans(cleaned, K);
% %%
% figure
% for i = 1:100
%     C = i/K;
%     data = cleaned(G==i,:);
%     scatter3(data(:,1),data(:,2),data(:,3), 0.5, 'filled', 'MarkerFaceColor', [C 0 1-C])
%     hold on
% end

%% Create Surface mesh
% if ~exist('smooth', 'var')
%     smooth = cell(K,1);
%     for i = 1:K
        %%
%         clc
%         i
%         p = cleaned(G==i,:);
        %% Triangulation
        tri = delaunayTriangulation(p);
        
        %% Apply Constraints
        constraints.Length = findNearest(p,10);
        constraints.Angle = 0;
        conTri = constrain(tri, constraints);
        %% Isotropic Laplacian Smoothing
%         smooth{i} = isoLaplace(conTri);
        smooth = isoLaplace(conTri);
%     end
% end

%% Plot Surface Mesh
% figure
% for i = 1:K
    h = trisurf(smooth);
%     h.FaceColor = [i/K 0 1-i/K];
%     hold on
% end
view(-108,20);
t = sprintf('Smoothed');
title(t);
axis equal



%% Mean Curvature Flow

%% Shape Error
%%% Need a function to find points as they relate to originals
% unsmoothed = mean((pnoise(:) - p(:))./p(:));
% isosmoothed = mean((smooth.Points(:) - p(:))./p(:));

