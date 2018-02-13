clearvars;close all;clc;
addpath functions data
%%
shape = 'read';
noise_level = 0;
definition = 0.4;
hol = buildshape(shape,definition, noise_level);
%%
allpoints = hol(1:10000,:);
%% Build Shape
shp = alphaShape(allpoints);
constraints.Length = 0.1;
smooth = constrain(shp.boundaryFacets, allpoints, constraints);
%% Determine Free edges and points
free_edges = boundedcheck(smooth);
z = (1:length(smooth.Points))';
allcon = sort(smooth.ConnectivityList,2);
un_idx = allcon(:);
freepts = z(~ismember(z,un_idx));
freeidx = sort([free_edges; freepts]);
nec_connections = allcon(sum(ismember(allcon,freeidx),2)>=2,:);
%%
for i = [3 2 3 2 3 2]
    %%
    points = smooth.Points(free_edges,:);
    %%
    figure; trisurf(smooth);
    hold on; scatter3(points(:,1), points(:,2), points(:,3), '*r'); title(num2str(i));
    waitforbuttonpress;
    %%
    conn = defineNewConnections(nec_connections, free_edges, i, allpoints);
    
    %%
    smooth = triangulation([allcon; conn], smooth.Points);
    %%
    free_edges = boundedcheck([allcon; conn], free_edges);
    %%
    allcon = unique(smooth.ConnectivityList, 'rows');
    un_idx = allcon(:);
    freepts = z(~ismember(z,un_idx));
    freeidx = sort([free_edges; freepts]);
    nec_connections = allcon(any(ismember(allcon,freeidx),2),:);
end
%%
figure; h = trisurf(smooth);