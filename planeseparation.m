clearvars;close all;clc;
addpath functions

%%
shape = 'l';
noise_level = 0.00;
definition = 0.2;
hol = buildshape(shape,definition, noise_level);
%% Find Planes
% density = 1/0.3;
% allpoints = planardistribute(hol, maxDistance, maxError, density, maxTime);

%%
allpoints = hol;

%% Build Shape
shp = alphaShape(allpoints);
constraints.Length = 0.5;
smooth = constrain(shp.boundaryFacets, allpoints, constraints);

%% Determine Free edges and points
iter = 0;
free_edges = boundedcheck(smooth);
z = (1:length(smooth.Points))';
allcon = sort(smooth.ConnectivityList,2);
un_idx = allcon(:);
freepts = z(~ismember(z,un_idx));
freeidx = sort([free_edges; freepts]);
nec_connections = allcon(any(ismember(allcon,freeidx),2),:);

while ~isempty(free_edges)
    iter = iter+1;
    constraints.Length = Inf;%constraints.Length + 0.1;
    
    
    %%
    points = smooth.Points(free_edges,:);

    %%
    figure; trisurf(smooth);
    hold on; scatter3(points(:,1), points(:,2), points(:,3), '*r'); title(num2str(iter));
    %%
    
%     t = triangulateNearest(nec_connections, smooth.Points(freeidx,:));
    t = triangulateNearest(nec_connections, smooth.Points, freeidx);
    conn = freeidx(t);
    %%
    %     smooth = constrain(unique([smooth.ConnectivityList; conn], 'rows'), smooth.Points, constraints);
    smooth = triangulation([allcon; conn], smooth.Points);
    %%
    free_edges = boundedcheck(smooth);
    %%
    allcon = unique(smooth.ConnectivityList, 'rows');
    un_idx = allcon(:);
    freepts = z(~ismember(z,un_idx));
    freeidx = sort([free_edges; freepts]);
    nec_connections = allcon(any(ismember(allcon,freeidx),2),:);
end
%%
figure; h = trisurf(smooth);