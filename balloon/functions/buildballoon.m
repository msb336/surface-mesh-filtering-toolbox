function [balloon] = buildballoon(pts)
%BUILDBALLOON creates a large hollow surface mesh balloon object to flatten
%onto the specified pointcloud
l = length(pts);
centroid = sum(pts)/l;
relative = pts - centroid;
maxval = max((relative(:,1).^2+relative(:,2).^2+relative(:,3).^2).^0.5);
[x,y,z] = sphere(ceil(sqrt(l)-1));
balloon = constrain(delaunayTriangulation([x(:), y(:), z(:)]*maxval+centroid), 5);
end

