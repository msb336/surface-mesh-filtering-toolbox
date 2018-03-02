function [balloon] = buildballoon(pts)
%BUILDBALLOON creates a large hollow surface mesh balloon object to flatten
%onto the specified pointcloud
l = length(pts);

centroid = sum(pts)/l;
relative = pts - centroid;

maxval = max(sqrt(relative(:,1).^2+relative(:,2).^2 + relative(:,3).^2));

[x,y,z] = sphere(ceil(sqrt(l)+1));
sphere_points = unique([x(:) y(:) z(:)], 'rows');
sphere_points(randperm(length(sphere_points), length(sphere_points) - l),:) = [];



balloon = constrain(delaunayTriangulation(sphere_points*maxval+centroid), 5);
end

