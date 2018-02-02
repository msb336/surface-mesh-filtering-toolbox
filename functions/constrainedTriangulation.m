function [smooth] = constrainedTriangulation(p)
    tri = delaunayTriangulation(p);
    %% Apply Constraints
    constraints.Length = 0.5; %findNearest(p,10);
    conTri = constrain(tri, constraints);

    %% Isotropic Laplacian Smoothing
    smooth =conTri;% isoLaplace(conTri);
end

