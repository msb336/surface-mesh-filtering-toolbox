addpath functions
clearvars;close all;clc

%%
[x,y] = meshgrid(-50:50, -50:50);
p = planeModel([1 0 1 50]);
if p.Parameters(3) ~= 0
    z = -(p.Parameters(1)*x + p.Parameters(2)*y +p.Parameters(4))/p.Parameters(3);

else
    z = zeros(size(x));
end
    t = findZTransformation(p);
numpoints = numel(x);
xyz = [x(:) y(:) z(:) ones(numpoints, 1)];

transformed = (t*xyz')';
scatter3(transformed(:,1), transformed(:,2), zeros(numpoints,1))
hold on;
surf(x,y,z)
