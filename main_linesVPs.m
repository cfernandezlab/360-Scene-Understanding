% Main file to extract lines and vanishing points from RGB panoramas

% load panorama
panorama = imread('im/pano_aaccxxpwmsdgvj.jpg');
panorama = imresize(panorama,[512,1024]);

% Vanishing points and oriented lines
tic;
[vp, lines] = EdgesDetection(panorama);
toc;