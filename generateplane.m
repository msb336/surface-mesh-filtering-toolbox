addpath functions
clearvars;close all;clc
[x,y] = meshgrid(-50:50, -50:50);
p = planeModel([1 1 1 0]);
if p.Parameters(3) ~= 0
    z = -(p.Parameters(1)*x + p.Parameters(2)*y +p.Parameters(4))/p.Parameters(3);
    t = findZTransformation(p.Normal);
else
    z = zeros(size(x));
end


xyz = [x(:) y(:) z(:)];

transformed = (t*xyz')';
scatter3(transformed(:,1), transformed(:,2), transformed(:,3))
hold on;
surf(x,y,z)
