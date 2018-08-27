%% FUNCIÓN PARA PASAR DE PIXELES DE LA IMAGEN UV A COORDENADAS XYZ DE LA ESFERA

%input (W,H)

function [xyz, phitetha] = uv2xyz(uv,imW,imH)

    tetha = -(uv(:,2)-imH/2)*pi/imH;
    phi = (uv(:,1)-imW/2)*2*pi/imW;
    phitetha = [phi tetha];
    
    xyz = zeros(size(uv,1),3);
    %xyz(:,1) = cos(tetha) .* sin(phi);
    xyz(:,1) = sin(phi) .* cos(tetha);
    xyz(:,2) = cos(tetha) .* cos(phi);
    xyz(:,3) = sin(tetha);

end 




