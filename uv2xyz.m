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

function [xyz, phitetha] = uv2xyz(uv,imW,imH)
    % Line pixels are projected into the 3D space as spatial rays (Spherical coordinates)

    tetha = -(uv(:,2)-imH/2)*pi/imH;
    phi = (uv(:,1)-imW/2)*2*pi/imW;
    phitetha = [phi tetha];
    
    xyz = zeros(size(uv,1),3);
    xyz(:,1) = sin(phi) .* cos(tetha);
    xyz(:,2) = cos(tetha) .* cos(phi);
    xyz(:,3) = sin(tetha);

end 




