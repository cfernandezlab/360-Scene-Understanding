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
