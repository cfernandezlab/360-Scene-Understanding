function [bestInliers,bestOutliers] = ransacEdges(iterations,data,imH)

bestOutliers = [];
bestInliers = [];

for k=1:iterations
    
    % posibles inliers 
    randomP = randperm(size(data,2));
    r1 = [ data(1,randomP(1)), data(2,randomP(1)), data(3,randomP(1)) ];
    r2 = [ data(1,randomP(2)), data(2,randomP(2)), data(3,randomP(2)) ];
   
    n=cross(r1,r2); 
    n=normr(n)';
    
    cosTetha = n'*data; % tetha=90º
    
    threshold = 0.008;  %cos(6.59*180/imH); 
    inliers = abs(cosTetha) < threshold; %0.008;
    outliers = find(~inliers);
    inliers = find(inliers);
    
    if size(inliers,2) > size(bestInliers,2)
        bestInliers = inliers;
        bestOutliers = outliers;
    end 
    
end

end