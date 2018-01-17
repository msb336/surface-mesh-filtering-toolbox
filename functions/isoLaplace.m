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
tic
defaults = {0.1, -0.2, 15, 30};

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


neighbors = arrayfun(@(x)findNeighbors(con, x), 1:max(con(:)), 'UniformOutput', false);

while iter < maxiter && crit == 0
    
    for idx = 1:length(pold)
        % Calculate umbrella function vector
        u = umbrella(neighbors{idx}, pold, idx);
        % Laplace Smoothing
        pnew(idx,:) = pold(idx,:) + ( (lam + mu)*u + lam*mu*u.^2);
    end
    % Set old point values to newest values
    pold = pnew;
%     crit = checkCrit(con, pnew, minAngle);
    iter = iter + 1;
end
% Create new triangulation object

smoothTri = triangulation(con, pnew);
fprintf('time taken: %d', toc)
end


%%%%%%%%%%%%%% Functions %%%%%%%%%%%%%%%
function u = umbrella(neighbors, points, idx)
% u(xi) = (1/(sum(wj)) (sum(wj*xj) - xi
% wj = ||xi - xj||^-1

p = points(idx,:);
dif = p - points(neighbors,:);
twonorm = sqrt(dif(:,1).^2+dif(:,2).^2+dif(:,3).^2);
w = 1./twonorm;


sumw = sum(w);
sumwj = sum(w(:).*points(neighbors, :));

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



