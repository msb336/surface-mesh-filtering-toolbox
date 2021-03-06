function plot3dvectors(varargin)
hold on;

if isa(varargin{end}, 'char')
    it = 1;
    spec = varargin{end};
else
    it = 0;
    spec = '-';
end

for i = 1:length(varargin)-it
    dataset = varargin{i};
    s = size(dataset);
    if s(1) == 3 && s(2)~=3
        dataset = dataset';
    elseif s(2) ~= 3
        error('incompatible size')
        close;
    end
    
    plot3(dataset(:,1), dataset(:,2), dataset(:,3), spec);
end
end

