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
free_edges = boundedcheck(smooth);
while ~isempty(free_edges) && constraints.Length < 1
constraints.Length = constraints.Length + 0.1;
%%
un_idx = smooth.ConnectivityList;
un_idx = un_idx(:);
z = (1:length(smooth.Points))';

%%
freeidx = unique(sort([free_edges(:); z(~ismember(z,un_idx))]));

%%
t = triangulateNearest(smooth.Points(freeidx,:));
conn = freeidx(t);
%%
smooth = constrain([smooth.ConnectivityList; conn], smooth.Points, constraints);

%%
free_edges = boundedcheck(smooth, freeidx);
end
%%
figure; h = trisurf(smooth);