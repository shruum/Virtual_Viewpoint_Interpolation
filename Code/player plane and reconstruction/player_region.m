
function [r1 r2]=player_region(Point1,Point2,Point3,r,theta)

% estimates player region for the plane selected

i1=imread('image1(2)');
im1=i1;
i2=imread('image2(2)');
im2=i2;
load cam1.mat
load cam2.mat

P1=test1.P;
P2=test2.P;

r=r+5;
theta=(theta/180)*pi;
z=Point1(3);
rz=Point2(3)-10;

for i=1

center5=[Point1;1];
poi5 = P1*center5;
point5 = poi5./poi5(3);
poi55 = P2*center5;
point55= poi55./poi55(3);

center6=[Point1(1)-r;Point1(2);z;1];
poi6 = P1*center6;
point6 = poi6./poi6(3);
poi66 = P2*center6;
point66= poi66./poi66(3);

center1=[Point1(1)-r;Point1(2);rz;1];
poi1 = P1*center1;
point1 = poi1./poi1(3);
poi11 = P2*center1;
point11= poi11./poi11(3);

center4=[Point1(1)+r;Point1(2);z;1];
poi4 = P1*center4;
point4 = poi4./poi4(3);
poi44 = P2*center4;
point44= poi44./poi44(3);

center3=[Point1(1)+r;Point1(2);rz;1];
poi3 = P1*center3;
point3 = poi3./poi3(3);
poi33 = P2*center3;
point33= poi33./poi33(3);

center2=[Point2(1);Point2(2);rz;1];
poi2 = P1*center2;
point2= poi2./poi2(3);
poi22 = P2*center2;
point22= poi22./poi22(3);
% 
% figure,imshow(i1); hold on;
% plot(point1(1), point1(2), 'yo-')
% hold on;
% plot(point2(1), point2(2), 'yo-')
% hold on;
% plot(point3(1), point3(2), 'yo-')
% hold on;
% plot(point4(1), point4(2), 'yo-')
% hold on;
% plot(point5(1), point5(2), 'yo-')
% hold on;
% plot(point6(1), point6(2), 'yo-')
% % 
% figure,imshow(i2); hold on;
% plot(point11(1), point11(2), 'yo-')
% hold on;
% plot(point22(1), point22(2), 'yo-')
% hold on;
% plot(point33(1), point33(2), 'yo-')
% hold on;
% plot(point44(1), point44(2), 'yo-')
% hold on;
% plot(point55(1), point55(2), 'yo-')
% hold on;
% plot(point66(1), point66(2), 'yo-')


c1=[round(point1(1)) round(point2(1)) round(point3(1)) round(point4(1)) round(point5(1)) round(point6(1))];
d1=[round(point1(2)) round(point2(2)) round(point3(2)) round(point4(2)) round(point5(2)) round(point6(2))];
r1=roipoly(i1,c1,d1);

c2=[round(point11(1)) round(point22(1)) round(point33(1)) round(point44(1)) round(point55(1)) round(point66(1))];
d2=[round(point11(2)) round(point22(2)) round(point33(2)) round(point44(2)) round(point55(2)) round(point66(2))];
r2=roipoly(i2,c2,d2);
% 
% i1r1=im1(:,:,1);
% i1g1=im1(:,:,2);
% i1b1=im1(:,:,3);
% i1r1(~r1)=0;
% i1g1(~r1)=0;
% i1b1(~r1)=0;
% i1(:,:,1)=i1r1;
% i1(:,:,2)=i1g1;
% i1(:,:,3)=i1b1;
% figure, imshow(i1)

% i1r2=im2(:,:,1);
% i1g2=im2(:,:,2);
% i1b2=im2(:,:,3);
% i1r2(~r2)=0;
% i1g2(~r2)=0;
% i1b2(~r2)=0;
% i2(:,:,1)=i1r2;
% i2(:,:,2)=i1g2;
% i2(:,:,3)=i1b2;
% figure, imshow(i2)
end
