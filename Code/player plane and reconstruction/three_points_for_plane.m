function x3=three_points_for_plane(x1,r,theta)

% calculates 3 points on the player to estimate a plane according to every
% angle

theta=(theta/180)*pi;
% rx=rx/2;
% ry=ry/2;

x = r*cos(theta);    
y = r*sin(theta);    
z = x1(3);

x3=[x1(1)+x ; x1(2)-y; z];