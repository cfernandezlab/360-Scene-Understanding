%
%     Copyright (C) 2017  Clara Fernández-Labrador 
%     <cfernandez at unizar dot es> (University of Zaragoza)
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 
%     One may refer to the following paper:
% 
%     "Layouts from Panoramic Images with Geometry and Deep Learning."
%     Clara Fernández-Labrador, Alejandro Perez-Yus , Gonzalo Lopez-Nicolas , Jose J. Guerrero 
%     IEEE Robotics and Automation Letters and oral presentation at IROS, 2018 
% 
%     This work was supported by Projects DPI2014-61792-EXP and DPI2015-
%     65962-R (MINECO/FEDER, UE) and grant BES-2013-065834 (MINECO).

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
