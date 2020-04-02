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

function [uv, phitetha] = xyz2uv(xyz, imW, imH)
    % Spatial rays are projected into pixels in the image (Spherical coordinates)
    
    xyz = normr(xyz);
    normXY = sqrt( xyz(:,1).^2+xyz(:,2).^2);
    normXY(normXY<0.000001) = 0.000001;
    normXYZ = sqrt( xyz(:,1).^2+xyz(:,2).^2+xyz(:,3).^2);

    tetha = asin(xyz(:,3)./normXYZ);   
    
    phi = asin(xyz(:,1)./normXY);
    valid = xyz(:,2)<0 & phi>=0;
    phi(valid) = pi-phi(valid);
    valid = xyz(:,2)<0 & phi<=0;
    phi(valid) = -pi-phi(valid);
    phitetha = [phi tetha];
    phitetha(isnan(phitetha(:,1)),1) = 0;
    
    u = phi*imW/(2*pi)+imW/2;
    v = -tetha*imH/pi+imH/2;
    uv = [u v];
       
end 
