clearvars;close all;clc;
addpath functions data
%%
shape = 'l';
noise_level = 0.01;
definition = 0.3;
pts = buildshape(shape,definition, noise_level); 
hol = pts;


%%
raw1 = nearestTriangulation(hol);
%%
raw = removeintersectingconnections(raw1, 'point');
%%
smooth = raw;

%% Determine Free edges and points
free_edges = boundedcheck(smooth);
%%
figure;trisurf(smooth);xlabel('x');ylabel('y');zlabel('z');axis equal
% plot3dvectors(hol(free_edges, :), 'r*');
%%
z = (1:length(smooth.Points))';
allcon = sort(smooth.ConnectivityList,2);
un_idx = allcon(:);
freepts = z(~ismember(z,un_idx));
freeidx = sort([free_edges; freepts]);
nec_connections = allcon(sum(ismember(allcon,freeidx),2)>=2,:);

conn = defineNewConnections(nec_connections, free_edges, 2,hol);

%%
smooth = triangulation([allcon; conn], smooth.Points);

