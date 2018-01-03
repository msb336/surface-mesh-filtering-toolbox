function [set] = sortbydistance(data, thresh)
%sortbydistance Sort data points to nearest neighbor



dist = pdist2(data,data);

N = size(data,1);
result = NaN(1,N);
result(1) = 1; % first point is first row in data matrix

for ii=2:N
    dist(:,result(ii-1)) = Inf;
    [mindist(ii), closest_idx(ii)] = min(dist(result(ii-1),:));
    result(ii) = closest_idx(ii);
end

if nargin == 2
    m = mean(mindist(:));
    s = std(mindist(:));
    result = result(mindist <= m+s*thresh);
end


set = data(result, :);


end

