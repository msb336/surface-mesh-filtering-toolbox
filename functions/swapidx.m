function [new_idx] = swapidx(key,set)
%SWAPIDX Changes index number based on two column vector key
new_idx = arrayfun(@(x)(key(key(:,1)==x, 2)), set);
end

