

function histogram_matching

% Run this code for histogram matching


im2=imread('image1(2)');
im1=imread('image2(2)');

[nr1,nc1,nd1] = size(im1);
region_mask1 = ones(nr1,nc1);
[nr2,nc2,nd2] = size(im2);
region_mask2 = ones(nr2,nc2);

new_im1 = perform_cumulative_histogram_mapping(im1, im2, region_mask1>0, region_mask2>0);

