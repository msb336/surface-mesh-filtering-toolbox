clearvars -except points;clc;close all
addpath functions data

%%
shape = 'l';
shape = lower(shape);
noise_level = 0.1;
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
        p = p + noise_level*randn(size(p));
        
    case 'sphere'
        %% Sphere
        [x,y,z] = sphere(ceil(10/definition));
        p = unique([x(:), y(:), z(:)],'rows');
    case 'read'
        if ~exist('points', 'var')
            points = csvread('bridge.csv');
            
        end
end



if strcmp('read', shape)
%% Plot Raw Point Cloud
scatter3(points(:,1), points(:,2), points(:,3), 0.1, '.b')

    %% k-means cluster
    K = 15;
    chunk = points(1:50000,:);
    outliers = isoutlier(chunk);
    cleaned = chunk(outliers(:,1)==0, :);
    
    %%
    [G, C] = kmeans(cleaned, K);
    
    %% Create Surface mesh
    if ~exist('smooth', 'var')
        smooth = cell(K,1);
        %%
        constraints.Length = 0.07;
        for i = 2%:K
            p = estimateFace(cleaned(G==i,:), 0.01, 0.08);

            %% Triangulation
            tri = delaunayTriangulation(p);
            %% Apply Constraints
            [conTri] = constrain(tri, constraints);
%             %% Alpha Method
%             conTri = buildAlphaTriangulation(p, constraints.Length);
            %% Isotropic Laplacian Smoothing
            smooth{i} = isoLaplace(conTri);
         
        end
%         axis equal
    end
    
    %% Plot Surface Mesh
    figure
    for i = 2%1:K
        h = trisurf(smooth{i});
        h.FaceColor = [i/K 0 1-i/K];
        hold on
    end
    
    
else
    %% Create Surface mesh
    est = estimateFace(p,0.02, 0.08);
    smooth = constrainedTriangulation(est);
    
    %% Plot Surface Mesh
    h = trisurf(smooth);
end

view(-108,20);
t = sprintf('Smoothed');
title(t);
axis equal

%% Save as STL
% stlvar.vertices = smooth.Points; stlvar.faces = smooth.ConnectivityList;
% 
% stlwrite('data\segment.stl', stlvar);

