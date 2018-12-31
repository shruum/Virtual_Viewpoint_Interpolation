
function groundhomography

% performs ground based homography on the two images and provides the
% difference image between the two projections

i1=imread('image1(2)');
i2=imread('image2(2)');
load cam1.mat
load cam2.mat

P1=test1.P;
P2=test2.P;
P1inv=test1.Pinv;
P1=P1(:,[1 2 4]);
P2=P2(:,[1 2 4]);
P1i=inv(P1);
P2i=inv(P2);

%%% homograpghy estimated
H1=P2*P1i; 
H2=P1*P2i;
i3=zeros(1200,1600,3);



load groundregion                  % groundregion represents the ground only region of image1
% r=roipoly(i1);
% r1=logical(zeros(1200,1600));
% 
% r=not(xor(r,r1));

i1r=i1(:,:,1);
i1g=i1(:,:,2);
i1b=i1(:,:,3);

i1r(~groundregion)=0;
i1g(~groundregion)=0;
i1b(~groundregion)=0;
i1(:,:,1)=i1r;
i1(:,:,2)=i1g;
i1(:,:,3)=i1b;
figure,imshow(i1)

b=zeros(1200,1600);
c=zeros(1200,1600);


for a=1:1200

x=ones(3,1600);
x(2,:)=a;
x(1,:)=[1:1:1600];

% applying homography

y=H1*x;
y1=repmat(y(3,:),3,1);
y2=y./y1;
y2=y2([1 2],:);

y2=round(y2);
 
b(a,:)=y2(1,:);
c(a,:)=y2(2,:);

end

% projecting homography of image2 on image1 and then finding the error
% between the two
for i=1:1200
    for j=1:1600
        if b(i,j)>1600 || b(i,j)<=0 || c(i,j)<=0 || c(i,j)>1200 || i1(i,j)==0
%             i3(i,j,:)=0;
              i1(i,j,:)=0;
           err(i,j)=0;
        else
            i3(i,j,:)=i2(c(i,j),b(i,j),:);
            i1(i,j,:)=i1(i,j,:);
err(i,j)=sqrt((double(i1(i,j,1))-double(i2(c(i,j),b(i,j),1))).^2+(double(i1(i,j,2))-double(i2(c(i,j),b(i,j),2))).^2 +(double(i1(i,j,3))-double(i2(c(i,j),b(i,j),3))).^2);
        end
    end
end

figure, imshow(i1)
figure, imshow(uint8(i3))
figure, imshow(uint8(err))