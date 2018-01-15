function [new_idx] = swapidx(key,num)
%SWAPIDX Changes index number based on two column vector key
new_idx = key(key(:,1)==num, 2);
end

