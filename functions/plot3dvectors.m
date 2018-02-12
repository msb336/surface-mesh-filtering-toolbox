function plot3dvectors(varargin)
hold on;
for i = 1:length(varargin)
    dataset = varargin{i};
    s = size(dataset);
    
    if s(1) == 3
        dataset = dataset';
    elseif s(2) ~= 3
        error('incompatible size')
        close;
    end
    
    plot3(dataset(:,1), dataset(:,2), dataset(:,3));
end
end

