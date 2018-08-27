%% FUNCIÓN PARA PASAR DE COORDENADAS XYZ DE LA ESFERA A PIXELES DE LA IMAGEN UV 

%input (x,y,z)
%output (W,H)

function [uv, phitetha] = xyz2uv(xyz, imW, imH)

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