function [ newpoints ] = makeHollow( pts )
%MAKEHOLLOW Summary of this function goes here
%  Pseudocode:
%  for point in points
%       check if point is local max x,y, or z. if it is, keep it.
thresh = 0.1*max(pts(:));
% d = [ -thresh thresh ];
% [x,y,z] = meshgrid(d,d,d);
% cube = [x(:) y(:) z(:)];
newpoints = [];

for i = 1:length(pts)
    center = pts(i,:);
    temp = pts - center;
    inside = pts(sqrt(sum(temp.^2, 2)) <= thresh, :);
    
    posedges = [max(inside(:,1)) max(inside(:,2)) max(inside(:,3))];
    negedges = [min(inside(:,1)) min(inside(:,2)) min(inside(:,3))];
    
    if any(center == posedges) || any(center == negedges)
        newpoints(end+1,:) = center;
    end
end   

end

