% Main file to extract lines and vanishing points from RGB panoramas
% vp = [vx; vy; vz]
% lines contain their pixel and spatial position, normal direction and the
% vanishing direction to which it is associated (x,y,z).

% load panorama
panorama = imread('img/pano_aaccxxpwmsdgvj.jpg');
panorama = imresize(panorama,[512,1024]);

% Vanishing points and oriented lines
tic;
[vp, lines] = EdgesDetection(panorama);
toc;