
function [vp, GoodLines, inliersProp] = EdgesDetection(img)

%img = imresize(img,[size(img,1)/6,size(img,2)/6]); %% AHORRAR TIEMPO
img = uint8(img);

% Canny filter
img_show = img;
imgbyn = rgb2gray(img);
img = edge(imgbyn,'canny',[]);
% [~,threshOut] = edge(img,'Canny');
% threshold = threshOut*0.5;
% img = edge(img,'Canny',threshold); 

% bwboundaries
B = bwboundaries(img,'holes');
%B = bwboundaries(img,'noholes');
for i=1:length(B)
    ptsLinea = B{i,1};
    [valores_unicos] = unique(ptsLinea,'rows');
    B{i,1} = valores_unicos;
end

% Aplicar RANSACedge
min_length_segment_vp = size(img,1)/5; % size(img,1)/20
min_length_segment = size(img,1)/20;
GoodLines=[];
n_line = 1;
n_line_vp =1;
% figure;imshow(img_show);hold on;
for i=1:length(B)
    
    if length(B{i,1}) > min_length_segment
        pts = B{i,1};
        
        [rayos, angles] = uv2xyz([pts(:,2),pts(:,1)],size(img,2),size(img,1));
        data = rayos';
        N=size(data,2);
        iter = 100;
        
        n_attempts = 0;
        while size(data,2) > N * 0.1 && n_attempts < 10
            %             plot(pts(:,2),pts(:,1),'r.');
            [bestInliers,bestOutliers] = ransacEdges(iter,data,size(img,1));
            
            if ~isempty(bestInliers)
                if length(bestInliers) > min_length_segment
                    GoodLines(n_line).rayosXYZ = data(:,bestInliers);
                    [~,~,V] = svd(GoodLines(n_line).rayosXYZ');
                    GoodLines(n_line).normal = V(:,3);
                    GoodLines(n_line).LinePoints = pts(bestInliers,:);
                    %                     plot(GoodLines(n_line).LinePoints(:,2),GoodLines(n_line).LinePoints(:,1),'b.');
                    n_line = n_line+1;
                end
                if length(bestInliers) > min_length_segment_vp
                    vpLines(n_line_vp).rayosXYZ = data(:,bestInliers);
                    [~,~,V] = svd(vpLines(n_line_vp).rayosXYZ');
                    vpLines(n_line_vp).normal = V(:,3);
                    vpLines(n_line_vp).LinePoints = pts(bestInliers,:);
                    %                     plot(vpLines(n_line_vp).LinePoints(:,2),vpLines(n_line_vp).LinePoints(:,1),'b.');
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

% figure;imshow(img_show);hold on;
% for i=1:length(GoodLines)
%     plot(GoodLines(i).LinePoints(:,2),GoodLines(i).LinePoints(:,1),'b.');
% end


% Exctract Vanishing Points

iterations = 1000;

[inliersProp, bestVPs] = ransacVp(iterations,vpLines);
[vps, id] = max(abs(bestVPs));
vp = bestVPs([id],:);

vp_x = [vp(1,:);-vp(1,:)];
vp_y = [vp(2,:);-vp(2,:)];
vp_z = [vp(3,:);-vp(3,:)];

% Elección de ejes
idx = find(vp_x(:,1)>0);
idy = find(vp_y(:,2)>0);
idz = find(vp_z(:,3)>0);
vp = [vp_x(idx,:); vp_y(idy,:);vp_z(idz,:)];


%[ rotImg, R ] = rotatePanorama( img, vp );


% 4. Detect line directions segun vanishing points 
%vp_rot = eye(3);
for j=1:length(GoodLines)
    n = GoodLines(j).normal;
    cosTetha2 = abs(n'*vp');
    valido = min(cosTetha2);
    if valido < 0.08 %0.08
        if cosTetha2(1,1) == valido
            dir = 'x';
            GoodLines(j).direccion = dir;
        elseif cosTetha2(1,2) == valido
            dir = 'y';
            GoodLines(j).direccion = dir;
        elseif cosTetha2(1,3) == valido
            dir = 'z';
            GoodLines(j).direccion = dir;
        else
            GoodLines(j).direccion = [];
        end
    end
end

index_to_delete = [];
for j=1:length(GoodLines)
    if isempty(GoodLines(j).direccion)
        index_to_delete = [index_to_delete, j];
    end
end
GoodLines(index_to_delete) = [];

% 
%5. Show the result -> funcion con vp, Goodlines, img
figure(6);imshow(img_show); hold on
vp_x_uv = xyz2uv(vp_x,size(img,2),size(img,1));
plot(vp_x_uv(:,1),vp_x_uv(:,2),'rx','MarkerSize',25,'LineWidth',10);
vp_y_uv = xyz2uv(vp_y,size(img,2),size(img,1));
plot(vp_y_uv(:,1),vp_y_uv(:,2),'bx','MarkerSize',25,'LineWidth',10);
vp_z_uv = xyz2uv(vp_z,size(img,2),size(img,1));
plot(vp_z_uv(:,1),vp_z_uv(:,2),'gx','MarkerSize',25,'LineWidth',10);

%show horizon line
% vp_h=[vp_x;vp_y];
% n=50;
% l_h=[linspace(vp_h(1,1),vp_h(4,1),n);linspace(vp_h(1,2),vp_h(4,2),n);linspace(vp_h(1,3),vp_h(4,3),n)]';
% l_h_im =  xyz2uv(l_h, size(img,2), size(img,1));
% hold on
% plot(l_h_im(:,1),l_h_im(:,2),'k.','MarkerSize',20,'LineWidth',10);

for i = 1:length(GoodLines)
    if GoodLines(i).direccion == 'x'
        plot(GoodLines(i).LinePoints(:,2),GoodLines(i).LinePoints(:,1),'r.');
    elseif GoodLines(i).direccion == 'y'
        plot(GoodLines(i).LinePoints(:,2),GoodLines(i).LinePoints(:,1),'g.');
    elseif GoodLines(i).direccion == 'z'
        plot(GoodLines(i).LinePoints(:,2),GoodLines(i).LinePoints(:,1),'b.');
    end
end


end