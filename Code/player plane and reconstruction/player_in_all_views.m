function player_in_all_views

% projects player1 in all the nine viewpoints in between the cameras


clear all; clc
format short
i1=imread('image1(2)');
im1=i1;
i2=imread('image2(2)');
im2=i2;
back1=imread('background1');
back2=imread('background2');
load cam1.mat
load cam2.mat
load player_position.mat
center(1,:)=player_position(1,:);
center(2,:)=player_position(2,:);
player_number=1;                   % select the player
P1=test1.P;
P2=test2.P;
P1inv=test1.Pinv; 
P2inv=test2.Pinv;

rx0=center(1,player_number);
ry0=center(2,player_number);
rz0=0;                            
r=40;                               % width of the player = 40cm
rz=180;                             % height of the player=180 cm
theta=0;                            % angle of the player plane

[vplane r1 r2]=player_depth_plane(rx0,ry0,rz0,r,theta,rz);  % estimate the plane, vplane has the plane coefficients

i1r1=im1(:,:,1);
i1g1=im1(:,:,2);
i1b1=i1(:,:,3);

i1r1(~r1)=0;
i1g1(~r1)=0;
i1b1(~r1)=0;
i1(:,:,1)=i1r1;
i1(:,:,2)=i1g1;
i1(:,:,3)=i1b1;

i1r1=back1(:,:,1);
i1g1=back1(:,:,2);
i1b1=back1(:,:,3);

i1r1(~r1)=0;
i1g1(~r1)=0;
i1b1(~r1)=0;
back1(:,:,1)=i1r1;
back1(:,:,2)=i1g1;
back1(:,:,3)=i1b1;
% figure,imshow(back1)

i1f=double(rgb2gray(i1))-double(rgb2gray(back1));   % background subtraction to estimate the player
i2f=double(rgb2gray(i2))-double(rgb2gray(back2));
% figure,imshow(i1f,[]);
% figure,imshow(i2f,[]);

i3=zeros(1200,1600);

for i=1:1200
    for j=1:1600
%         if i1f(i,j)>-110 && i1f(i,j)<-20
        if (i1f(i,j)>-80 && i1f(i,j)<-20) || (i1f(i,j)>4 && i1f(i,j)<40)
            i3(i,j)=1;
        end
    end 
end

% figure, imshow(i3)
str=strel('disk',5);
i4=imclose(i3,str);
% figure,imshow(i4)
[a b]= find(r1==1);
i5=uint8(zeros(1200,1600,3));

for i=1:size(a)
    i5(a(i),b(i),:)=im1(a(i),b(i),:);
end
% figure, imshow(i5)
    
x(:,1)=b;
x(:,2)=a;
x(:,3)=1;

C=test1.position;
C=[C ; 1];

for i=1:size(x,1);                            % finding the depth of the plane
    
num=-(vplane*C);
den=vplane*(P1inv*x(i,:)'-C);
d1=(num/den);
P=C+((P1inv*x(i,:)'-C)*d1);
x2=P2*P;

% x22=P2*P1i*x;
x2=x2/x2(3);
x2=round(x2);
y(i,1)=x2(1,1);
y(i,2)=x2(2,1);
y(i,3)=1;
end
    
i6=zeros(1200,1600,3);
i7=zeros(1200,1600,3);

for i=1:size(y,1)
    i6(y(i,2),y(i,1),:)=im2(y(i,2),y(i,1),:);
    i7(y(i,2),y(i,1),:)=im1(x(i,2),x(i,1),:);
end       
                     %  generating viewpoints in between the cameras
                           
 for current_cam=1:2
cam{current_cam} = load(['./Cam',num2str(current_cam),'_calib.mat']);
    cam{current_cam}.position = -cam{current_cam}.R'*cam{current_cam}.T; % Position of the camera (== null(cam{current_cam}.P))
    cam{current_cam}.T = (-cam{current_cam}.R)*cam{current_cam}.position; % Correction to be sure that the virtual camera and the reference 
%     camera are computed identically
    cam{current_cam}.P = cam{current_cam}.KK*[cam{current_cam}.R cam{current_cam}.T];
    [u, s, v] = svd(cam{current_cam}.P);
    cam{current_cam}.Pinv = (v*[diag((1./diag(s)),0)'; zeros(1,3)]*u');
 end
 
ivir1=zeros(1200,1600,3);
ivir2=zeros(1200,1600,3);

                     % finding homography for the plane selected in each
                     % viewpoint
 for k=0:0.1:1
    jj=single(k)*10+1;
 camm{jj}=compute_parameters_virtual_camera(cam{1}, cam{2}, k);
 P3=camm{jj}.P;
%  ivir1=zeros(1200,1600,3);
%   ivir2=zeros(1200,1600,3);
 
for i=1:size(x,1);
    
num=-(vplane*C);
den1=vplane*(P1inv*x(i,:)'-C);
den2=vplane*(P2inv*y(i,:)'-C);
d1=(num/den1);
d2=(num/den2);
P11=C+((P1inv*x(i,:)'-C)*d1);
P22=C+((P2inv*y(i,:)'-C)*d2);
x1=P3*P11;
x1=x1/x1(3);
x1=round(x1);

x2=P3*P22;
x2=x2/x2(3);
x2=round(x2);

y1(i,1)=x1(1,1);
y1(i,2)=x1(2,1);

y2(i,1)=x2(1,1);
y2(i,2)=x2(2,1);
end
  
 y1=round(y1);
 y2=round(y2);
for i=1:size(y1,1)
ivir1(y1(i,2),y1(i,1),:)=im1(x(i,2),x(i,1),:);
end
 
% for i=1:size(y2,1)
% ivir2(y2(i,2),y2(i,1),:)=im2(y(i,2),y(i,1),:);
% end
 
imshow(uint8(ivir1)); 
%  figure,
%  imshow(uint8(ivir2)); 
 hold on
 
clear y1 y2 
 end

