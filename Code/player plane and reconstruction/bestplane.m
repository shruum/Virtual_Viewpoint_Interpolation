
function best_theta=bestplane

% estimates the best plane,i.e. the best angle for a particular player

clear all; clc

format long
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
P1=test1.P;
P2=test2.P;
P1inv=test1.Pinv; 
P2inv=test2.Pinv;

C=test1.position;
C=[C ; 1];

player_number=1:10;                % all the players
rz0=0;
r=50;
theta=0:10:180;                    % all the plane angles
rz=180;
best_theta=zeros(1,size(player_number,2));

                    % find the projectiond for each plane and find the error
for player_num=1:size(player_number,2)
        rx0=center(1,player_number(player_num));
        ry0=center(2,player_number(player_num));

        for theta_num=1:size(theta,2)
                [vplane r1 r2]=player_depth_plane(rx0,ry0,rz0,r,theta(theta_num),rz);      % estimate the plane, vplane has the plane coefficients
                [a b]= find(r1==1);
                i5=uint8(zeros(1200,1600,3));

                for i=1:size(a)
                    i5(a(i),b(i),:)=im1(a(i),b(i),:);
                end
                x(:,1)=b;
                x(:,2)=a;
                x(:,3)=1;
                   
                err=zeros(1200,1600);
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
                i6=zeros(1200,1600,3);
                for i=1:size(y,1)
                    if y(i,2)>1200 || y(i,1)>1600 || y(i,2)<=0 || y(i,1)<=0
                        i6(x(i,2),x(i,1),:)=0;
                    else
                    i6(x(i,2),x(i,1),:)=im2(y(i,2),y(i,1),:);
                %     i7(y(i,2),y(i,1),:)=im1(x(i,2),x(i,1),:);
                    end
                end       

%                 figure, subplot(1,2,1),imshow(uint8(i5))
%                             subplot(1,2,2), imshow(uint8(i6))
                err=((double(i5(:,:,1))-i6(:,:,1)).^2)./(255)^2+((double(i5(:,:,2))-i6(:,:,2)).^2)./(255)^2+((double(i5(:,:,3))-i6(:,:,3)).^2)./(255)^2;
                err1(theta_num)=sum(sum(err));
                clear x y x2 num den d1 P 
        end

[err1_min err1_ind]=min(err1);
best_theta(player_num)=theta(err1_ind);                     % angle providing the least error (best correspondence) is selected as the best plane

clear rx0 ry0 err1 err1_ind
end

best_theta