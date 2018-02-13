clearvars;close all;clc;
addpath functions data
%%
shape = 'l';
noise_level = 0;
definition = 0.3;
hol = buildshape(shape,definition, noise_level);
smooth = nearestTriangulation(hol);
%% Determine Free edges and points
free_edges = boundedcheck(smooth);
z = (1:length(smooth.Points))';
allcon = sort(smooth.ConnectivityList,2);
un_idx = allcon(:);
freepts = z(~ismember(z,un_idx));
freeidx = sort([free_edges; freepts]);
nec_connections = allcon(sum(ismember(allcon,freeidx),2)>=2,:);
%% Fill holes
%%
conn = defineNewConnections(nec_connections, free_edges, 2, hol);

%%
smooth = triangulation([allcon; conn], smooth.Points);
figure;trisurf(smooth)