clearvars;close all;clc;
addpath functions data
%%
shape = 'l';
noise_level = 0;
definition = 0.5;
hol = buildshape(shape,definition, noise_level);
%%
shp = alphaShape(hol);
smooth = constrain(shp.boundaryFacets, hol, sqrt(2*0.5^2));
figure;trisurf(smooth);
%%
for i = [2 3]
%% Determine Free edges and points
free_edges = boundedcheck(smooth);
z = (1:length(smooth.Points))';
allcon = sort(smooth.ConnectivityList,2);
un_idx = allcon(:);
freepts = z(~ismember(z,un_idx));
freeidx = sort([free_edges; freepts]);
nec_connections = allcon(sum(ismember(allcon,freeidx),2)>=2,:);

%% Fill holes
conn = defineNewConnections(nec_connections, free_edges, i,hol);
%%
smooth = triangulation([allcon; conn], smooth.Points);
end
free_edges = boundedcheck(smooth);
figure;trisurf(smooth);xlabel('x');ylabel('y');zlabel('z');
plot3dvectors(hol(free_edges,:), '*')