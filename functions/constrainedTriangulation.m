function [smooth] = constrainedTriangulation(p)
    tri = delaunayTriangulation(p);
    %% Apply Constraints
    conTri = constrain(tri, 0.5);

    %% Isotropic Laplacian Smoothing
    smooth =conTri;% isoLaplace(conTri);
end

