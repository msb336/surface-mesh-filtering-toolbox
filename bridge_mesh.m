clearvars;close all;clc

addpath 'readLiDAR' 'Philly Bridge' 'lasdata' 'Functions';

%% Read LAS file and convert to mesh
b = lasdata('full_resolution - Cloud.las', 10);

p = [b.x b.y b.z];

% 
% figure;plot3(b.x, b.y, b.z, 'b.', 'markers', 1)
% figure; trisurf(t, b.x, b.y, b.z);

%% %% To load 1:1 dataset: %% %%
% Load max amount of points allowable for memory
% save file location
% Append to csv
% Repeat until finished


%%
csvwrite('bridge.csv', p);

%%
p = csvread('bridge.csv');
%% Initial Sort
temp = p(1:1000:end,:);

%%
del = delaunayTriangulation(temp);

%%
t = constrainTriangle(del, 25);
tetramesh(t);
% %% kmeans cluster
% K = 50;
% X = temp;
% [G,C] = kmeans(X, K, 'distance','sqeuclidean', 'start','sample');
% 
% %% Visualize Cluster
% clr = lines(K);
% figure, hold on
% scatter3(X(:,1), X(:,2), X(:,3), 36, clr(G,:), 'Marker','.')
% % scatter3(C(:,1), C(:,2), C(:,3), 100, clr, 'Marker','o', 'LineWidth',3)
% hold off
% view(3), axis vis3d, box on, rotate3d on
% xlabel('x'), ylabel('y'), zlabel('z')
% %% Sort
% for i = 1:K
%     points = X((G==i),:);
%     t = delaunayTriangulation(points);
%     [ft, fp] = freeBoundary(t);
%     FR = triangulation(ft, fp);
%     trisurf(FR);
%     hold on
%     pause(0.1)
% end
% axis equal
