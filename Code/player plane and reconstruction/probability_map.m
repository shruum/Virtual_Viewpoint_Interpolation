function probability_map


clear all; clc

format long
i1=imread('image1(2)');
im1=i1;
i2=imread('image2(2)');
im2=i2;
back1=imread('background1');
back_im1=back1;
back2=imread('background2');
back_im2=back2;
load cam1.mat
load cam2.mat
load player_position.mat
center(1,:)=player_position(1,:);
center(2,:)=player_position(2,:);
player_number=1;
P1=test1.P;
P2=test2.P;
P1inv=test1.Pinv; 
P2inv=test2.Pinv;

rx0=center(1,player_number);
ry0=center(2,player_number);
rz0=0;
r=45;
rz=180;
theta=130;

[vplane r1 r2]=player_depth_plane(rx0,ry0,rz0,r,theta,rz);     

% r1=r1{player_number};
i1r1=i1(:,:,1);
i1g1=i1(:,:,2);
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

i1f=double(rgb2gray(i1))-double(rgb2gray(back1));
sh1=zeros(1200,1600);

for i=1:1200
    for j=1:1600
        if i1f(i,j)>-110 && i1f(i,j)<-20
%         if (i1f(i,j)>-80 && i1f(i,j)<-20) || (i1f(i,j)>4 && i1f(i,j)<40)
            sh1(i,j)=1;
        end
    end 
end

% figure, imshow(i3)
str=strel('disk',5);
i1_white=sh1;
[a b]=find(r1==1);

i1_play=uint8(zeros(1200,1600,3));

for i=1:size(a)
    i1_play(a(i),b(i),:)=im1(a(i),b(i),:);
end
x(:,1)=b;
x(:,2)=a;
x(:,3)=1;

C=test1.position;
C=[C ; 1];

for i=1:size(x,1);
    
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
i22=zeros(1200,1600,3);

for i=1:size(y,1)
    i22(x(i,2),x(i,1),:)=im2(y(i,2),y(i,1),:);
%     i7(y(i,2),y(i,1),:)=im1(x(i,2),x(i,1),:);
end       
%  figure, imshow(uint8(i11)); 
%  figure, imshow(uint8(i22)); 

err=((double(i1_play(:,:,1))-i22(:,:,1)).^2)./(255)^2+((double(i1_play(:,:,2))-i22(:,:,2)).^2)./(255)^2+((double(i1_play(:,:,3))-i22(:,:,3)).^2)./(255)^2;
figure,imshow(err,[]);
err1=zeros(1200,1600,3);
for i=1:1200
for j=1:1600
if err(i,j)<0.04 && err(i,j)>0.01
err1(i,j,1)=255;
elseif err(i,j)>0.001 && err(i,j)<.01
    err1(i,j,2)=255;
end
end
end
% figure,imshow(err1)

back22=zeros(1200,1600,3);
for i=1:size(y,1)
    back22(x(i,2),x(i,1),:)=back_im2(y(i,2),y(i,1),:);
%     i7(y(i,2),y(i,1),:)=im1(x(i,2),x(i,1),:);
end
% figure,imshow(back22);
i2f=double((rgb2gray(uint8(i22))))-double((rgb2gray(uint8(back22))));
% figure,imshow(i2f,[]);
sh4=zeros(1200,1600);

for i=1:1200
    for j=1:1600
        if i2f(i,j)>-110 && i1f(i,j)<-20
%         if (i1f(i,j)>-80 && i1f(i,j)<-20) || (i1f(i,j)>4 && i1f(i,j)<40)
            sh4(i,j)=1;
        end
    end 
end

% figure, imshow(sh4)
str=strel('disk',5);
% i2_white=imclose(sh4,str);
i2_white=sh4;
% figure, imshow(i2_white)
[a b]= find(i2_white==1);
i2_play=(zeros(1200,1600,3));

for i=1:size(a)
    i2_play(a(i),b(i),:)=i22(a(i),b(i),:);
end
ixor=xor(i1_white,i2_white);
imap=zeros(1200,1600,3);
imul=i1_white.*i2_white;

for i=1:1200
for j=1:1600
if imul(i,j)==1
imap(i,j,1)=255;
end
end
end

[a2 b2]=find(ixor==1);
for  i=1:size(a2,1)
imap(a2(i),b2(i),2)=255;
end
figure, imshow(imap);

[a1 b1]= find(i1_white==1);
i1_play1=(zeros(1200,1600,3));
for i=1:size(a1)
    i1_play1(a1(i),b1(i),:)=im1(a1(i),b1(i),:);
end