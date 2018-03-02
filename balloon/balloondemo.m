clearvars;close all;clc
%% Build Shape
shape = buildshape('l', 0.3, 0);

%% Balloon it
bal = collapse(shape);

%%
h = trisurf(bal);
plot3dvectors(shape, '*');