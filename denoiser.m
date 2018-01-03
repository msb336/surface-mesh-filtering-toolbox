clearvars;close all;clc
addpath 'readLiDAR' 'Philly Bridge' 'lasdata' 'Functions';
%% Cube
d = [0:1:5];
[x1,y1,z1] = meshgrid(d,d,d);
[x2,y2,z2] = meshgrid(d,d+5,d);
[x3,y3,z3] = meshgrid(d,d+5,d+5);
[x4,y4,z4] = meshgrid(d,d-5,d);
x = [x1;x2;x3;x4];
y = [y1;y2;y3;y4];
z = [z1;z2;z3;z4];

%%
p = unique([x(:),y(:),z(:)], 'rows');
pnoise = p+0.4*rand(size(p));

%% Laplacian Smoothing
psort = sortbydistance(pnoise);
plap = laplaceSmoothing(pnoise,2);

%% Ground Truth
t = constrainTriangle(delaunayTriangulation(p),2);
[ft, fp] = freeBoundary(t);
% [pc] = isotropicLaplacian(fp,ft, 0.5);
FR = triangulation(ft, fp);
figure; h1 = trisurf(FR); title('Ground Truth');
%% Raw Noise
t = constrainTriangle(delaunayTriangulation(pnoise),2);
[ft, fp] = freeBoundary(t);
% [pc] = isotropicLaplacian(fp,ft, 0.5);
FR = triangulation(ft, fp);
figure; h2 = trisurf(FR); title('20% Induced Noise');

%% Filtered
t = constrainTriangle(delaunayTriangulation(plap),2);
[ft, fp] = freeBoundary(t);
[pc] = isotropicLaplacian(fp,ft, 0.5);
FR = triangulation(ft, pc);
figure; h3 = trisurf(FR); title(' Discrete Anisotropic Laplacian');
view([-90,0]);

%%
stlwrite('cubeshape_noise.stl', ft, fp);










