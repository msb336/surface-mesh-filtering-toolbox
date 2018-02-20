function [smooth] = constrainedTriangulation(p)
    tri = delaunayTriangulation(p);
    %% Apply Constraints
    conTri = constrain(tri, Inf);

    %% Isotropic Laplacian Smoothing
    smooth =conTri;% isoLaplace(conTri);
end

