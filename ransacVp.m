function [linesInliers bestVPs] = ransacVp(iterations,data)

bestDirections = [];
bestVPs = [];
sum_OldPoints = 0;
linesInliers = 0;

normales = []; %Las normales de todas las lineas
for i=1:length(data)
   normales(:,i) = data(i).normal;  
end

for k=1:iterations
    % Posibles VP
    randomP = randperm(size(normales,2));
    n1 = normales(:,randomP(1));
    n2 = normales(:,randomP(2));
    n3 = normales(:,randomP(3));
    v1 = cross(n1,n2);
    v2 = cross(v1,n3);
    v3 = cross(v1,v2);
    v = [v1,v2,v3]';
    v = normr(v);
    
    angle= abs(v*normales);
    [vpmin, id_vpmin] = min(angle);
    
    threshold = abs(sin(0.05)); % 0.05
    valido = find(vpmin < threshold);
    
    sum_NewPoints = 0;

    for j=1:length(valido)
        sum_NewPoints = sum_NewPoints + length(data(valido(j)).LinePoints);
    end
    if sum_NewPoints > sum_OldPoints
        sum_OldPoints = sum_NewPoints;
        linesInliers = length(valido)/length(data);
%         bestDirections(j).normal = normales(:,valido(j));
%         bestDirections(j).vp = v(id_vpmin(valido(j)),:);
%         bestDirections(j).LinePoints = data(valido(j)).LinePoints;
%         bestDirections(j).inliersProp = linesInliers;
        bestVPs = v;
    end
    
    
    
%     if length(valido) > length(bestDirections)
%         for j=1:length(valido)
%             bestDirections(j).normal = normales(:,valido(j));
%             bestDirections(j).vp = v(id_vpmin(valido(j)),:);
%             bestDirections(j).LinePoints = data(valido(j)).LinePoints;
%             bestVPs = v;
%         end
%         length(valido)
%     elseif length(valido) == length(bestDirections)
%         sum_NewPoints = 0;
%         sum_OldPoints = 0;
%         for j=1:length(valido)
%             sum_NewPoints = sum_NewPoints + length(data(valido(j)).LinePoints);
%             sum_OldPoints = sum_OldPoints + length(bestDirections(j).LinePoints);
%         end
%         if sum_NewPoints > sum_OldPoints
%             bestDirections(j).normal = normales(:,valido(j));
%             bestDirections(j).vp = v(id_vpmin(valido(j)),:);
%             bestDirections(j).LinePoints = data(valido(j)).LinePoints;
%             bestVPs = v;
%         end
%     end
    
end

end