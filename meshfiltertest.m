clearvars;close all;clc;
addpath functions
%%
shape = 'sphere';
shape = lower(shape);
noise_level = 0.1;
definition = 0.4;
%%
d = [ -1:definition:1 ];
[x1,y1,z1] = meshgrid(d,d,d);
switch shape
    case 'l'
        %% L
        [x2,y2,z2] = meshgrid(d,d,d+2);
        [x3,y3,z3] = meshgrid(d,d+2,d);
        x = [x1(:); x2(:); x3(:)];
        y = [y1(:); y2(:); y3(:)];
        z = [z1(:); z2(:); z3(:)];
        p = unique([x,y,z], 'rows');
    case 'sphere'
        %% Sphere
        [x,y,z] = sphere(20);
        p = unique([x(:), y(:), z(:)],'rows');
end



%% Noise
pnoise = p + noise_level*(randn(size(p))-0.5);

%% Triangulation
tri = delaunayTriangulation(pnoise);

%% Apply Constraints
constraints.Length = 0.5;
constraints.Angle = 0;
conTri = constrain(tri, constraints);

%% Ground Truth
ctri = delaunayTriangulation(p);
ccon = constrain(ctri, constraints);
%% Plot Triangulation
figure; h1 = trisurf(conTri);view(-108,20);title('No Smoothing');
axis equal
%% Isotropic Gaussian Fairing
smooth = isoLaplace(conTri,0.2, 0, 15, 30);
%%
figure;
h = trisurf(smooth);
% h.FaceColor = 'None';
view(-108,20);
title('Smoothed');
axis equal

%% Mean Curvature Flow

%% Shape Error
%%% Need a function to find points as they relate to originals
unsmoothed = mean((pnoise(:) - p(:))./p(:));
isosmoothed = mean((smooth.Points(:) - p(:))./p(:));

