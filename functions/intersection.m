function [intersect] = intersection(vector1,vector2)
%INTERSECTION determine if two 3D line segments intersect
v2 = [vector2(1,:) - vector2(2,:)  1]';
t1 = [[1 0 0; 0 1 0; 0 0 1; 0 0 0] [-vector2(2,:)'; 1]];
%% Rotation
theta1 = atan(v2(2)/v2(3));
theta1(isnan(theta1)) = 0;
rot1 = [1 0 0 0; ...
    0 cos(theta1) -sin(theta1) 0; ...
    0 sin(theta1) cos(theta1) 0; ...
    0 0 0 1];
temp = rot1*v2;
theta2 = -atan(temp(1)/temp(3));
theta2(isnan(theta2)) = 0;
rot2 = [cos(theta2) 0 sin(theta2) 0; 0 1 0 0; -sin(theta2) 0 cos(theta2) 0; 0 0 0 1];

%% full transformation
trans = rot2*rot1*t1;
modded = trans*[vector1'; 1 1];
modded2 = trans*[vector2'; 1 1];
unit = modded(1:3,1) - modded(1:3,2)/norm(modded(1:3,1) - modded(1:3,2));
skewness = abs(modded(1,1)/unit(1) - modded(2,1)/unit(2)) < 0.001;

if skewness
    inter = modded(3,1) - unit(3)*skewness(1);

    %% Intersection check
    signs = sign(round(modded(1:2,:),5));
    signs = signs(all(signs~=0, 2),:);
    if (inter < max(modded2(3,:)) && inter > 0) && any(signs(:,1)~= signs(:,2))
    %% Debug
%     close;
%     subplot(1,2, 1)
%     plot3dvectors(modded(1:3,:), modded2(1:3,:));
%     subplot(1,2,2)
%     plot3dvectors(vector1, vector2);
        intersect = true;
    else
        intersect = false;
    end
else
    intersect = false;
end
end

