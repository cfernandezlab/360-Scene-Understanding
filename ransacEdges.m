function [bestInliers,bestOutliers] = ransacEdges(iterations,data,imH)

bestOutliers = [];
bestInliers = [];

for k=1:iterations
    
    randomP = randperm(size(data,2));
    r1 = [ data(1,randomP(1)), data(2,randomP(1)), data(3,randomP(1)) ];
    r2 = [ data(1,randomP(2)), data(2,randomP(2)), data(3,randomP(2)) ];
   
    n=cross(r1,r2); 
    n=normr(n)';
    cosTetha = n'*data; 
    
    threshold = 0.008;  
    inliers = abs(cosTetha) < threshold; 
    outliers = find(~inliers);
    inliers = find(inliers);
    
    if size(inliers,2) > size(bestInliers,2)
        bestInliers = inliers;
        bestOutliers = outliers;
    end 
    
end

end