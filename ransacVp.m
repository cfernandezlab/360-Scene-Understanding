function [linesInliers bestVPs] = ransacVp(iterations,data)

bestDirections = [];
bestVPs = [];
sum_OldPoints = 0;
linesInliers = 0;

normals = [data.normal];

for k=1:iterations

    randomP = randperm(size(normals,2));
    n1 = normals(:,randomP(1));
    n2 = normals(:,randomP(2));
    n3 = normals(:,randomP(3));
    v1 = cross(n1,n2);
    v2 = cross(v1,n3);
    v3 = cross(v1,v2);
    v = [v1,v2,v3]';
    v = normr(v);
    
    angle= abs(v*normals);
    [vpmin, id_vpmin] = min(angle);
    
    threshold = abs(sin(0.05)); 
    valido = find(vpmin < threshold);
    
    sum_NewPoints = 0;
    for j=1:length(valido)
        sum_NewPoints = sum_NewPoints + length(data(valido(j)).LinePoints);
    end  
    
    if sum_NewPoints > sum_OldPoints
        sum_OldPoints = sum_NewPoints;
        linesInliers = length(valido)/length(data);
        bestVPs = v;
    end
    
end

end