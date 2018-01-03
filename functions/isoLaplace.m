function [ smoothTri ] = isoLaplace( varargin )
%ISOLAPLACE filter surfaces using the isotropic Laplacian fairing
%method
% Inputs:
% triObj - triangulation objection
% lam > 0- reduction factor (default 0.1)
% mu < -lam - expansion factor (default 0)
% minAngle - minimum angle to satisfy halt criteria ( default 15 )
% maxIter - maximum iterations before halt (default 10)

 
% S(i+1) = S(i) + (lam + mu) u(S(i)) + lam*mu*u(S(i))^2
% So far best smoothing results have been lam = 0.1, mu = 0. Unfortunately
% this causes the mesh to expand greatly in size.
defaults = {0.1, 0, 15, 10};

if isempty(varargin)
    error('Requires at least one input argument');
elseif length(varargin) > 1
    for i = 2:length(varargin)
        defaults{i-1} = varargin{i};
    end
end
triObj = varargin{1};
lam = defaults{1};
mu = defaults{2};
minAngle = defaults{3};
maxiter = defaults{4};


switch nargin
    case 1
        lam = 0.1;
        mu = 0;
        minAngle = 15;
    case 2
        mu = 0;
        minAngle = 15;
    case 3
        minAngle = 15;
end

% Pull connection list and points from inputs
con = triObj.ConnectivityList;
pold = triObj.Points;

% Set empty matrix for smoothed point cloud
pnew = zeros(size(pold));
% Iterative smoothing for numiter iterations
crit = 0;
iter = 0;
while iter < maxiter && crit == 0
    for idx = 1:length(pold)
        % Calculate umbrella function vector
        u = umbrella(con,pold, idx);
        % Laplace Smoothing
        pnew(idx,:) = pold(idx,:) + ( (lam + mu)*u + lam*mu*u.^2);
    end
    % Set old point values to newest values
    pold = pnew;
    crit = checkCrit(con, pnew, minAngle);
    iter = iter + 1;
end
% Create new triangulation object
fprintf(num2str(iter));

smoothTri = triangulation(con, pnew);
end


%%%%%%%%%%%%%% Functions %%%%%%%%%%%%%%%
function u = umbrella(con, points, idx)
% u(xi) = (1/(sum(wj)) (sum(wj*xj) - xi
% wj = ||xi - xj||^-1

% Find all rows containing point index
[r,~] = find(con == idx);
neighbors = [];

% Find all neighbors for index point
for i = 1:length(r)
    row = con(r(i),:);
    neighbors = [neighbors row(row~=idx)];
end
neighbors = unique(neighbors);

p = points(idx,:);
for j = 1:length(neighbors)
    w(j) = 1/norm(p - points(neighbors(j),:));
end

sumw = sum(w);
sumwj = sum(w'.*points(neighbors, :));% - p;

u = (1/sumw)*sumwj-p;
end


function bool = checkCrit(con, points, criteria)
bool = 1;
for rows = 1:length(con)
    connectedpoints = points(con(rows, :),:);
    vectors = [connectedpoints(1,:) - connectedpoints(2,:); ...
               connectedpoints(3,:) - connectedpoints(2,:)];
    angle = dot(vectors(1,:), vectors(2,:))/(norm(vectors(1,:))*norm(vectors(2,:)));
    if angle < criteria
        bool = 0;
        break
    end
end

end



