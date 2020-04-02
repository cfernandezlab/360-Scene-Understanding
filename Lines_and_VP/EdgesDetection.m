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

function [vp, GoodLines] = EdgesDetection(img)

img = uint8(img);
img_show = img;
imgbyn = rgb2gray(img);

%% Lines extraction

% Boundaries detection
img = edge(imgbyn,'canny',[]);
B = bwboundaries(img,'holes');
for i=1:length(B)
    ptsLinea = B{i,1};
    [unique_values] = unique(ptsLinea,'rows');
    B{i,1} = unique_values;
end

% From the boundaries detected, we obtain straight and long enough lines. 
% You can change these thresholds.
min_length_segment = size(img,1)/20;
min_length_segment_vp = size(img,1)/5; 
GoodLines=[];
n_line = 1;
n_line_vp =1;

for i=1:length(B)
    if length(B{i,1}) > min_length_segment
        pts = B{i,1};
        [rays, angles] = uv2xyz([pts(:,2),pts(:,1)],size(img,2),size(img,1));
        data = rays';
        N=size(data,2);
        iter = 100;
        
        n_attempts = 0;
        while size(data,2) > N * 0.1 && n_attempts < 10
            [bestInliers,bestOutliers] = ransacEdges(iter,data,size(img,1));
            if ~isempty(bestInliers)
                if length(bestInliers) > min_length_segment
                    GoodLines(n_line).raysXYZ = data(:,bestInliers);
                    [~,~,V] = svd(GoodLines(n_line).raysXYZ');
                    GoodLines(n_line).normal = V(:,3);
                    GoodLines(n_line).LinePoints = pts(bestInliers,:);
                    n_line = n_line+1;
                end
                if length(bestInliers) > min_length_segment_vp
                    vpLines(n_line_vp).raysXYZ = data(:,bestInliers);
                    [~,~,V] = svd(vpLines(n_line_vp).raysXYZ');
                    vpLines(n_line_vp).normal = V(:,3);
                    vpLines(n_line_vp).LinePoints = pts(bestInliers,:);
                    n_line_vp = n_line_vp+1;
                end
                data = data(:,bestOutliers);
                pts = pts(bestOutliers,:);
                
                if size(data,2) < min_length_segment
                    break;
                end
            end
            n_attempts = n_attempts + 1;
        end
    end     
end

%% Vanishing Points extraction

iterations = 1000;

[inliersProp, bestVPs] = ransacVp(iterations,vpLines);
[vps, id] = max(abs(bestVPs));
vp = bestVPs([id],:);

% Axes selection
vp_x = [vp(1,:);-vp(1,:)];
vp_y = [vp(2,:);-vp(2,:)];
vp_z = [vp(3,:);-vp(3,:)];
idx = find(vp_x(:,1)>0);
idy = find(vp_y(:,2)>0);
idz = find(vp_z(:,3)>0);
vp = [vp_x(idx,:); vp_y(idy,:);vp_z(idz,:)];

% Detect line directions from vanishing points
index_to_delete = [];
for j=1:length(GoodLines)
    n = GoodLines(j).normal;
    cosTetha2 = abs(n'*vp');
    valid = min(cosTetha2);
    if valid < 0.08 
        if cosTetha2(1,1) == valid
            dir = 'x';
            GoodLines(j).direccion = dir;
        elseif cosTetha2(1,2) == valid
            dir = 'y';
            GoodLines(j).direccion = dir;
        elseif cosTetha2(1,3) == valid
            dir = 'z';
            GoodLines(j).direccion = dir;
        else
            GoodLines(j).direccion = [];
            index_to_delete = [index_to_delete, j];
        end
    end
end
GoodLines(index_to_delete) = [];

%% Uncomment to show results

% figure;imshow(img_show); hold on
% vp_x_uv = xyz2uv(vp_x,size(img,2),size(img,1));
% plot(vp_x_uv(:,1),vp_x_uv(:,2),'rx','MarkerSize',25,'LineWidth',10);
% vp_y_uv = xyz2uv(vp_y,size(img,2),size(img,1));
% plot(vp_y_uv(:,1),vp_y_uv(:,2),'bx','MarkerSize',25,'LineWidth',10);
% vp_z_uv = xyz2uv(vp_z,size(img,2),size(img,1));
% plot(vp_z_uv(:,1),vp_z_uv(:,2),'gx','MarkerSize',25,'LineWidth',10);
% for i = 1:length(GoodLines)
%     if GoodLines(i).direccion == 'x'
%         plot(GoodLines(i).LinePoints(:,2),GoodLines(i).LinePoints(:,1),'r.');
%     elseif GoodLines(i).direccion == 'y'
%         plot(GoodLines(i).LinePoints(:,2),GoodLines(i).LinePoints(:,1),'g.');
%     elseif GoodLines(i).direccion == 'z'
%         plot(GoodLines(i).LinePoints(:,2),GoodLines(i).LinePoints(:,1),'b.');
%     end
% end


end
