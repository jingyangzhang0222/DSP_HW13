close all
clear

% load image and basic process ¡ý
img = imread('daytona_1024.png');
gimg = double(img);
[height, width] = size(gimg);
imin = min(min(gimg));
imax = max(max(gimg));

h1 = ones(1, 9)/9;
h2 = [1 8 28 56 70 56 28 8 1] / 256;
h3 = ones(1, 5)/5;
h4 = [1 4 6 4 1] / 16;
H1 = convmtx(h1', width);
H2 = convmtx(h2', width);
d_second_order = [1 -2 1]';
D = convmtx(d_second_order, width);
lam1 = 0.1;
lam2 = 1;
lam3 = 5;

% create blurred image
b_img1 = zeros(height, width + 9 - 1);
b_img2 = zeros(height, width + 9 - 1);
for i=1:height
    b_img1(i, :)=conv(gimg(i, 1 : width), h1);
    b_img2(i, :)=conv(gimg(i, 1 : width), h2);
    b_img3(i, :)=conv(gimg(i, 1 : width), h3);
    b_img4(i, :)=conv(gimg(i, 1 : width), h4);
end
[bheight1, bwidth1] = size(b_img1);
[bheight2, bwidth2] = size(b_img2);

%Add noise
b_img1_L_noi = b_img1 + 5 * randn(bheight1, bwidth1);
b_img1_M_noi = b_img1 + 15 * randn(bheight1, bwidth1);
b_img1_H_noi = b_img1 + 25 * randn(bheight1, bwidth1); 
b_img2_L_noi = b_img2 + 5 * randn(bheight2, bwidth2);
b_img2_M_noi = b_img2 + 15 * randn(bheight2, bwidth2);
b_img2_H_noi = b_img2 + 25 * randn(bheight2, bwidth2);

%deconvolution
d_b_img1_L_noi_lam1 = ((H1'*H1 + lam1 * D'*D) \ (H1' * b_img1_L_noi'))';
d_b_img1_M_noi_lam1 = ((H1'*H1 + lam1 * D'*D) \ (H1' * b_img1_M_noi'))';
d_b_img1_H_noi_lam1 = ((H1'*H1 + lam1 * D'*D) \ (H1' * b_img1_H_noi'))';
d_b_img2_L_noi_lam1 = ((H1'*H1 + lam1 * D'*D) \ (H2' * b_img2_L_noi'))';
d_b_img2_M_noi_lam1 = ((H1'*H1 + lam1 * D'*D) \ (H2' * b_img2_M_noi'))';
d_b_img2_H_noi_lam1 = ((H1'*H1 + lam1 * D'*D) \ (H2' * b_img2_H_noi'))';

d_b_img1_L_noi_lam2 = ((H2'*H2 + lam2 * D'*D) \ (H1' * b_img1_L_noi'))';
d_b_img1_M_noi_lam2 = ((H2'*H2 + lam2 * D'*D) \ (H1' * b_img1_M_noi'))';
d_b_img1_H_noi_lam2 = ((H2'*H2 + lam2 * D'*D) \ (H1' * b_img1_H_noi'))';
d_b_img2_L_noi_lam2 = ((H2'*H2 + lam2 * D'*D) \ (H2' * b_img2_L_noi'))';
d_b_img2_M_noi_lam2 = ((H2'*H2 + lam2 * D'*D) \ (H2' * b_img2_M_noi'))';
d_b_img2_H_noi_lam2 = ((H2'*H2 + lam2 * D'*D) \ (H2' * b_img2_H_noi'))';

d_b_img1_L_noi_lam3 = ((H1'*H1 + lam3 * D'*D) \ (H1' * b_img1_L_noi'))';
d_b_img1_M_noi_lam3 = ((H1'*H1 + lam3 * D'*D) \ (H1' * b_img1_M_noi'))';
d_b_img1_H_noi_lam3 = ((H1'*H1 + lam3 * D'*D) \ (H1' * b_img1_H_noi'))';
d_b_img2_L_noi_lam3 = ((H1'*H1 + lam3 * D'*D) \ (H2' * b_img2_L_noi'))';
d_b_img2_M_noi_lam3 = ((H1'*H1 + lam3 * D'*D) \ (H2' * b_img2_M_noi'))';
d_b_img2_H_noi_lam3 = ((H1'*H1 + lam3 * D'*D) \ (H2' * b_img2_H_noi'))';

figure (1)
imshow(gimg,[imin,imax]); 
title('Original Image');

figure (2)
subplot(2,2,1)
imshow(b_img1, [imin, imax])
title('Blurred Image 1 by Averaging Filter, L = 9');
subplot(2,2,2)
imshow(b_img2, [imin, imax])
title('Blurred Image 2 by Weighted Filter, L = 9');
subplot(2,2,3)
imshow(b_img3, [imin, imax])
title('Blurred Image 3 by Averaging Filter, L = 5');
subplot(2,2,4)
imshow(b_img4, [imin, imax])
title('Blurred Image 4 by Weighted Filter, L = 5');

figure (3)
subplot(2,3,1)
imshow(b_img1_L_noi, [imin, imax]); 
title('Blurred Image 1, Low Noise');
subplot(2,3,2)
imshow(b_img1_M_noi, [imin, imax]); 
title('Blurred Image 1, Mid Noise');
subplot(2,3,3)
imshow(b_img1_H_noi, [imin, imax]); 
title('Blurred Image 1, High Noise');
subplot(2,3,4)
imshow(b_img2_L_noi, [imin, imax]); 
title('Blurred Image 2, Low Noise');
subplot(2,3,5)
imshow(b_img2_M_noi, [imin, imax]); 
title('Blurred Image 2, Mid Noise');
subplot(2,3,6)
imshow(b_img2_H_noi, [imin, imax]); 
title('Blurred Image 2, High Noise');

figure(4)
subplot(2,3,1)
imshow(d_b_img1_L_noi_lam1,[imin,imax])
title('Img1, Low Noise Deconvolution (2nd, \lambda = 0.10)');
subplot(2,3,2)
imshow(d_b_img1_M_noi_lam1,[imin,imax])
title('Img1, Mid Noise Deconvolution (2nd, \lambda = 0.10)');
subplot(2,3,3)
imshow(d_b_img1_H_noi_lam1,[imin,imax])
title('Img1, High Noise Deconvolution (2nd, \lambda = 0.10)');
subplot(2,3,4)
imshow(d_b_img2_L_noi_lam1,[imin,imax])
title('Img2, Low Noise Deconvolution (2nd, \lambda = 0.10)');
subplot(2,3,5)
imshow(d_b_img2_M_noi_lam1,[imin,imax])
title('Img2, Mid Noise Deconvolution (2nd, \lambda = 0.10)');
subplot(2,3,6)
imshow(d_b_img2_H_noi_lam1,[imin,imax])
title('Img2, High Noise Deconvolution (2nd, \lambda = 0.10)');

figure (5)
subplot(2,3,1)
imshow(d_b_img1_L_noi_lam2,[imin,imax])
title('Img1, Low Noise Deconvolution (2nd, \lambda = 1.00)');
subplot(2,3,2)
imshow(d_b_img1_M_noi_lam2,[imin,imax])
title('Img1, Mid Noise Deconvolution (2nd, \lambda = 1.00)');
subplot(2,3,3)
imshow(d_b_img1_H_noi_lam2,[imin,imax])
title('Img1, High Noise Deconvolution (2nd, \lambda = 1.00)');
subplot(2,3,4)
imshow(d_b_img2_L_noi_lam2,[imin,imax])
title('Img2, Low Noise Deconvolution (2nd, \lambda = 1.00)');
subplot(2,3,5)
imshow(d_b_img2_M_noi_lam2,[imin,imax])
title('Img2, Mid Noise Deconvolution (2nd, \lambda = 1.00)');
subplot(2,3,6)
imshow(d_b_img2_H_noi_lam2,[imin,imax])
title('Img2, High Noise Deconvolution (2nd, \lambda = 1.00)');

figure (6)
subplot(2,3,1)
imshow(d_b_img1_L_noi_lam3,[imin,imax])
title('Img1, Low Noise Deconvolution (2nd, \lambda = 5.00)');
subplot(2,3,2)
imshow(d_b_img1_M_noi_lam3,[imin,imax])
title('Img1, Mid Noise Deconvolution (2nd, \lambda = 5.00)');
subplot(2,3,3)
imshow(d_b_img1_H_noi_lam3,[imin,imax])
title('Img1, High Noise Deconvolution (2nd, \lambda = 5.00)');
subplot(2,3,4)
imshow(d_b_img2_L_noi_lam3,[imin,imax])
title('Img2, Low Noise Deconvolution (2nd, \lambda = 5.00)');
subplot(2,3,5)
imshow(d_b_img2_M_noi_lam3,[imin,imax])
title('Img2, Mid Noise Deconvolution (2nd, \lambda = 5.00)');
subplot(2,3,6)
imshow(d_b_img2_H_noi_lam3,[imin,imax])
title('Img2, High Noise Deconvolution (2nd, \lambda = 5.00)');