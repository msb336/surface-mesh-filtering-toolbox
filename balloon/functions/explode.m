function [explodedpts] = explode(pts)
%EXPLODE - convert pts into a spherical object with radius equal to max
%point distance from centroid of point cloud (pts).
l = length(pts);
centroid = sum(pts)/l;

radvec = pts - centroid;
maxval = max(sqrt(radvec(:,1).^2+radvec(:,2).^2 + radvec(:,3).^2));
radunit = radvec./(radvec(:,1).^2+radvec(:,2).^2+radvec(:,3).^2).^0.5;

explodedpts = radunit*maxval+centroid;

end

