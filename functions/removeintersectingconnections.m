function [newobj] = removeintersectingconnections(triobj, string)
%REMOVEINTERSECTINGCONNECTIONS remove any triangulation connctions that
%intersect with others
%   connections - nx3 index of connectivity
%   points - nx3 point cloud
%   string - either 'EDGE' or 'POINT'. edge searches connectivity list for
%   shared edges, point searches for shared points.
connections = triobj.ConnectivityList;
points = triobj.Points;
newlist = connections;
order = [1 2; 1 3; 2 3];
switch lower(string)
    case 'edge'
        total = 2;
    case 'point'
        total = 1;
end
        
%% Check for condition shared an edge
for i = 1:length(connections)
    if ~all(newlist(i, :) == [0 0 0])
    row = connections(i,:);
    rowvec = row(order);
    sharededge = sum(connections == row(1) | connections == row(2) | connections == row(3), 2) == total;
    index = find(sharededge);
    questionable = connections(sharededge,:);
    s = size(questionable,1);
    for j = 1:s
        if ~all(newlist(index(j),:) == [0 0 0])
            currentquest = questionable(j,:);
            vectors = currentquest(order);
            vectors = vectors(~ismember(vectors,rowvec,'rows'),:);
            rowvecs = rowvec(~ismember(rowvec,vectors,'rows'),:);
            for k = 1:length(vectors)
                vec1 = points(vectors(k,:),:);
                for l = length(rowvecs)
                    vec2 = points(rowvecs(k,:),:);
                    bool = intersection(vec1,vec2);
                    if bool == true
                        newlist(index(j),:) = [0 0 0];
                        break
                    end
                end
            end
        end
    end
    end
end
%%
newlist = newlist(all(newlist~=0,2),:);
newobj= triangulation(newlist, points);
end


function r = getuniquerows(con)
s = size(con);
mult =[1 0 0; 0 1 0; 1 0 0; 0 0 1; 0 1 0; 0 0 1];
edgevec = mult*con';
rows = sort(reshape(edgevec, 2, s(1)*3)',2);
r = unique(rows, 'rows');
end

function bool = intercheck(con,pts, edge)
checkindex = [pts.findNearestNeighbors(edge(1), 20);pts.findNearestNeighbors(edge(2), 20)];
checkindex = checkindex(checkindex~=edge(1) | checkindex~=edge(2));


end
