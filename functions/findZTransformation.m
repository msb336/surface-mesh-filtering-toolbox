function [ rot ] = findZTransformation( v1 )
%FINDZTRANSFORMATION determine transformation matrix (non-homogenous) from
%v1 to z axis

%% turn both vectors into unit vectors
v1 = v1/norm(v1);

theta(1) = atan(v1(2)/v1(3));
theta(2) = atan(v1(1)/v1(3));
theta(isnan(theta)) = 0;

rot = [1 0 0; 0 cos(theta(1)) -sin(theta(1)); 0 sin(theta(1)) cos(theta(1))] ...
    * [cos(theta(2)) 0 sin(theta(2)); 0 1 0; -sin(theta(2)) 0 cos(theta(2))];



end

