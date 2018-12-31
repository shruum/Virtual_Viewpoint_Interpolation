function whitebalance
 
% performs white balancing of images. 

i1=imread('image1(2)');         % read both images
i2=imread('image2(2)');

image1=imread('image1(2)');
image2=imread('image2(2)');

r1=double(i1(:,:,1));      
g1=double(i1(:,:,2));
b1=double(i1(:,:,3));

r2=double(i2(:,:,1));
g2=double(i2(:,:,2));
b2=double(i2(:,:,3));
                                  
% z=[(255/double(rw)) 0 0; 0 (255/double(gw)) 0; 0 0 (255/double(bw))];
z=[1 0 0; 0 1 0; 0 0 1];

for i=1:1200                                     % shifting all the pixels in the image with respect to a white reference point
    for j=1:1600 
    y=[r1(i,j);g1(i,j);b1(i,j)];
    a1=z*double(y);
    r1b(i,j)=a1(1);
    g1b(i,j)=a1(2);
    b1b(i,j)=a1(3);
    
    y=[r2(i,j);g2(i,j);b2(i,j)];
    a2=z*double(y);
    r2b(i,j)=a2(1);
    g2b(i,j)=a2(2);
    b2b(i,j)=a2(3);     
    end
end

i1(:,:,1)=r1b;
i1(:,:,2)=g1b;
i1(:,:,3)=b1b;

i2(:,:,1)=r2b;
i2(:,:,2)=g2b;
i2(:,:,3)=b2b;

   figure(1)                         % display images before and after white balancing
        
    subplot(2,2,1)
   image(uint8(image1))
    subplot(2,2,2)
   image(uint8(image2))
    subplot(2,2,3)
   image(uint8(i1))
     subplot(2,2,4)
   image(uint8(i2))
   
rect_r1=imhist((image1(:,:,1)));
rect_g1=imhist((image1(:,:,2)));
rect_b1=imhist((image1(:,:,3)));

rect_r2=imhist((image2(:,:,1)));
rect_g2=imhist((image2(:,:,2)));
rect_b2=imhist((image2(:,:,3)));

image_reshape_bal1=reshape(i1,size(i1,1)*size(i1,2),3);
image_reshape_bal2=reshape(i2,size(i2,1)*size(i2,2),3);

hist_r1b=imhist((i1(:,:,1)));
hist_g1b=imhist((i1(:,:,2)));
hist_b1b=imhist((i1(:,:,3)));

hist_r2b=imhist((i2(:,:,1)));
hist_g2b=imhist((i2(:,:,2)));
hist_b2b=imhist((i2(:,:,3)));

    figure(2)                       % display histograms of images before and after white balancing
    
     subplot(3,3,1) 
   plot(rect_r1);
   axis([0 255 0 6*10^4])
    subplot(3,3,2)
   plot(rect_g1)
    axis([0 255 0 6*10^4])
   subplot(3,3,3)
   plot(rect_b1)
    axis([0 255 0 6*10^4])
   subplot(3,3,4)
   plot(rect_r2)
    axis([0 255 0 6*10^4])
       subplot(3,3,5)
   plot(rect_g2)
    axis([0 255 0 6*10^4])
      subplot(3,3,6)
   plot(rect_b2)
   axis([0 255 0 6*10^4])
   
    figure(3)
    
        subplot(3,3,1)
   plot(hist_r1b)
    axis([0 255 0 6*10^4])
    subplot(3,3,2)
   plot(hist_g1b)
    axis([0 255 0 6*10^4])
   subplot(3,3,3)
   plot(hist_b1b)
   axis([0 255 0 6*10^4])
   subplot(3,3,4)
   plot(hist_r2b)
   axis([0 255 0 6*10^4])
       subplot(3,3,5)
   plot(hist_g2b)
   axis([0 255 0 6*10^4])
      subplot(3,3,6)
   plot(hist_b2b)
   axis([0 255 0 6*10^4])
    
    